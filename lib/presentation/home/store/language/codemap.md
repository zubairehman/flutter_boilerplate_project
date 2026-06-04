# lib/presentation/home/store/language/

## Responsibility
Manages the app's locale/language state. `LanguageStore` exposes `locale` observable, `supportedLanguages` list, and `changeLanguage(String)` action. Validates locale against supported languages; sets `errorStore.errorMessage` for unsupported values. Persists preference via `SettingRepository`.

## Design Patterns
- **MobX store**: `_LanguageStore` (abstract) → `LanguageStore = _LanguageStore with _$LanguageStore`. Uses `@observable`, `@computed`, `@action`.
- **Static language catalog**: `supportedLanguages` is a hardcoded `List<Language>` with English, Danish, Spanish entries.
- **Repository pattern**: Reads/writes locale preference through `SettingRepository`.
- **Input validation**: `changeLanguage` checks locale against `supportedLanguages` before applying.

## Data & Control Flow
1. Construction: `LanguageStore(SettingRepository, ErrorStore)` → `init()` reads `_repository.currentLanguage` → sets `_locale`.
2. Change: `changeLanguage(locale)` → validates against `supportedLanguages`; if invalid, sets `errorStore.errorMessage` and returns; if valid, updates `_locale` + calls `_repository.changeLanguage(locale)`.
3. Consumption: `MyApp.build()` Observer reads `locale` for `MaterialApp.locale` and `supportedLanguages` for `supportedLocales`. `HomeScreen._buildLanguageDialog()` renders `supportedLanguages` list and calls `changeLanguage` on tap.
4. Helpers: `getCode()` maps locale → country code; `getLanguage()` maps locale → display name.

## Integration Points
- **`domain/repository/setting/setting_repository.dart`**: `currentLanguage` getter, `changeLanguage(String)` persistence.
- **`domain/entity/language/Language.dart`**: `Language` entity with `code`, `locale`, `language` fields.
- **`core/stores/error/error_store.dart`**: `ErrorStore` for unsupported-locale error messages.