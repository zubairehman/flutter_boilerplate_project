# lib/presentation/home/

## Responsibility
Home screen after successful login. `HomeScreen` is a `StatefulWidget` that renders an `AppBar` with theme-toggle, language-picker, and logout actions, and a `PostListScreen` body.

## Design Patterns
- **Composition**: Body delegates entirely to `PostListScreen` from `post/`.
- **Observer pattern**: Theme and language buttons wrapped in `Observer` to react to `ThemeStore.darkMode` and `LanguageStore.locale`.
- **Service Locator**: `ThemeStore` and `LanguageStore` resolved via `getIt<T>()`.

## Data & Control Flow
1. `HomeScreen.build()` → `Scaffold(appBar, body: PostListScreen)`.
2. Theme button: `_themeStore.changeBrightnessToDark(!_themeStore.darkMode)` toggles dark mode.
3. Language button: Opens an `AlertDialog` listing `LanguageStore.supportedLanguages`; tap calls `_languageStore.changeLanguage(locale)`.
4. Logout button: Writes `Preferences.is_logged_in = false` to `SharedPreferences`, then `Navigator.pushReplacementNamed(Routes.login)`.

## Integration Points
- **`store/theme/theme_store.dart`**: `ThemeStore` for dark-mode toggle.
- **`store/language/language_store.dart`**: `LanguageStore` for locale switching and `supportedLanguages` list.
- **`../post/post_list.dart`**: `PostListScreen` as the body content.
- **`../../di/service_locator.dart`**: `getIt` for store resolution.
- **`data/sharedpref/constants/preferences.dart`**: `Preferences.is_logged_in` key.
- **`utils/routes/routes.dart`**: `Routes.login` named route.
- **`utils/locale/app_localization.dart`**: `AppLocalizations` for translated strings.