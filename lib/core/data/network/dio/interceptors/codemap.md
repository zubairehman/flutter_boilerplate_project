# lib/core/data/network/dio/interceptors/
## Responsibility
HTTP interceptors for the Dio client: authentication token injection (`AuthInterceptor`), automatic retry on transient failures (`RetryInterceptor`), and structured request/response logging with sensitive-value redaction (`LoggingInterceptor`).

## Design Patterns
- **Chain of Responsibility**: Each interceptor handles one cross-cutting concern and delegates to the next.
- **Strategy**: `RetryOptions.retryEvaluator` allows callers to customize retry logic per error type.
- **Configurable Log Level**: `LoggingInterceptor` supports `Level.none/basic/headers/body` for granular output control.
- **Sensitive-Value Redaction**: `LoggingInterceptor._sensitiveKeys` set redacts `authorization`, `cookie`, `set-cookie`, `password`, `token` in logged headers and bodies.

## Data & Control Flow
1. **Auth**: `AuthInterceptor.onRequest` → reads `accessToken()` async → sets `Authorization: Bearer <token>` header via `putIfAbsent` (won't overwrite existing).
2. **Retry**: On `DioException` → `RetryInterceptor.onError` checks `RetryOptions.retries > 0` + `retryEvaluator` → delays by `retryInterval` → re-executes request via `dio.request()` with decremented retry count. Logs retry attempt via `developer.log` when `shouldLog` is true.
3. **Logging**: `LoggingInterceptor` logs request method/URI, headers (redacted), and body (pretty-printed JSON if `compact=false`, with redacted map) at configured `level`.

## Integration Points
- Added to `DioClient` via `addInterceptors()` at DI setup.
- `AuthInterceptor` receives `AsyncValueGetter<String?> accessToken` callback — wired to auth/token store in feature layer.
- `RetryInterceptor` receives `Dio` instance for re-execution; optional `shouldLog` flag (default `true`).