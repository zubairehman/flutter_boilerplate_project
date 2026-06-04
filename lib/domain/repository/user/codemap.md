# lib/domain/repository/user/

## Responsibility

Defines `UserRepository` — the abstract contract for user authentication and login-status persistence.

## Design Patterns

- **Repository pattern**: `abstract class UserRepository` declares three operations with no implementation.
- **Parameter object**: `login()` takes `LoginParams` (defined in `usecase/user/login_usecase.dart`) instead of raw strings, ensuring type safety.

## Data & Control Flow

- `login(LoginParams)` → returns `Future<User?>` — authentication attempt.
- `saveIsLoggedIn(bool)` → persists login status flag.
- `isLoggedIn` getter → returns `Future<bool>` — checks persisted login state.

## Integration Points

- **Implemented by**: data-layer `UserRepositoryImpl` (in `data/`).
- **Consumed by**: `LoginUseCase`, `IsLoggedInUseCase`, `SaveLoginStatusUseCase` — all accept `UserRepository` via constructor.
- **Note**: `login()` parameter type `LoginParams` lives in `usecase/user/login_usecase.dart`, creating a slight coupling between repository and use-case layers.