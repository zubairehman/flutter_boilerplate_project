# lib/presentation/login/store/

## Responsibility
Authentication state management. `UserStore` (MobX) manages login flow, logged-in status, bootstrap state, and success state. Delegates authentication to domain `LoginUseCase` and persistence to `SaveLoginStatusUseCase`. Exposes `logout()` to clear auth state.

## Design Patterns
- **MobX store**: `_UserStore` (abstract) → `UserStore = _UserStore with _$UserStore`. Uses `@observable`, `@computed`, `@action`.
- **ObservableFuture tracking**: `loginFuture` wraps the async login call; `isLoading` is computed from `loginFuture.status == FutureStatus.pending`.
- **Reaction-based auto-reset**: `_setupDisposers()` registers `reaction((_) => success, …, delay: 200)` that resets `success = false` after 200ms.
- **Explicit bootstrap**: Auth initialization moved from constructor to `bootstrapAuth()` action, called by `MyApp.initState()`. `isAuthBootstrapped` observable gates UI rendering.

## Data & Control Flow
1. Construction: `UserStore(IsLoggedInUseCase, SaveLoginStatusUseCase, LoginUseCase, FormErrorStore, ErrorStore)` → `_setupDisposers()` only (no auto auth check).
2. Bootstrap: `bootstrapAuth()` → `await _isLoggedInUseCase.call(params: null)` → sets `isLoggedIn` + `isAuthBootstrapped = true`.
3. Login: `login(email, password)` → creates `LoginParams` → `_loginUseCase.call(params)` → wrapped in `ObservableFuture` → on success: `_saveLoginStatusUseCase.call(params: true)`, `isLoggedIn = true`, `success = true`; on error: `isLoggedIn = false`, `success = false`, rethrows.
4. Logout: `logout()` → `isLoggedIn = false` → `await _saveLoginStatusUseCase.call(params: false)`.
5. Auto-reset: Reaction resets `success = false` after 200ms delay (prevents navigation loop).

## Integration Points
- **`domain/usecase/user/login_usecase.dart`**: `LoginUseCase` with `LoginParams(username, password)`.
- **`domain/usecase/user/is_logged_in_usecase.dart`**: `IsLoggedInUseCase` for auth bootstrap.
- **`domain/usecase/user/save_login_in_status_usecase.dart`**: `SaveLoginStatusUseCase` for persisting login state.
- **`domain/entity/user/user.dart`**: `User` entity returned by login.
- **`core/stores/error/error_store.dart`**: `ErrorStore` injected.
- **`core/stores/form/form_store.dart`**: `FormErrorStore` injected.