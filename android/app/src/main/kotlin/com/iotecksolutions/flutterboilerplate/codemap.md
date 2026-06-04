# android/app/src/main/kotlin/com/iotecksolutions/flutterboilerplate/

## Responsibility
Application package containing `MainActivity.kt` — the native Android entrypoint for the Flutter app. This is the thinnest possible native layer; all business logic resides in the Dart `lib/` tree.

## Design Patterns
- **Thin native shell**: `MainActivity` is a minimal subclass of `FlutterActivity` with no overridden methods. The Flutter v2 embedding handles all engine lifecycle management.
- **Flutter v2 embedding**: Class extends `io.flutter.embedding.android.FlutterActivity`, which internally creates and manages the `FlutterEngine`, `FlutterRenderer`, and Dart executor.

## Data & Control Flow
1. Android OS instantiates `MainActivity` via the `MAIN`/`LAUNCHER` intent filter declared in `AndroidManifest.xml`.
2. `FlutterActivity.onCreate()` (inherited) creates a `FlutterEngine` instance via `FlutterEngineCache` or a new engine.
3. The engine loads and executes the Dart isolate from `lib/main.dart`.
4. `GeneratedPluginRegistrant` (auto-generated, not in this directory) registers Flutter plugins with the engine.

## Integration Points
- **AndroidManifest.xml**: Declares `.MainActivity` as the launcher activity.
- **FlutterActivity (SDK)**: Provides embedding v2 lifecycle — engine creation, plugin registration, method channel setup.
- **lib/main.dart**: Dart entrypoint executed by the engine after native bootstrap.