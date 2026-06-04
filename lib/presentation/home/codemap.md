# lib/presentation/home/

## Responsibility
Home screen after successful login. `HomeScreen` is a `StatefulWidget` that renders an `AppBar` with theme-toggle, language-picker, and logout actions, and a `PostListScreen` body.

## Design Patterns
- **Composition**: Body delegates entirely to `PostListScreen` from `post/`.
- **Observer pattern**: Theme button wrapped in `Observer` to react to `ThemeStore.darkMode`.
- **Service Locator**: `ThemeStore`, `LanguageStore`, `UserStore` resolved via `getIt<T>()`.

## Data & Control Flow
1. `HomeScreen.build()` → `Scaffold(appBar, body: PostListScreen)`.
2. Theme button: `_themeStore.changeBrightnessToDark(!_themeStore.darkMode)` toggles dark mode (async).
3. Language button: Opens an `AlertDialog` listing `LanguageStore.supportedLanguages`; tap calls `_languageStore.changeLanguage(locale)` (validates locale, sets error if unsupported).
4. Logout button: Calls `_userStore.logout()` (updates `isLoggedIn` and persists via `SaveLoginStatusUseCase`), then `unawaited(Navigator.of(context).pushReplacementNamed(Routes.login))` with `mounted` check.

## Integration Points
- **`store/theme/theme_store.dart`**: `ThemeStore` for dark-mode toggle.
- **`store/language/language_store.dart`**: `LanguageStore` for locale switching and `supportedLanguages` list.
- **`../login/store/login_store.dart`**: `UserStore` for logout action.
- **`../post/post_list.dart`**: `PostListScreen` as the body content.
- **`../../di/service_locator.dart`**: `getIt` for store resolution.
- **`utils/routes/routes.dart`**: `Routes.login` named route.
- **`utils/locale/app_localization.dart`**: `AppLocalizations` for translated strings.