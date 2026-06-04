# lib/data/sharedpref/

## Responsibility
Provides `SharedPreferenceHelper` — a typed wrapper over `SharedPreferences` for reading/writing app-wide key-value settings (auth token, login state, dark mode, language). Also defines preference key constants.

## Design Patterns
- **Facade pattern**: `SharedPreferenceHelper` wraps `SharedPreferences`, exposing domain-specific getters/setters instead of raw key-value access.
- **Synchronous + async API**: `isDarkMode` and `currentLanguage` are synchronous getters; `authToken`, `isLoggedIn` are async.

## Data & Control Flow
1. `SharedPreferences.getInstance()` → injected into `SharedPreferenceHelper`.
2. Read: `_sharedPreference.getString/Bool(key)` → return typed value.
3. Write: `_sharedPreference.setString/Bool(key, value)` → persist to device.

## Integration Points
- `lib/data/sharedpref/constants/preferences.dart` — key name constants.
- `lib/data/repository/setting/setting_repository_impl.dart` — delegates theme/language operations.
- `lib/data/repository/user/user_repository_impl.dart` — delegates login state operations.
- `lib/data/di/module/network_module.dart` — reads `authToken` for `AuthInterceptor`.
- `lib/data/di/module/local_module.dart` — initializes and registers `SharedPreferenceHelper`.
- **External**: `shared_preferences` package.