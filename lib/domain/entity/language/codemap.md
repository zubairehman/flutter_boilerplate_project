# lib/domain/entity/language/

## Responsibility

Defines the `Language` entity — domain model for locale/language settings including country code, locale code, display name, and an optional industry-specific dictionary map.

## Design Patterns

- **Value object (mutable)**: `Language` has `required` fields (`code`, `locale`, `language`) and an optional `dictionary` map. Fields are mutable (not `final`), allowing in-place updates.
- **Per-feature file**: `language.dart` (renamed from `Language.dart` to follow lowercase file convention per Dart style guide).

## Data & Control Flow

- `SettingRepository.changeLanguage(String)` and `currentLanguage` getter manage locale preferences using `Language.code`/`Language.locale`.
- `Language.dictionary` provides localized string keys for presentation-layer consumption.

## Integration Points

- **Consumed by**: `SettingRepository` (locale/language contracts), presentation layer for locale switching and UI string resolution.
- **Produced by**: data-layer setting repository implementation.