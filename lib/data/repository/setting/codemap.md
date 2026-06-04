# lib/data/repository/setting/

## Responsibility
`SettingRepositoryImpl` implements `SettingRepository` from the domain layer. Manages app settings (dark mode toggle, language selection) by delegating all operations to `SharedPreferenceHelper`.

## Design Patterns
- **Pure delegation**: Every method directly delegates to `SharedPreferenceHelper` with no additional logic or transformation.

## Data & Control Flow
- `changeBrightnessToDark(bool)` → `_sharedPrefsHelper.changeBrightnessToDark(value)`.
- `isDarkMode` getter → `_sharedPrefsHelper.isDarkMode`.
- `changeLanguage(String)` → `_sharedPrefsHelper.changeLanguage(value)`.
- `currentLanguage` getter → `_sharedPrefsHelper.currentLanguage`.

## Integration Points
- **Domain**: `lib/domain/repository/setting/setting_repository.dart` — abstract class extended.
- `lib/data/sharedpref/shared_preference_helper.dart` — sole dependency.
- Registered in `RepositoryModule` as `getIt.registerSingleton<SettingRepository>(SettingRepositoryImpl(getIt<SharedPreferenceHelper>()))`.