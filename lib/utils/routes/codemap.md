# lib/utils/routes/

## Responsibility

Defines named route path constants and a static route-to-`WidgetBuilder` map for Flutter's `Navigator` 1.0 API.

## Design Patterns

- **Static-only class**: `Routes._()` prevents instantiation; all members are `static const` or `static final`.
- **Route table pattern**: `routes` maps `String` path constants to `WidgetBuilder` factories, consumed by `MaterialApp.routes`.
- **Decoupled navigation**: Route paths are string constants (`splash`, `login`, `home`), separate from screen implementations.

## Data & Control Flow

1. `MaterialApp` reads `Routes.routes` as its route table
2. `Navigator.pushNamed(context, Routes.login)` → looks up `/login` → builds `LoginScreen()`
3. `Navigator.pushNamed(context, Routes.home)` → looks up `/post` → builds `HomeScreen()`
4. `Routes.splash` (`/splash`) is defined but has no corresponding entry in `routes` map (handled elsewhere, likely via initial route logic)

## Integration Points

- `lib/presentation/home/home.dart` — `HomeScreen` widget
- `lib/presentation/login/login.dart` — `LoginScreen` widget
- `lib/presentation/` — `MaterialApp(routes: Routes.routes)` in app widget
- `package:flutter/material.dart` — `WidgetBuilder`, `BuildContext`