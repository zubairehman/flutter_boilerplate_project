# android/app/

## Responsibility
The sole Android application module. Defines the APK/AAB build configuration, links the Flutter engine, declares the native `MainActivity` entrypoint, and provides per-build-type Android manifests and resource themes.

## Design Patterns
- **Flutter-Gradle plugin integration**: Uses `dev.flutter.flutter-gradle-plugin` instead of legacy `kotlin-android` + manual Flutter embedding; the plugin manages Flutter engine dependency and asset bundling.
- **Version delegation**: `flutterVersionCode` and `flutterVersionName` are read from `local.properties`, falling back to `1` / `1.0`.
- **Build-type manifests**: Debug and profile flavors each carry a minimal manifest that adds the `INTERNET` permission for hot-reload connectivity; the main manifest declares the full activity and metadata.

## Data & Control Flow
1. `build.gradle` registers plugins (`com.android.application`, `dev.flutter.flutter-gradle-plugin`).
2. Reads `local.properties` for Flutter version metadata.
3. Configures `android {}` block: namespace `com.iotecksolutions.todoapp`, compileSdk 36, minSdk from Flutter, targetSdk 36, Java 17 compatibility.
4. Kotlin compiler target set to JVM 17 via `kotlin { compilerOptions {} }`.
5. Release build type requires explicit signing configuration (`RELEASE_STORE_FILE`); throws `GradleException` if not configured.
6. `flutter { source '../..' }` points the Flutter source set to the project root `lib/`.

## Integration Points
- **Gradle root project**: Inherited repository and build directory configuration.
- **Flutter SDK**: Plugin loader + source set linkage.
- **android/app/src/main/**: Contains `AndroidManifest.xml`, Kotlin `MainActivity`, and resource themes.
- **android/app/src/debug/**, **android/app/src/profile/**: Build-type-specific manifest overlays.