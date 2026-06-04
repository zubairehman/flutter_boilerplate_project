# android/app/src/main/

## Responsibility
Primary Android source set containing the production application definition: `AndroidManifest.xml` (activity declaration, permissions, Flutter embedding metadata), the Kotlin `MainActivity` entrypoint, and UI resource themes (launch splash, normal theme, night-mode variant).

## Design Patterns
- **Flutter v2 embedding**: Manifest declares `flutterEmbedding` metadata value `2`; `MainActivity` extends `FlutterActivity` from `io.flutter.embedding.android`, requiring no manual engine initialization.
- **Single-top launch mode**: Activity is `singleTop` to prevent duplicate instances when re-launched from the home screen or deep links.
- **Splash screen metadata**: `SplashScreenDrawable` meta-data keeps the launch drawable visible until Flutter renders the first frame; `NormalTheme` meta-data provides the Android window theme post-first-frame.

## Data & Control Flow
1. Android OS launches `MainActivity` (declared with `MAIN`/`LAUNCHER` intent filter).
2. `FlutterActivity` (via `MainActivity`) initializes the Flutter engine using the v2 embedding.
3. Engine loads the Dart VM and executes `lib/main.dart`.
4. Launch theme (`LaunchTheme` with `launch_background` drawable) is displayed until Flutter's first frame.
5. Normal theme (`NormalTheme`) takes over as the Android window background during Flutter UI rendering.

## Integration Points
- **AndroidManifest.xml**: Registers the activity, declares `INTERNET` permission, sets Flutter embedding version.
- **kotlin/com/iotecksolutions/flutterboilerplate/MainActivity.kt**: Native entrypoint — thin subclass of `FlutterActivity`.
- **res/values/styles.xml** and **res/values-night/styles.xml**: Theme definitions consumed by manifest meta-data references.
- **Flutter Dart layer**: `lib/main.dart` is the Dart-side counterpart entrypoint loaded by the engine.