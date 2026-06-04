# lib/data/di/module/

## Responsibility
Contains three DI module classes that register data-layer singletons into the global `getIt` service locator: `LocalModule`, `NetworkModule`, `RepositoryModule`.

## Design Patterns
- **Module pattern**: Each class encapsulates registrations for one concern (local storage, networking, repositories).
- **Async registration**: `SharedPreferences` and `SembastClient` are registered with `registerSingletonAsync` since they require async initialization.

## Data & Control Flow
- `LocalModule`: `SharedPreferences.getInstance` → `SharedPreferenceHelper`; `SembastClient.provideDatabase` → `PostDataSource`.
- `NetworkModule`: `EventBus` → interceptors (`LoggingInterceptor`, `ErrorInterceptor`, `AuthInterceptor`) → `RestClient` → `DioConfigs` → `DioClient` (with interceptors chained) → `PostApi`.
- `RepositoryModule`: `SharedPreferenceHelper` → `SettingRepositoryImpl` / `UserRepositoryImpl`; `PostApi` + `PostDataSource` → `PostRepositoryImpl`.

## Integration Points
- `getIt` from `lib/di/service_locator.dart` — the IoC container.
- `lib/data/sharedpref/shared_preference_helper.dart` — used by both local and repository modules.
- `lib/data/network/apis/posts/post_api.dart` — registered by network module, consumed by repository module.
- `lib/data/local/datasources/post/post_datasource.dart` — registered by local module, consumed by repository module.
- `lib/core/data/network/dio/` — provides `DioClient`, `DioConfigs`, core interceptors.
- `lib/core/data/local/sembast/` — provides `SembastClient`.