# lib/data/sharedpref/constants/

## Responsibility
Defines `Preferences` — static string constants for SharedPreferences key names used by `SharedPreferenceHelper`.

## Design Patterns
- **Constants class**: Private constructor; all members are `static const String`.

## Data & Control Flow
Key constants are used directly by `SharedPreferenceHelper` methods to read/write single preference entries.

## Integration Points
- `lib/data/sharedpref/shared_preference_helper.dart` — sole consumer of all `Preferences` constants.