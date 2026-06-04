# web/

## Responsibility
Web platform target for the Flutter boilerplate app. Contains the HTML entrypoint (`index.html`), PWA manifest (`manifest.json`), native splash markup/assets, and static assets (favicon, icons). The Flutter engine is loaded by `flutter_bootstrap.js` at runtime.

## Design Patterns
- **SPA entrypoint**: `index.html` is a minimal shell — no custom UI markup. All rendering is performed by the Flutter CanvasKit or HTML renderer inside a single `<body>` element.
- **PWA manifest**: `manifest.json` declares the app as `standalone` display mode with portrait-primary orientation, enabling installability on supported browsers.
- **Base href token**: `$FLUTTER_BASE_HREF` is replaced by the `--base-href` argument during `flutter build web`, allowing sub-path deployment.
- **iOS web app meta tags**: Apple-specific meta tags (`apple-mobile-web-app-capable`, `apple-mobile-web-app-status-bar-style`) enable add-to-home-screen behavior on iOS Safari.
- **Generated splash shell**: `flutter_native_splash` injects CSS, a `<picture id="splash">`, light/dark image sources, and `removeSplashFromWeb()` cleanup before Flutter draws the first frame.

## Data & Control Flow
1. Browser loads `index.html`; `<base href>` resolves relative asset paths.
2. The static splash markup displays density-specific light/dark PNG assets until Flutter removes it through `removeSplashFromWeb()`.
3. `flutter_bootstrap.js` (generated at build time, not in version control) bootstraps the Flutter engine, selects the renderer (CanvasKit or HTML), and loads the Dart AOT-compiled payload.
4. Flutter engine creates a `<flutter-view>` canvas element and renders the full UI.
5. `manifest.json` is linked via `<link rel="manifest">` for PWA support.

## Integration Points
- **flutter_bootstrap.js**: Auto-generated at build time; handles engine initialization, renderer selection, and Dart entrypoint execution.
- **manifest.json**: PWA manifest consumed by browsers for installability, icons, and display mode.
- **icons/**: PWA icon assets (192px, 512px, maskable variants) referenced by `manifest.json`.
- **splash/**: Native splash assets referenced by the generated `<picture>` element for light and dark color schemes.
- **favicon.png**: Browser tab icon.
- **Flutter Dart layer**: `lib/main.dart` is the Dart entrypoint executed by the engine after bootstrap.
