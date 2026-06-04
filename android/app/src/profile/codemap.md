# android/app/src/profile/

## Responsibility
Profile-specific Android manifest overlay that declares the `INTERNET` permission required by the Flutter tooling for performance profiling builds. Profile builds use AOT compilation like release but retain tooling connectivity.

## Design Patterns
- **Manifest overlay**: This manifest is merged on top of `main/AndroidManifest.xml` by the Android Gradle manifest merger when building the profile variant. Identical to the debug overlay — only the `INTERNET` permission is added.

## Data & Control Flow
1. Gradle activates the profile build variant.
2. Manifest merger combines `profile/AndroidManifest.xml` into the primary manifest.
3. Resulting APK is AOT-compiled (like release) but retains `INTERNET` permission for profiling tooling.

## Integration Points
- **android/app/src/main/AndroidManifest.xml**: Merged with this overlay at profile build time.
- **Flutter profiling tooling**: DevTools and performance profiling require network access to the app.