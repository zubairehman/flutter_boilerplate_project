# lib/data/repository/user/

## Responsibility
`UserRepositoryImpl` implements `UserRepository` from the domain layer. Handles user login (currently simulated) and login-state persistence via `SharedPreferenceHelper`. Also receives `SecureStorageHelper` for future secure auth token management.

## Design Patterns
- **Delegate to SharedPreferences**: Login state is delegated to `SharedPreferenceHelper` — no separate data source or API.
- **Dual storage injection**: Receives both `SharedPreferenceHelper` (non-sensitive state) and `SecureStorageHelper` (sensitive data, available for future use).
- **Simulated login**: `login()` returns a delayed `User()` — placeholder for real authentication.

## Data & Control Flow
- `login(LoginParams)` → `Future.delayed(2s)` → returns `User()` (stub).
- `saveIsLoggedIn(bool)` → `_sharedPrefsHelper.saveIsLoggedIn(value)`.
- `isLoggedIn` getter → `_sharedPrefsHelper.isLoggedIn`.

## Integration Points
- **Domain**: `lib/domain/repository/user/user_repository.dart` — abstract class extended.
- **Domain**: `lib/domain/entity/user/user.dart` — return type of `login()`.
- **Domain**: `lib/domain/usecase/user/login_usecase.dart` — `LoginParams` type.
- `lib/data/sharedpref/shared_preference_helper.dart` — injected for preference storage.
- `lib/data/secure_storage/secure_storage_helper.dart` — injected for secure storage (available for future auth token operations).
- Registered in `RepositoryModule` as `getIt.registerSingleton<UserRepository>(UserRepositoryImpl(getIt<SharedPreferenceHelper>(), getIt<SecureStorageHelper>()))`.