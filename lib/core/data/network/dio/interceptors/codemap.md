# lib/core/data/network/dio/interceptors/
## Responsibility
HTTP interceptors for the Dio client: authentication token injection (`AuthInterceptor`), automatic retry on transient failures (`RetryInterceptor`), and structured request/response logging (`LoggingInterceptor`).

## Design Patterns
- **Chain of Responsibility**: Each interceptor handles one cross-cutting concern and delegates to the next.
- **Strategy**: `RetryOptions.retryEvaluator` allows callers to customize retry logic per error type.
- **Configurable Log Level**: `LoggingInterceptor` supports `Level.none/basic/headers/body` for granular output control.

## Data & Control Flow
1. **Auth**: `AuthInterceptor.onRequest` → reads `accessToken()` async → sets `Authorization: Bearer <token>` header if non-empty.
2. **Retry**: On `DioException` → `RetryInterceptor.onError` checks `RetryOptions.retries > 0` + `retryEvaluator` → delays by `retryInterval` → re-executes request via `dio.request()` with decremented retry count.
3. **Logging**: `LoggingInterceptor` logs request method/URI, headers, and body (pretty-printed JSON if `compact=false`) at configured `level`.

## Integration Points
- Added to `DioClient` via `addInterceptors()` at DI setup.
- `AuthInterceptor` receives `AsyncValueGetter<String?> accessToken` callback — wired to auth/token store in feature layer.
- `RetryInterceptor` receives `Dio` instance for re-execution.