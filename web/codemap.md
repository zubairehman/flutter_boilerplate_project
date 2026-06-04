# web/

## Responsibility
Web platform target for the Flutter boilerplate app. Contains the HTML entrypoint (`index.html`), PWA manifest (`manifest.json`), and static assets (favicon, icons). The Flutter engine is loaded by `flutter_bootstrap.js` at runtime.

## Design Patterns
- **SPA entrypoint**: `index.html` is a minimal shell — no custom UI markup. All rendering is performed by the Flutter CanvasKit or HTML renderer inside a single `<body>` element.
- **PWA manifest**: `manifest.json` declares the app as `standalone` display mode with portrait-primary orientation, enabling installability on supported browsers.
- **Base href token**: `$FLUTTER_BASE_HREF` is replaced by the `--base-href` argument during `flutter build web`, allowing sub-path deployment.
- **iOS web app meta tags**: Apple-specific meta tags (`apple-mobile-web-app-capable`, `apple-mobile-web-app-status-bar-style`) enable add-to-home-screen behavior on iOS Safari.

## Data & Control Flow
1. Browser loads `index.html`; `<base href>` resolves relative asset paths.
2. `flutter_bootstrap.js` (generated at build time, not in version control) bootstraps the Flutter engine, selects the renderer (CanvasKit or HTML), and loads the Dart AOT-compiled payload.
3. Flutter engine creates a `<flutter-view>` canvas element and renders the full UI.
4. `manifest.json` is linked via `<link rel="manifest">` for PWA support.

## Integration Points
- **flutter_bootstrap.js**: Auto-generated at build time; handles engine initialization, renderer selection, and Dart entrypoint execution.
- **manifest.json**: PWA manifest consumed by browsers for installability, icons, and display mode.
- **icons/**: PWA icon assets (192px, 512px, maskable variants) referenced by `manifest.json`.
- **favicon.png**: Browser tab icon.
- **Flutter Dart layer**: `lib/main.dart` is the Dart entrypoint executed by the engine after bootstrap.