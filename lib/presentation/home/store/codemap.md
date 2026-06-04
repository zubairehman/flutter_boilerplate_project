# lib/presentation/home/store/

## Responsibility
Container folder for home-feature MobX stores — delegates to `theme/` and `language/` sub-folders. No Dart files exist at this level; it groups `ThemeStore` and `LanguageStore` as the app-wide preference stores.

## Design Patterns
- **Feature-scoped stores**: Theme and language state are isolated under `home/store/` even though they affect the entire app (resolved in `MyApp`).
- **MobX code generation**: Each store uses `part '*.g.dart'` with `class Store = _Store with _$Store` pattern.

## Data & Control Flow
- `ThemeStore` (in `theme/`) and `LanguageStore` (in `language/`) are both singletons registered in `StoreModule`. They are resolved by `MyApp`, `HomeScreen`, and `LoginScreen` via `getIt`.
- Both stores call `SettingRepository` to persist/read preferences on construction (`init()`) and on user action.
- `LanguageStore.changeLanguage()` now validates locale against `supportedLanguages` and writes `errorStore.errorMessage` for unsupported values.
- `ThemeStore` now exposes `isPlatformDark(BuildContext)` for platform brightness detection.

## Integration Points
- **`theme/theme_store.dart`**: Dark-mode state management.
- **`language/language_store.dart`**: Locale and language-list state management.
- **`../../di/module/store_module.dart`**: Singleton registration.
- **`domain/repository/setting/setting_repository.dart`**: Shared preference persistence for both stores.