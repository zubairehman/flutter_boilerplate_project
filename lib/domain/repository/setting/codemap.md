# lib/domain/repository/setting/

## Responsibility

Defines `SettingRepository` — the abstract contract for app-wide settings: theme brightness mode and language preference.

## Design Patterns

- **Repository pattern**: `abstract class SettingRepository` with synchronous getters and async setters.
- **Synchronous reads**: `isDarkMode` and `currentLanguage` are sync getters (settings cached in memory), while writes (`changeBrightnessToDark`, `changeLanguage`) are async.

## Data & Control Flow

- `changeBrightnessToDark(bool)` → persists dark-mode toggle.
- `isDarkMode` getter → reads current brightness preference (sync).
- `changeLanguage(String)` → persists locale string.
- `currentLanguage` getter → reads current locale (sync, nullable).

## Integration Points

- **Implemented by**: data-layer `SettingRepositoryImpl` (in `data/`).
- **Consumed by**: presentation layer (theme/store classes) typically via corresponding use cases or directly.