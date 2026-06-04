# lib/core/domain/
## Responsibility
Pure domain layer containing business entity models and the abstract use-case contract. Has no dependency on Flutter or infrastructure packages.

## Design Patterns
- **Clean Architecture – Domain Layer**: No imports from `data/` or `stores/`; fully decoupled.
- **Generic UseCase contract**: `UseCase<T, P>` abstracts any asynchronous operation with typed return `T` and typed params `P`.
- **Screen argument DTOs**: `ScreenArguments<T>` provides type-safe navigation payload passing.

## Data & Control Flow
- Feature modules extend `UseCase<T, P>` to define business operations.
- `ScreenArguments<T>` instances are passed via `Navigator.pushNamed` arguments and unpacked by destination screens.
- `ScreenArgumentKeys` supplies constant string keys (e.g., `bookingId`) for argument lookups.

## Integration Points
- `model/screen_args.dart` → imported by feature screens for route argument handling.
- `usecase/use_case.dart` → extended by every feature-level use case class.