# lib/data/

## Responsibility
Data layer of the clean architecture — implements domain repository abstractions by coordinating remote APIs, local databases, and shared preferences. Owns all concrete data sources, DTO/entity mapping, and dependency injection wiring for the data layer.

## Design Patterns
- **Repository pattern**: `PostRepositoryImpl`, `UserRepositoryImpl`, `SettingRepositoryImpl` extend abstract domain repository classes, delegating to data sources (APIs, local DB, SharedPreferences).
- **Module-based DI**: `DataLayerInjection` orchestrates three DI modules (`LocalModule`, `NetworkModule`, `RepositoryModule`) that register all singletons via `getIt` (service_locator.dart).
- **Data source separation**: Remote data via `network/apis/`, local persistence via `local/datasources/`, key-value store via `sharedpref/`.

## Data & Control Flow
1. App startup calls `DataLayerInjection.configureDataLayerInjection()`.
2. `LocalModule` initializes `SharedPreferences` → `SharedPreferenceHelper`, `SembastClient` → `PostDataSource`.
3. `NetworkModule` initializes `DioClient` (with interceptors chain: Auth → Error → Logging), `RestClient`, and API instances (`PostApi`).
4. `RepositoryModule` wires repository implementations, injecting data sources and API instances from the service locator.
5. Domain use cases call repository interfaces; data layer implementations fetch from network and/or local, caching results as needed (e.g., `PostRepositoryImpl.getPosts()` calls `PostApi` then persists each post via `PostDataSource.insert()`).

## Integration Points
- **Upstream**: `lib/domain/repository/` — abstract contracts implemented here.
- **Core**: `lib/core/data/network/dio/` — provides `DioClient`, `DioConfigs`, interceptors (`AuthInterceptor`, `LoggingInterceptor`).
- **Core**: `lib/core/data/local/sembast/` — provides `SembastClient` for NoSQL persistence.
- **DI**: `lib/di/service_locator.dart` — global `getIt` instance used by all modules.
- **External**: `jsonplaceholder.typicode.com` (REST API), `shared_preferences` package, `sembast` package, `dio` package, `http` package.