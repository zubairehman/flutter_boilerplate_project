# lib/data/network/exceptions/

## Responsibility
Defines network-related exception types: `NetworkException` (base) and `AuthException` (for authentication failures).

## Design Patterns
- **Exception hierarchy**: `AuthException` extends `NetworkException`, allowing catch blocks to discriminate by type.

## Data & Control Flow
- `RestClient._createResponse` throws `NetworkException` when HTTP status is outside 200–400.
- `ErrorInterceptor` wraps Dio errors; downstream consumers may throw `NetworkException` or `AuthException`.

## Integration Points
- `lib/data/network/rest_client.dart` — throws `NetworkException` on bad status codes.
- `lib/data/network/interceptors/error_interceptor.dart` — may reference these types for error classification.