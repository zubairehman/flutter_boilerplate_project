# lib/utils/locale/

## Responsibility

Implements runtime i18n by loading locale-specific JSON string files from assets and providing translation lookups to the widget tree via Flutter's `Localizations` framework. Falls back to the translation key itself when a key is missing.

## Design Patterns

- **InheritedWidget access**: `AppLocalizations.of(context)` wraps `Localizations.of()` for concise widget access.
- **Delegate pattern**: `_AppLocalizationsDelegate` extends `LocalizationsDelegate<AppLocalizations>`, registered in `MaterialApp.localizationsDelegates`.
- **JSON-based translations**: `load()` reads `assets/lang/{languageCode}.json`, decodes to `Map<String, dynamic>`, normalizes escape sequences (`\'` → `'`, `\t` → space), stores as `Map<String, String>`.
- **Key fallback**: `translate(key)` returns `localizedStrings[key] ?? key` — missing keys are returned as-is rather than `null`.
- **Supported locales**: `isSupported()` hardcodes `['en', 'es', 'da']` as supported language codes.

## Data & Control Flow

1. `MaterialApp` triggers `_AppLocalizationsDelegate.load(locale)`
2. `AppLocalizations(locale)` created → `load()` reads JSON from `rootBundle` → normalizes escapes → populates `localizedStrings`
3. Widgets call `AppLocalizations.of(context).translate('key')` → returns `localizedStrings[key]` or `key` if not found

## Integration Points

- `package:flutter/services.dart` — `rootBundle.loadString()` for asset file reading
- `package:flutter/material.dart` — `Localizations`, `LocalizationsDelegate`, `BuildContext`, `Locale`
- `assets/lang/*.json` — translation source files (en, es, da)
- `lib/presentation/` — `MaterialApp.localizationsDelegates` and `supportedLocales` reference `AppLocalizations.delegate`