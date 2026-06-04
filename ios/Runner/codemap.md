# ios/Runner/

## Responsibility
iOS application target containing the native entrypoint (`AppDelegate.swift`), app configuration (`Info.plist`), UI storyboards, bridging header, and asset catalogs. This is the minimal native iOS shell that bootstraps the Flutter engine.

## Design Patterns
- **Thin native shell**: `AppDelegate` subclasses `FlutterAppDelegate`, calls `GeneratedPluginRegistrant.register(with: self)` in `didFinishLaunchingWithOptions`, then delegates entirely to the Flutter engine.
- **`@UIApplicationMain` attribute**: Marks `AppDelegate` as the application delegate entrypoint — no `main.swift` file needed.
- **Bridging header**: `Runner-Bridging-Header.h` imports `GeneratedPluginRegistrant.h` so that plugin registrants (auto-generated Objective-C) are visible to Swift code.
- **Storyboard-based launch**: `LaunchScreen.storyboard` for splash; `Main.storyboard` as the initial UI (Flutter engine replaces it after first frame).

## Data & Control Flow
1. iOS launches the app; `@UIApplicationMain` entrypoint creates `AppDelegate`.
2. `didFinishLaunchingWithOptions` calls `GeneratedPluginRegistrant.register(with: self)` to wire Flutter plugins to method channels.
3. `FlutterAppDelegate` (parent class) creates the `FlutterEngine` and `FlutterViewController`.
4. The Flutter engine loads the Dart isolate from `lib/main.dart`.
5. `Info.plist` configures app identity (`CFBundleIdentifier`), display name, orientation support, and launch storyboard reference.

## Integration Points
- **AppDelegate.swift → FlutterAppDelegate**: Inherits engine lifecycle management; overrides `didFinishLaunchingWithOptions` only for plugin registration.
- **Info.plist**: Configures bundle identity (`com.iotecksolutions.flutterboilerplate` via `PRODUCT_BUNDLE_IDENTIFIER`), display name ("Flutter Boilerplate Project"), orientations (portrait + landscape), and 60fps+ enablement (`CADisableMinimumFrameDurationOnPhone`).
- **Runner-Bridging-Header.h**: Bridges auto-generated Objective-C plugin registrant code into Swift.
- **Flutter/Generated.xcconfig**: Provides build variable substitution (`FLUTTER_BUILD_NAME`, `FLUTTER_BUILD_NUMBER`, `PRODUCT_BUNDLE_IDENTIFIER`) consumed by `Info.plist`.
- **Assets.xcassets**: App icon set and launch images (not in scope for documentation).