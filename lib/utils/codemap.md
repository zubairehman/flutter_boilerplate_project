# lib/utils/

## Responsibility

Aggregates shared utility modules: device dimension helpers, Dio HTTP error handling and retry logic, i18n localization, and named route definitions. Each subfolder encapsulates a distinct cross-cutting concern.

## Design Patterns

- **Static-only classes**: Device, Dio, and route utilities use private constructors; all methods are static.
- **Interceptor pattern**: `RetryInterceptor` extends Dio's `Interceptor` to transparently retry failed HTTP requests.
- **Delegate pattern**: `AppLocalizations` uses Flutter's `LocalizationsDelegate` for locale-aware string loading from JSON assets.
- **Static route table**: `Routes` maps string path constants to `WidgetBuilder` factories.

## Data & Control Flow

- [device/](device/codemap.md) — provides `DeviceUtils.hideKeyboard()`, `getScaledSize/Width/Height()` using `MediaQuery`
- [dio/](dio/codemap.md) — provides `DioExceptionUtil.handleError()` for user-facing error messages and `RetryInterceptor` for automatic request retry
- [locale/](locale/codemap.md) — loads `assets/lang/{locale}.json`, exposes `AppLocalizations.translate(key)`
- [routes/](routes/codemap.md) — maps `/login` → `LoginScreen`, `/post` → `HomeScreen`

## Integration Points

- `presentation/` — imports `Routes` for `MaterialApp.routes`, `DeviceUtils` for keyboard/screen scaling, `AppThemeData` via constants
- `data/` — imports `RetryInterceptor` and `DioExceptionUtil` for HTTP client configuration
- `package:dio` — Dio interceptor and error type dependencies
- `package:flutter/material.dart` — `MediaQuery`, `BuildContext`, `Localizations`