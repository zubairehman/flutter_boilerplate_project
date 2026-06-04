# lib/core/data/sharedpref/
## Responsibility
Defines the `BaseSharedPreferenceHelper` mixin contract for shared preferences cleanup. Concrete implementations live in feature or DI modules.

## Design Patterns
- **Mixin Contract**: `BaseSharedPreferenceHelper` declares `clearSharedPreference()` — no implementation, enforcing that concrete classes provide their own storage backend wiring.

## Data & Control Flow
- Implementors call `SharedPreferences` (or similar) under the hood to clear all stored key-value pairs.

## Integration Points
- Mixed into feature-specific shared preference helper classes.
- Called during logout or data-reset flows to purge user preferences.