# android/app/src/main/kotlin/

## Responsibility
Kotlin source root for the Android application module. Contains the native platform code under the reverse-domain package path `com/iotecksolutions/todoapp/`.

## Design Patterns
- **Standard Android Kotlin source set**: Follows the `src/main/kotlin/` convention for Kotlin sources, replacing the older Java `src/main/java/` path used by legacy generated registrants.

## Data & Control Flow
- Gradle compiles Kotlin sources from this directory as part of the app module.
- Kotlin compiler target is JVM 17 (configured in `app/build.gradle`).

## Integration Points
- **com/iotecksolutions/todoapp/**: Package directory containing `MainActivity.kt`.
- **app/build.gradle**: Declares Kotlin compiler options and JVM target.