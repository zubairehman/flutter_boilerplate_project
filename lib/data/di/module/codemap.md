# lib/data/di/module/

## Responsibility
Contains three DI module classes that register data-layer singletons into the global `getIt` service locator: `LocalModule`, `NetworkModule`, `RepositoryModule`.

## Design Patterns
- **Module pattern**: Each class encapsulates registrations for one concern (local storage + device services, networking, repositories).
- **Async registration**: `SharedPreferences` and `SembastClient` are registered with `registerSingletonAsync` since they require async initialization. Other singletons (`FlutterSecureStorage`, `SecureStorageHelper`) are synchronous.
- **Encrypted database**: `LocalModule` retrieves/generates a database encryption key from `SecureStorageHelper` before creating `SembastClient`.

## Data & Control Flow
- `LocalModule`: `FlutterSecureStorage` (with platform options) → `SecureStorageHelper`; `SecureStorageHelper.getOrCreateDatabaseEncryptionKey()` → `SembastClient.provideDatabase(encryptionKey:)` → `PostDataSource`; `SharedPreferences.getInstance` → `SharedPreferenceHelper`.
- `NetworkModule`: `LoggingInterceptor` (debug only) → `AuthInterceptor` (reads token from `SecureStorageHelper`) → `DioConfigs` → `DioClient` (with interceptors) → `PostApi`.
- `RepositoryModule`: `SharedPreferenceHelper` → `SettingRepositoryImpl`; `SharedPreferenceHelper` → `UserRepositoryImpl`; `PostApi` + `PostDataSource` → `PostRepositoryImpl`.

## Integration Points
- `getIt` from `lib/di/service_locator.dart` — the IoC container.
- `lib/data/sharedpref/shared_preference_helper.dart` — used by local and repository modules.
- `lib/data/secure_storage/secure_storage_helper.dart` — used by local module and by `AuthInterceptor` in network module.
- `lib/data/network/apis/posts/post_api.dart` — registered by network module, consumed by repository module.
- `lib/data/local/datasources/post/post_datasource.dart` — registered by local module, consumed by repository module.
- `lib/core/data/network/dio/` — provides `DioClient`, `DioConfigs`, core interceptors.
- `lib/core/data/local/sembast/` — provides `SembastClient`.