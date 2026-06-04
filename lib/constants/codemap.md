# lib/constants/

## Responsibility

Declares app-wide static configuration values: theme data, color palettes, dimension spacing, asset paths, font family names, and string literals. All classes are non-instantiable (private constructors).

## Design Patterns

- **Static-only utility classes**: Every class uses `ClassName._()` to prevent instantiation; all members are `static const`.
- **Material Theme composition**: `AppThemeData` builds `ThemeData` from `ColorScheme` + `TextTheme`, supporting light and dark modes.
- **Google Fonts**: `AppThemeData._textTheme` uses `GoogleFonts.montserrat()` and `GoogleFonts.oswald()` instead of bundled font files.
- **Material color swatch pattern**: `AppColors.orange` provides a `Map<int, Color>` shade palette (50–900).

## Data & Control Flow

- `AppThemeData` → consumed by `MaterialApp.theme` / `MaterialApp.darkTheme` in presentation layer
- `AppColors` → used for custom color references outside the ColorScheme (e.g., charts, gradients)
- `Dimens` → referenced in widget padding/margin layouts (horizontal_padding, vertical_padding)
- `Assets` → string paths for `Image.asset()` and splash screen resources
- `FontFamily` → font family names for custom `TextStyle` font family overrides
- `Strings` → hardcoded string constants (e.g., `appName`)

## Integration Points

- `app_theme.dart` → depends on `package:flutter/material.dart`, `package:google_fonts/google_fonts.dart`
- `assets.dart` → purely string constants; consumed by presentation widgets
- `colors.dart` → depends on `package:flutter/material.dart` for `Color` type
- `dimens.dart`, `font_family.dart`, `strings.dart` → zero external dependencies; pure Dart constants
- Presentation layer imports `AppThemeData` for `MaterialApp` theming