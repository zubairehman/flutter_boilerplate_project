# lib/core/data/network/
## Responsibility
Network infrastructure: HTTP client configuration (Dio) and an interceptor chain (auth, retry, logging with sensitive-value redaction). Provides all HTTP communication primitives for feature repositories.

## Design Patterns
- **Interceptor Chain**: `AuthInterceptor` → `RetryInterceptor` → `LoggingInterceptor` layered on `DioClient.dio`.
- **Config Object**: `DioConfigs` encapsulates base URL and timeouts with internal defaults; no external constants class.
- **Retry with Backoff**: `RetryInterceptor` uses `RetryOptions` with configurable retry count, interval, and evaluator. Logs via `developer.log` when `shouldLog` is true.
- **Sensitive Redaction**: `LoggingInterceptor` redacts `authorization`, `cookie`, `set-cookie`, `password`, `token` values in log output.

## Data & Control Flow
1. Repository constructs `DioClient(dioConfigs:)` → configures `Dio` instance.
2. Interceptors added via `DioClient.addInterceptors([auth, retry, logging])`.
3. **Request flow**: `AuthInterceptor.onRequest` injects Bearer token → `LoggingInterceptor.onRequest` logs (redacted) → HTTP call → `LoggingInterceptor.onResponse` logs result → on error `RetryInterceptor.onError` evaluates retry.
4. `RetryInterceptor` decrements `RetryOptions.retries` per attempt, delays by `retryInterval`, re-executes original request.

## Integration Points
- `dio/dio_client.dart` → feature repositories and DI module for HTTP client instance.
- `dio/interceptors/` → added to `DioClient` at DI setup time.

| Directory | Responsibility |
|-----------|---------------|
| `constants/` | Empty; network constants removed. `DioConfigs` carries defaults |
| `dio/` | Dio HTTP client wrapper, configs, and interceptor chain |