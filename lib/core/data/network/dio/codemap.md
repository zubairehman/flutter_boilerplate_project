# lib/core/data/network/dio/
## Responsibility
Wraps the `Dio` HTTP client with configurable options (`DioConfigs`) and pluggable interceptors. Central entry point for all HTTP requests in the app.

## Design Patterns
- **Builder-style Setup**: `DioClient` configures `Dio` in its initializer list (baseUrl, connectTimeout, receiveTimeout), then callers add interceptors.
- **Open-Closed**: Interceptors added via `addInterceptors()` without modifying `DioClient` internals.

## Data & Control Flow
1. `DioClient(dioConfigs:)` → creates `Dio` with `baseUrl`, `connectTimeout`, `receiveTimeout`.
2. `addInterceptors([AuthInterceptor, RetryInterceptor, LoggingInterceptor])` → appends to `dio.interceptors`.
3. Repositories call `dioClient.dio.get/post/…` to make requests — interceptors fire in order.

## Integration Points
- `configs/dio_configs.dart` → `DioClient` reads `baseUrl`, timeouts from `DioConfigs`.
- `interceptors/` → injected via `addInterceptors()`.
- Feature repositories and DI → obtain `DioClient` instance.