# android/app/src/main/kotlin/com/

## Responsibility
Top of the reverse-domain package hierarchy (`com.*`). Contains the `iotecksolutions/` organization package.

## Design Patterns
- **Reverse-domain naming**: Standard Java/Kotlin package convention; `com.iotecksolutions` is the organization namespace.

## Data & Control Flow
- Package resolver traverses `com/` → `iotecksolutions/` → `todoapp/` to locate `MainActivity.kt`.

## Integration Points
- **iotecksolutions/**: Next package segment leading to the app code.