# lib/core/data/
## Responsibility
Infrastructure layer for data access: network HTTP client (Dio), local NoSQL database (Sembast), encryption codec (XXTEA), and shared preferences abstraction. Houses the concrete implementations that feature repositories depend on.

## Design Patterns
- **Data Source Separation**: `local/`, `network/`, `sharedpref/` are independent packages, each providing a data access primitive.
- **Codec Pattern**: XXTEA encryption uses `dart:convert` `Codec<Map<String, dynamic>, String>` for transparent encrypt/decrypt in Sembast.
- **Configurable HTTP**: `DioClient` accepts `DioConfigs` and pluggable interceptors.

## Data & Control Flow
- **Network path**: Repository → `DioClient.dio` → interceptors → HTTP endpoint.
- **Local path**: Repository → `SembastClient.database` → optionally via XXTEA codec → on-disk/WebDB.
- **Prefs path**: Repository → `BaseSharedPreferenceHelper.clearSharedPreference()`.

## Integration Points
- `network/dio/` → feature repositories for REST API calls.
- `local/sembast/` → feature repositories for persisted entities.
- `local/encryption/` → `SembastClient.provideDatabase()` when encryption key is provided.
- `sharedpref/` → feature repositories and DI setup for preference clearing.

| Directory | Responsibility |
|-----------|---------------|
| `local/` | Sembast database client and XXTEA encryption codec |
| `network/` | Dio HTTP client, configs, interceptors |
| `sharedpref/` | Shared preferences abstraction |