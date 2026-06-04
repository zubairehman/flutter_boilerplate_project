# lib/core/data/
## Responsibility
Infrastructure layer for data access: network HTTP client (Dio), local NoSQL database (Sembast), encryption codec (XXTEA), general-purpose crypto service (AES-256-CBC + HMAC-SHA256), and shared preferences abstraction. Houses the concrete implementations that feature repositories depend on.

## Design Patterns
- **Data Source Separation**: `local/`, `network/`, `sharedpref/` are independent packages, each providing a data access primitive.
- **Codec Pattern**: XXTEA encryption uses `dart:convert` `Codec<Map<String, dynamic>, String>` for transparent encrypt/decrypt in Sembast.
- **Key-Derivation Service**: `CryptoService` derives AES-256 key from a password via SHA-256 at construction time.
- **Configurable HTTP**: `DioClient` accepts `DioConfigs` and pluggable interceptors.

## Data & Control Flow
- **Network path**: Repository → `DioClient.dio` → interceptors → HTTP endpoint.
- **Local path**: Repository → `SembastClient.database` → optionally via XXTEA codec → on-disk/WebDB.
- **Crypto path**: Repository/Service → `CryptoService.encrypt/decrypt` for string-level AES-256-CBC; `computeHmac/verifyHmac` for HMAC-SHA256; `hashSha256/hashSha256Bytes` for hashing.
- **Prefs path**: Repository → `BaseSharedPreferenceHelper.clearSharedPreference()`.

## Integration Points
- `network/dio/` → feature repositories for REST API calls.
- `local/sembast/` → feature repositories for persisted entities.
- `local/encryption/` → `SembastClient.provideDatabase()` when encryption key is provided.
- `local/crypto_service.dart` → feature repositories or services for string encryption, HMAC, and hashing.
- `sharedpref/` → feature repositories and DI setup for preference clearing.