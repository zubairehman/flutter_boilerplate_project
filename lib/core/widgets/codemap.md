# lib/core/widgets/
## Responsibility
Shared UI primitive widgets used across multiple feature screens: styled text field with max-length, rounded button, loading indicator, empty app bar, and responsive app icon.

## Design Patterns
- **Stateless Presentational Widgets**: All are `StatelessWidget`; receive configuration via constructor params, no internal state.
- **Theme-aware**: Widgets read from `Theme.of(context)` for text styles, colors.
- **Responsive Sizing**: `AppIconWidget` uses `MediaQuery` + orientation to compute icon dimensions.

## Data & Control Flow
- `TextFieldWidget` → receives `TextEditingController`, `FocusNode`, callbacks (`onChanged`, `onFieldSubmitted`), `TextInputAction`, displays `errorText` from form stores; enforces `maxLength: 25` with hidden counter; supports `autoFocus` and `isObscure`.
- `RoundedButtonWidget` → receives `onPressed` callback, optional asset image, customizable shape/border/text size.
- `CustomProgressIndicatorWidget` → opaque overlay with centered `CircularProgressIndicator` in a rounded card.
- `EmptyAppBar` → zero-height `PreferredSizeWidget` for Scaffold.appBar when no visible app bar is needed.
- `AppIconWidget` → renders asset image sized to 20% of shortest viewport dimension.

## Integration Points
- Feature screen widgets import and compose these primitives into layouts.
- `TextFieldWidget` wired to `FormStore` fields via shared `TextEditingController` and `FormErrorStore` error messages.