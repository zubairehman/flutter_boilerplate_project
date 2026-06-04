# lib/data/secure_storage/

## Responsibility
Provides `SecureStorageHelper` — a typed wrapper over `flutter_secure_storage` for reading/writing sensitive key-value data (auth tokens). Secure storage uses platform keychain (iOS) and encrypted SharedPreferences (Android).

## Design Patterns
- **Facade pattern**: `SecureStorageHelper` wraps `FlutterSecureStorage`, exposing domain-specific methods (`authToken`, `saveAuthToken`, `removeAuthToken`) instead of raw key-value access.
- **Async-only API**: All read/write operations are async since platform secure storage requires async I/O.

## Data & Control Flow
1. `FlutterSecureStorage` is initialized with platform-specific options (Android: `encryptedSharedPreferences: true`; iOS: `KeychainAccessibility.first_unlock`).
2. `authToken` → `_secureStorage.read(key: SecureStorageKeys.authToken)` → returns `String?`.
3. `saveAuthToken(token)` → `_secureStorage.write(key: SecureStorageKeys.authToken, value: token)` → returns `true`.
4. `removeAuthToken()` → `_secureStorage.delete(key: SecureStorageKeys.authToken)` → returns `true`.

## Integration Points
- `lib/data/secure_storage/constants/secure_storage_constants.dart` — key name constants.
- `lib/data/di/module/local_module.dart` — initializes and registers `FlutterSecureStorage` and `SecureStorageHelper`.
- `lib/data/di/module/network_module.dart` — `AuthInterceptor` reads `authToken` via `SecureStorageHelper` (replacing previous `SharedPreferenceHelper` usage for auth tokens).
- `lib/data/repository/user/user_repository_impl.dart` — `SecureStorageHelper` is injected (available for future auth use).
- **External**: `flutter_secure_storage` package.