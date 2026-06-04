# ios/

## Responsibility
iOS platform shell for the Flutter boilerplate app. Contains the Xcode project, CocoaPods dependency management, Flutter build configuration (xcconfig files), and the Runner application target that hosts the Flutter engine at runtime.

## Design Patterns
- **Xcode workspace**: `Runner.xcworkspace` wraps `Runner.xcodeproj` and integrates CocoaPods via the `Pods/` directory.
- **CocoaPods dependency management**: `Podfile` defines the `Runner` target with `use_frameworks!` and `use_modular_headers!`; Flutter pods are installed via `flutter_install_all_ios_pods`.
- **xcconfig layering**: Build configurations cascade — `Debug.xcconfig` and `Release.xcconfig` include `Generated.xcconfig` (Flutter-managed) and optionally `Pods-Runner.debug/release.xcconfig` (CocoaPods-managed).
- **Flutter SDK path resolution**: `Podfile` reads `FLUTTER_ROOT` from `Generated.xcconfig` to locate the Flutter tooling for pod helper scripts.

## Data & Control Flow
1. `flutter pub get` generates `Flutter/Generated.xcconfig` with SDK paths and build variables.
2. `pod install` reads the `Podfile`, resolves `flutter_root`, and installs Flutter plugin pods.
3. Xcode builds the `Runner` target; xcconfig files inject build settings from both Flutter and CocoaPods.
4. `Runner/AppDelegate.swift` launches the Flutter engine and registers plugins via `GeneratedPluginRegistrant`.

## Integration Points
- **Flutter SDK**: `Generated.xcconfig` and `flutter_export_environment.sh` bridge the Flutter SDK path and build variables into the Xcode build.
- **CocoaPods**: Manages native plugin dependencies; `Podfile` post_install hook applies Flutter-specific build settings.
- **Runner/**: The iOS application target containing `AppDelegate.swift`, `Info.plist`, storyboards, and assets.
- **Flutter/ephemeral/**: Auto-generated Swift packages for Flutter framework and plugin registration (not version-controlled).