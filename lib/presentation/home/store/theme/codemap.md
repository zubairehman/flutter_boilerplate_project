# lib/presentation/home/store/theme/

## Responsibility
Manages the app's dark/light theme state. `ThemeStore` exposes `darkMode` observable, `changeBrightnessToDark(bool)` async action, and `isPlatformDark(BuildContext)` helper. Persists preference via `SettingRepository`.

## Design Patterns
- **MobX store**: `_ThemeStore` (abstract) → `ThemeStore = _ThemeStore with _$ThemeStore` (code-generated mixin). Uses `@observable` and `@action`. `darkMode` is a plain getter (not `@computed`).
- **Repository pattern**: Reads/writes theme preference through `SettingRepository`, not directly via `SharedPreferences`.
- **Async actions**: `changeBrightnessToDark` and `init` are `Future<void>` — await repository persistence.

## Data & Control Flow
1. Construction: `ThemeStore(SettingRepository, ErrorStore)` → `init()` reads `_repository.isDarkMode` → sets `_darkMode`.
2. Toggle: `changeBrightnessToDark(value)` → updates `_darkMode` + `await`s `_repository.changeBrightnessToDark(value)`.
3. Consumption: `MyApp.build()` Observer reads `darkMode` to select `AppThemeData.lightThemeData` or `AppThemeData.darkThemeData`. `HomeScreen` and `LoginScreen` read `darkMode` for icon color decisions.
4. `isPlatformDark(context)` checks `MediaQuery.platformBrightnessOf(context)` for system dark-mode detection.

## Integration Points
- **`domain/repository/setting/setting_repository.dart`**: `isDarkMode` getter, `changeBrightnessToDark(bool)` persistence.
- **`core/stores/error/error_store.dart`**: `ErrorStore` injected but not actively used in current code.
- **`../../../../constants/app_theme.dart`**: `AppThemeData.lightThemeData` / `AppThemeData.darkThemeData` consumed by `MyApp`.