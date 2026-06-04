# lib/presentation/login/

## Responsibility
Login screen with email/password form. `LoginScreen` is a `StatefulWidget` that renders a responsive layout (landscape: side-by-side, portrait: centered form), drives authentication via `UserStore`, and validates inputs via `FormStore`.

## Design Patterns
- **MobX Observer**: Email field, password field, loading indicator, and success/error all wrapped in `Observer` widgets reacting to store state.
- **Service Locator**: `ThemeStore`, `FormStore`, `UserStore` resolved via `getIt<T>()`.
- **Form validation via store**: `FormStore.canLogin` guards the sign-in button; field errors displayed from `FormStore.formErrorStore.userEmail` / `.password`.
- **Responsive layout**: `MediaQuery.of(context).orientation` switches between two-pane and single-pane layout.
- **Post-frame navigation**: `navigate()` uses `WidgetsBinding.instance.addPostFrameCallback` with `mounted` check for safe navigation after async state change.

## Data & Control Flow
1. User types → `TextFieldWidget.onChanged` → `_formStore.setUserId()` / `_formStore.setPassword()`.
2. Sign-in button: Checks `_formStore.canLogin` → `unawaited(_userStore.login(email, password))`.
3. `UserStore.login()` sets `loginFuture` (ObservableFuture) → `isLoading` computed becomes true → `CustomProgressIndicatorWidget` shown.
4. On success (`UserStore.success`): `navigate()` calls `Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, …)` via `addPostFrameCallback`.
5. On error: `_formStore.errorStore.errorMessage` shown via `FlushbarHelper.createError()` in `addPostFrameCallback` with `mounted` check.

## Integration Points
- **`store/login_store.dart`**: `UserStore` handles login API call and auth state.
- **`core/stores/form/form_store.dart`**: `FormStore` / `FormErrorStore` for validation.
- **`core/stores/error/error_store.dart`**: `ErrorStore` for error message display.
- **`core/widgets/`**: `AppIconWidget`, `EmptyAppBar`, `CustomProgressIndicatorWidget`, `RoundedButtonWidget`, `TextFieldWidget`.
- **`../home/store/theme/theme_store.dart`**: `ThemeStore` for icon color adaptation.
- **`utils/routes/routes.dart`**: `Routes.home` for post-login navigation.