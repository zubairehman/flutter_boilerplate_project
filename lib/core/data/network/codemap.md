# lib/core/data/network/
## Responsibility
Network infrastructure: HTTP client configuration (Dio), connection constants, and an interceptor chain (auth, retry, logging). Provides all HTTP communication primitives for feature repositories.

## Design Patterns
- **Interceptor Chain**: `AuthInterceptor` → `RetryInterceptor` → `LoggingInterceptor` layered on `DioClient.dio`.
- **Config Object**: `DioConfigs` encapsulates base URL, timeouts; `NetworkConstants` provides default values.
- **Retry with Backoff**: `RetryInterceptor` uses `RetryOptions` with configurable retry count, interval, and evaluator.

## Data & Control Flow
1. Repository constructs `DioClient(dioConfigs:)` → configures `Dio` instance.
2. Interceptors added via `DioClient.addInterceptors([auth, retry, logging])`.
3. **Request flow**: `AuthInterceptor.onRequest` injects Bearer token → `LoggingInterceptor.onRequest` logs → HTTP call → `LoggingInterceptor.onResponse` logs result → on error `RetryInterceptor.onError` evaluates retry.
4. `RetryInterceptor` decrements `RetryOptions.retries` per attempt, delays by `retryInterval`, re-executes original request.

## Integration Points
- `dio/dio_client.dart` → feature repositories and DI module for HTTP client instance.
- `constants/network_constants.dart` → provides `baseUrl`, timeouts for `DioConfigs`.
- `dio/interceptors/` → added to `DioClient` at DI setup time.