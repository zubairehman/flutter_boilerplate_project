# lib/core/extensions/
## Responsibility
Reusable Dart `String` extension methods for capitalization transformations.

## Design Patterns
- **Extension Methods**: `CapExtension on String` adds `inCaps`, `allInCaps`, `toTitleCase()` without subclassing.

## Data & Control Flow
- `inCaps` → capitalizes first character.
- `allInCaps` → uppercases entire string.
- `toTitleCase()` → splits on whitespace, capitalizes each word, rejoins.

## Integration Points
- Imported wherever `String` casing is needed (e.g., display formatting in UI screens).