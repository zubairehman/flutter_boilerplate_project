# lib/data/

## Responsibility
Data layer of the clean architecture — implements domain repository abstractions by coordinating remote APIs, local databases, shared preferences, and secure storage. Owns all concrete data sources, DTO/entity mapping, and dependency injection wiring for the data layer.

## Design Patterns
- **Repository pattern**: `PostRepositoryImpl`, `UserRepositoryImpl`, `SettingRepositoryImpl` extend abstract domain repository classes, delegating to data sources (APIs, local DB, SharedPreferences, secure storage).
- **Module-based DI**: `DataLayerInjection` orchestrates three DI modules (`LocalModule`, `NetworkModule`, `RepositoryModule`) that register all singletons via `getIt` (service_locator.dart).
- **Data source separation**: Remote data via `network/apis/`, local persistence via `local/datasources/`, key-value store via `sharedpref/`, sensitive key-value via `secure_storage/`.
- **DTO/mapper separation**: Network responses are deserialized into DTOs (`network/dto/`), then converted to domain entities via mapper extensions (`mapper/`).
- **Layered key-value storage**: Non-sensitive settings in `SharedPreferences` (`sharedpref/`); sensitive data (auth tokens, DB encryption key) in `FlutterSecureStorage` (`secure_storage/`).

## Data & Control Flow
1. App startup calls `DataLayerInjection.configureDataLayerInjection()`.
2. `LocalModule` initializes `FlutterSecureStorage` → `SecureStorageHelper` (generates/retrieves DB encryption key), `SharedPreferences` → `SharedPreferenceHelper`, encrypted `SembastClient` → `PostDataSource`.
3. `NetworkModule` initializes `DioClient` (with interceptors: Auth → Logging in debug), and API instances (`PostApi`). `AuthInterceptor` reads token from `SecureStorageHelper`.
4. `RepositoryModule` wires repository implementations, injecting data sources, API instances, and helpers from the service locator.
5. Domain use cases call repository interfaces; data layer implementations fetch from network and/or local, caching results as needed (e.g., `PostRepositoryImpl.getPosts()` calls `PostApi` then persists each post via `PostDataSource.upsert()`).

## Integration Points
- **Upstream**: `lib/domain/repository/` — abstract contracts implemented here.
- **Core**: `lib/core/data/network/dio/` — provides `DioClient`, `DioConfigs`, interceptors (`AuthInterceptor`, `LoggingInterceptor`).
- **Core**: `lib/core/data/local/sembast/` — provides `SembastClient` for NoSQL persistence.
- **DI**: `lib/di/service_locator.dart` — global `getIt` instance used by all modules.
- **External**: `jsonplaceholder.typicode.com` (REST API), `shared_preferences` package, `flutter_secure_storage` package, `sembast` package, `dio` package.