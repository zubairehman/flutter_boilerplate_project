# lib/data/secure_storage/

## Responsibility
Provides `SecureStorageHelper` — a typed wrapper over `flutter_secure_storage` for reading/writing sensitive key-value data (auth tokens, database encryption key). Secure storage uses platform keychain (iOS) and encrypted SharedPreferences (Android).

## Design Patterns
- **Facade pattern**: `SecureStorageHelper` wraps `FlutterSecureStorage`, exposing domain-specific methods (`authToken`, `saveAuthToken`, `removeAuthToken`, `getOrCreateDatabaseEncryptionKey`) instead of raw key-value access.
- **Async-only API**: All read/write operations are async since platform secure storage requires async I/O.
- **Key generation**: `getOrCreateDatabaseEncryptionKey()` generates a cryptographically random 256-bit key on first access, persists it, and returns it on subsequent calls.

## Data & Control Flow
1. `FlutterSecureStorage` is initialized with platform-specific options (Android: `encryptedSharedPreferences: true`; iOS: `KeychainAccessibility.first_unlock`).
2. `authToken` → `_secureStorage.read(key: SecureStorageKeys.authToken)` → returns `String?`.
3. `saveAuthToken(token)` → `_secureStorage.write(key: SecureStorageKeys.authToken, value: token)` → returns `true`.
4. `removeAuthToken()` → `_secureStorage.delete(key: SecureStorageKeys.authToken)` → returns `true`.
5. `getOrCreateDatabaseEncryptionKey()` → reads existing key; if missing, generates 32 random bytes → `base64UrlEncode` → persists → returns key string.

## Integration Points
- `lib/data/secure_storage/constants/secure_storage_constants.dart` — key name constants.
- `lib/data/di/module/local_module.dart` — initializes and registers `FlutterSecureStorage`, `SecureStorageHelper`; calls `getOrCreateDatabaseEncryptionKey()`.
- `lib/data/di/module/network_module.dart` — `AuthInterceptor` reads `authToken` via `SecureStorageHelper`.
- **External**: `flutter_secure_storage` package.