# android/app/src/debug/

## Responsibility
Debug-specific Android manifest overlay that declares the `INTERNET` permission required by the Flutter tooling for hot-reload, breakpoint debugging, and DevTools communication during development builds.

## Design Patterns
- **Manifest overlay**: This manifest is merged on top of `main/AndroidManifest.xml` by the Android Gradle manifest merger when building the debug variant. Only the additional permission is declared; no activities or metadata are overridden.

## Data & Control Flow
1. Gradle activates the debug build variant.
2. Manifest merger combines `debug/AndroidManifest.xml` into the primary manifest.
3. Resulting merged APK includes `INTERNET` permission for Flutter dev tooling connectivity.

## Integration Points
- **android/app/src/main/AndroidManifest.xml**: Merged with this overlay at debug build time.
- **Flutter dev tooling**: Requires network connectivity to the running app for hot reload and debugging.