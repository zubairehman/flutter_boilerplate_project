# lib/core/data/local/
## Responsibility
Local data infrastructure: Sembast NoSQL database client, XXTEA encryption codec for database-level encryption, and AES-based `CryptoService` for general-purpose string encryption/hashing/HMAC. Supports both native and web platforms.

## Design Patterns
- **Strategy via Codec**: XXTEA encryption is injected as a `SembastCodec` at database open time — transparent to callers.
- **Platform-aware Factory**: `SembastClient` selects `databaseFactoryIo` vs `databaseFactoryWeb` based on `kIsWeb`.
- **Key Derivation**: `CryptoService` derives a 32-byte AES-256 key from the constructor password via SHA-256 at instantiation time.

## Data & Control Flow
1. `SembastClient.provideDatabase(databaseName, databasePath, encryptionKey)` opens DB.
2. If `encryptionKey` is non-empty → `getXXTeaCodec(password:)` wraps DB with XXTEA `SembastCodec`.
3. Platform check (`kIsWeb`) selects IO vs Web factory.
4. Returns `SembastClient` exposing `Database` for feature repositories to query.
5. `CryptoService(secretKey)` → SHA-256 derives `_derivedKey` → `encrypt(plainText)` returns base64(IV + AES-CBC ciphertext); `decrypt(cipherText)` reverses.
6. `CryptoService.computeHmac/verifyHmac` → HMAC-SHA256 for message authentication; `hashSha256/hashSha256Bytes` → SHA-256 digests.

## Integration Points
- `encryption/xxtea.dart` → `SembastClient.provideDatabase()` for `SembastCodec`.
- `crypto_service.dart` → feature repositories or services needing string-level encryption, HMAC signing/verification, or SHA-256 hashing.
- `sembast/sembast_client.dart` → feature repository implementations and DI module.