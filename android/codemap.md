# android/

## Responsibility
Android platform shell for the Flutter boilerplate app. Houses the Gradle build system, project-wide configuration, and the native Android app module that hosts the Flutter engine at runtime.

## Design Patterns
- **Multi-project Gradle build**: Root `build.gradle` defines shared repository sources (google, mavenCentral) and a `clean` task; `settings.gradle` loads the Flutter plugin loader via `includeBuild` from the Flutter SDK and declares plugin versions (AGP 9.2.1, Kotlin 2.4.0, Foojay toolchain resolver 0.10.0).
- **Gradle wrapper**: Pinned to Gradle 9.4.1 via `gradle-wrapper.properties`; JVM toolchains resolved through Foojay to JDK 21 (`gradle-daemon-jvm.properties`).
- **AndroidX + Jetifier**: Enabled in `gradle.properties`; legacy support library artifacts are automatically migrated.
- **Flutter Gradle plugin**: `dev.flutter.flutter-gradle-plugin` applied in `app/build.gradle` replaces the old `kotlin-android` + Flutter fallback pattern.

## Data & Control Flow
1. `settings.gradle` resolves the Flutter SDK path from `local.properties` and includes the Flutter tools Gradle plugin.
2. Root `build.gradle` configures repositories and delegates evaluation to `:app`.
3. `app/build.gradle` consumes Flutter version metadata from `local.properties`, configures Android SDK versions (compileSdk 36, targetSdk 36), and wires the `flutter` source set to the parent `lib/` directory.
4. Gradle daemon JVM is resolved to JDK 21 via Foojay toolchains.

## Integration Points
- **Flutter SDK**: `settings.gradle` loads `flutter-plugin-loader` from the SDK; `local.properties` provides `flutter.sdk` path.
- **CocoaPods analogue**: `gradle.properties` + `app/build.gradle` serve the same configuration role as `ios/Podfile` + Xcode build settings.
- **Downstream**: `android/app/` — the single app module that produces the APK/AAB.
- **CI/CD**: `gradlew` wrapper script enables reproducible headless builds.