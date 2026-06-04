# lib/data/network/

## Responsibility
Handles all remote data communication. Houses HTTP client wrappers (`DioClient`, `RestClient`), API endpoint definitions, network interceptors, and exception types. API classes under `apis/` make concrete network requests and return domain entities.

## Design Patterns
- **Dual HTTP client**: `DioClient` wraps `Dio` for full-featured requests (interceptors, cancel tokens, progress); `RestClient` wraps `dart:http` as a lightweight alternative.
- **Interceptor chain**: Auth → Error → Logging applied to `DioClient` in that order.
- **API-per-resource**: Each API class (e.g., `PostApi`) encapsulates calls for one domain resource.

## Data & Control Flow
1. `DioClient`/`RestClient` execute HTTP requests against `Endpoints.baseUrl`.
2. Interceptors modify requests/responses (attach auth token, capture errors, log).
3. API classes deserialize JSON responses into domain entities (e.g., `PostList.fromJson`).
4. `RestClient._createResponse` validates status codes and throws `NetworkException` on failure.

## Integration Points
- **Core**: `lib/core/data/network/dio/` — `DioClient`, `DioConfigs`, `AuthInterceptor`, `LoggingInterceptor`.
- **Domain**: `lib/domain/entity/` — entity classes used as return types from API calls.
- **Secure storage**: `AuthInterceptor` reads auth tokens from `SecureStorageHelper` (via `getIt`).
- **DI**: `NetworkModule` registers all components.
- **External**: `dio` package, `http` package, `event_bus` package.