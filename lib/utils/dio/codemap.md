# lib/utils/dio/

## Responsibility

Provides Dio HTTP client utilities: human-readable error message mapping and automatic request retry with configurable retry count, interval, and evaluator.

## Design Patterns

- **Static utility class**: `DioExceptionUtil` maps `DioExceptionType` enum variants to user-facing error strings.
- **Interceptor pattern**: `RetryInterceptor` extends Dio's `Interceptor`, overriding `onError()` to re-dispatch failed requests.
- **Options pattern**: `RetryOptions` encapsulates retry configuration (retries, interval, evaluator) and persists it in `RequestOptions.extra` map via `extraKey`.
- **Extension method**: `RequestOptionsExtensions.toOptions()` converts a `RequestOptions` back to `Options` for re-dispatch.
- **Configurable evaluator**: `RetryEvaluator` typedef allows custom retry logic; defaults skip cancelled requests.

## Data & Control Flow

1. `DioExceptionUtil.handleError(DioException)` → switches on `error.type` → returns descriptive `String`
2. `RetryInterceptor.onError(err, handler)` → reads `RetryOptions.fromExtra()` → checks `retries > 0` and evaluator → delays if `retryInterval > 0` → decrements retries → re-dispatches via `dio.request()` → resolves or rejects handler

## Integration Points

- `package:dio` — `Dio`, `Interceptor`, `DioException`, `DioExceptionType`, `RequestOptions`, `Options`, `ErrorInterceptorHandler`
- `lib/data/` — adds `RetryInterceptor` to Dio instance interceptor list; calls `DioExceptionUtil.handleError()` for error display