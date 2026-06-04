# lib/data/network/interceptors/

## Responsibility
Contains `ErrorInterceptor` — a Dio interceptor that captures request errors and publishes them via `EventBus` for app-wide error handling.

## Design Patterns
- **Observer pattern**: `ErrorInterceptor` fires `ErrorEvent` on `EventBus` so any listener can react to network errors without tight coupling.
- **Interceptor pattern**: Extends `Interceptor` from `dio`, plugged into the Dio interceptor chain.

## Data & Control Flow
1. Dio encounters an error on any request.
2. `ErrorInterceptor.onError()` fires `ErrorEvent(path, response)` on `EventBus`.
3. Error propagates to next handler via `super.onError(err, handler)`.

## Integration Points
- `EventBus` — injected from `NetworkModule`, shared across the app.
- `ErrorEvent` — consumed by any subscriber (e.g., UI error dialogs, logging).
- Registered in `NetworkModule` between `AuthInterceptor` and `LoggingInterceptor`.