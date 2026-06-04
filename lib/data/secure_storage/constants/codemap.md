# lib/data/secure_storage/constants/

## Responsibility
Defines `SecureStorageKeys` — static string constants for secure storage key names used by `SecureStorageHelper`.

## Design Patterns
- **Constants class**: Private constructor prevents instantiation; all members are `static const String`.

## Data & Control Flow
Key constants are used directly by `SecureStorageHelper` methods to read/write entries in platform secure storage.

## Integration Points
- `lib/data/secure_storage/secure_storage_helper.dart` — sole consumer of all `SecureStorageKeys` constants.