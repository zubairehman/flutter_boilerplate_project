# lib/presentation/login/store/

## Responsibility
Authentication state management. `UserStore` (MobX) manages login flow, logged-in status, and success state. Delegates actual authentication to domain `LoginUseCase` and persistence to `SaveLoginStatusUseCase`.

## Design Patterns
- **MobX store**: `_UserStore` (abstract) → `UserStore = _UserStore with _$UserStore`. Uses `@observable`, `@computed`, `@action`.
- **ObservableFuture tracking**: `loginFuture` wraps the async login call; `isLoading` is computed from `loginFuture.status == FutureStatus.pending`.
- **Reaction-based auto-reset**: `_setupDisposers()` registers `reaction((_) => success, …, delay: 200)` that resets `success = false` after 200ms.
- **Constructor bootstrap**: `IsLoggedInUseCase.call()` runs on construction to populate initial `isLoggedIn` state.

## Data & Control Flow
1. Construction: `UserStore(IsLoggedInUseCase, SaveLoginStatusUseCase, LoginUseCase, FormErrorStore, ErrorStore)` → `_isLoggedInUseCase.call()` → sets `isLoggedIn`.
2. Login: `login(email, password)` → creates `LoginParams` → `_loginUseCase.call(params)` → wrapped in `ObservableFuture` → on success: `_saveLoginStatusUseCase(true)`, `isLoggedIn = true`, `success = true`; on error: `isLoggedIn = false`, `success = false`, rethrows.
3. Logout: `logout()` → `isLoggedIn = false` → `_saveLoginStatusUseCase(false)`.
4. Auto-reset: Reaction resets `success = false` after 200ms delay (prevents navigation loop).

## Integration Points
- **`domain/usecase/user/login_usecase.dart`**: `LoginUseCase` with `LoginParams(username, password)`.
- **`domain/usecase/user/is_logged_in_usecase.dart`**: `IsLoggedInUseCase` for initial auth check.
- **`domain/usecase/user/save_login_in_status_usecase.dart`**: `SaveLoginStatusUseCase` for persisting login state.
- **`domain/entity/user/user.dart`**: `User` entity returned by login.
- **`core/stores/error/error_store.dart`**: `ErrorStore` injected.
- **`core/stores/form/form_store.dart`**: `FormErrorStore` injected.