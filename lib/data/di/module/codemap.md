# lib/data/di/module/

## Responsibility
Contains three DI module classes that register data-layer singletons into the global `getIt` service locator: `LocalModule`, `NetworkModule`, `RepositoryModule`.

## Design Patterns
- **Module pattern**: Each class encapsulates registrations for one concern (local storage + device services, networking, repositories).
- **Async registration**: `SharedPreferences` and `SembastClient` are registered with `registerSingletonAsync` since they require async initialization. Other singletons (`FlutterSecureStorage`, `DeviceInfoService`, `ConnectivityService`, `CryptoService`) are synchronous.

## Data & Control Flow
- `LocalModule`: `FlutterSecureStorage` (with platform options) → `SecureStorageHelper`; `DeviceInfoService`; `ConnectivityService`; `CryptoService`; `SharedPreferences.getInstance` → `SharedPreferenceHelper`; `SembastClient.provideDatabase` → `PostDataSource`.
- `NetworkModule`: `EventBus` → interceptors (`LoggingInterceptor`, `ErrorInterceptor`, `AuthInterceptor` reading token from `SecureStorageHelper`) → `RestClient` → `DioConfigs` → `DioClient` (with interceptors chained) → `PostApi`.
- `RepositoryModule`: `SharedPreferenceHelper` → `SettingRepositoryImpl`; `SharedPreferenceHelper` + `SecureStorageHelper` → `UserRepositoryImpl`; `PostApi` + `PostDataSource` → `PostRepositoryImpl`.

## Integration Points
- `getIt` from `lib/di/service_locator.dart` — the IoC container.
- `lib/data/sharedpref/shared_preference_helper.dart` — used by local and repository modules.
- `lib/data/secure_storage/secure_storage_helper.dart` — used by local and repository modules; also consumed by `AuthInterceptor` in network module.
- `lib/data/network/apis/posts/post_api.dart` — registered by network module, consumed by repository module.
- `lib/data/local/datasources/post/post_datasource.dart` — registered by local module, consumed by repository module.
- `lib/core/data/network/dio/` — provides `DioClient`, `DioConfigs`, core interceptors.
- `lib/core/data/local/sembast/` — provides `SembastClient`.
- `lib/core/data/local/crypto_service.dart` — provides `CryptoService`.