# lib/domain/usecase/user/

## Responsibility

User authentication and login-status use cases: logging in, checking login state, and persisting the login flag.

## Design Patterns

- **Use Case pattern**: three classes, each implements `UseCase<T, P>`.
- **Parameter object for login**: `LoginParams` (annotated `@JsonSerializable`) carries `username`/`password`; generated code in `login_usecase.g.dart` provides `fromJson`/`toJson`.
- **Simple delegation**: each use case's `call()` directly forwards to `UserRepository`.

### Classes

| Class | Return Type | Param Type | Repository Call |
|---|---|---|---|
| `LoginUseCase` | `User?` | `LoginParams` | `_userRepository.login(params)` |
| `IsLoggedInUseCase` | `bool` | `void` | `_userRepository.isLoggedIn` |
| `SaveLoginStatusUseCase` | `void` | `bool` | `_userRepository.saveIsLoggedIn(params)` |

## Data & Control Flow

- `LoginUseCase.call(params: LoginParams)` → `UserRepository.login()` → `User?`.
- `IsLoggedInUseCase.call(params: void)` → `UserRepository.isLoggedIn` → `bool`.
- `SaveLoginStatusUseCase.call(params: bool)` → `UserRepository.saveIsLoggedIn()` → `void`.

## Integration Points

- **Injected repository**: `UserRepository` (resolved from GetIt in `UseCaseModule`).
- **Consumed by**: presentation auth/login store or BLoC.
- **Code generation**: `login_usecase.g.dart` provides `_$LoginParamsFromJson` / `_$LoginParamsToJson`.
- **File naming quirk**: `save_login_in_status_usecase.dart` contains an extraneous "in" in the filename (class is `SaveLoginStatusUseCase`; expected filename would be `save_login_status_usecase.dart`).