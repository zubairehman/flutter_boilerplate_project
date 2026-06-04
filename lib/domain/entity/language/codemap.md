# lib/domain/entity/language/

## Responsibility

Defines the `Language` entity — domain model for locale/language settings including country code, locale code, display name, and an optional industry-specific dictionary map.

## Design Patterns

- **Immutable value object**: `Language` has `required` final fields (`code`, `locale`, `language`) plus an optional `dictionary` map for localized strings.

## Data & Control Flow

- `SettingRepository.changeLanguage(String)` and `currentLanguage` getter manage locale preferences using `Language.code`/`Language.locale`.
- `Language.dictionary` provides localized string keys for presentation-layer consumption.

## Integration Points

- **Consumed by**: `SettingRepository` (locale/language contracts), presentation layer for locale switching and UI string resolution.
- **Produced by**: data-layer setting repository implementation.