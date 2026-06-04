# lib/data/network/

## Responsibility
Handles all remote data communication. Houses API endpoint definitions, DTO classes, and API classes. The core `DioClient` (from `lib/core/`) is used for HTTP requests; interceptors (Auth, Logging) are applied via DI. API classes under `apis/` make concrete network requests and return domain entities.

## Design Patterns
- **API-per-resource**: Each API class (e.g., `PostApi`) encapsulates calls for one domain resource.
- **DTO deserialization**: API responses are deserialized into DTOs (`network/dto/`), then converted to domain entities via mapper extensions (`mapper/`).
- **Interceptor chain**: Auth → Logging (debug only) applied to `DioClient` in that order.

## Data & Control Flow
1. `DioClient` (core) executes HTTP requests against `Endpoints.baseUrl`.
2. Interceptors modify requests/responses (attach auth token, log in debug mode).
3. API classes deserialize JSON responses into DTOs, then map to domain entities (e.g., `PostDto.fromJson` → `dto.toDomain()` → `Post`).

## Integration Points
- **Core**: `lib/core/data/network/dio/` — `DioClient`, `DioConfigs`, `AuthInterceptor`, `LoggingInterceptor`.
- **DTO**: `lib/data/network/dto/` — data transfer objects for JSON serialization.
- **Mapper**: `lib/data/mapper/` — DTO ↔ domain entity conversion.
- **Domain**: `lib/domain/entity/` — entity classes used as return types from API calls.
- **Secure storage**: `AuthInterceptor` reads auth tokens from `SecureStorageHelper` (via `getIt`).
- **DI**: `NetworkModule` registers all components.
- **External**: `dio` package.