# lib/utils/device/

## Responsibility

Provides device and screen dimension utility methods for responsive layout calculations and keyboard management.

## Design Patterns

- **Static utility class**: `DeviceUtils` has private constructor; all methods are static and stateless.
- **Responsive scaling**: `getScaledSize/Width/Height()` accept a `double scale` factor and multiply against `MediaQuery` dimensions, supporting orientation-aware sizing.

## Data & Control Flow

1. Widget calls `DeviceUtils.getScaledWidth(context, 0.5)` → reads `MediaQuery.of(context).size.width` → returns `width * 0.5`
2. Widget calls `DeviceUtils.hideKeyboard(context)` → `FocusScope.of(context).unfocus()` → dismisses soft keyboard

## Integration Points

- Depends on `package:flutter/material.dart` (`BuildContext`, `MediaQuery`, `Orientation`, `FocusScope`)
- Consumed by presentation-layer widgets for responsive layout and keyboard dismissal