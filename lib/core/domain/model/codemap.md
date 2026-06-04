# lib/core/domain/model/
## Responsibility
Defines shared domain DTOs used for inter-screen navigation and argument passing.

## Design Patterns
- **Generic DTO**: `ScreenArguments<T>` carries an optional `key` and typed `value` for flexible route payloads.
- **Constant key registry**: `ScreenArgumentKeys` (private constructor) centralizes navigation key strings.

## Data & Control Flow
- Feature screens construct `ScreenArguments<T>` when navigating; destination screens extract `value` via cast.
- `ScreenArgumentKeys.bookingId` used as the canonical key for booking-related navigation.

## Integration Points
- Imported by feature screens and route configurations across the app.