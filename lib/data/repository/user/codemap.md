# lib/data/repository/user/

## Responsibility
`UserRepositoryImpl` implements `UserRepository` from the domain layer. Handles user login (currently simulated with delay) and login-state persistence via `SharedPreferenceHelper`.

## Design Patterns
- **Delegate to SharedPreferences**: Login state is delegated to `SharedPreferenceHelper` — no separate data source or API.
- **Simulated login**: `login()` returns a delayed `User(id: 'demo-user', email: params.username)` — placeholder for real authentication.

## Data & Control Flow
- `login(LoginParams)` → `Future.delayed(2s)` → returns `User(id: 'demo-user', email: params.username)` (stub).
- `saveIsLoggedIn(bool)` → `_sharedPrefsHelper.saveIsLoggedIn(value)`.
- `isLoggedIn` getter → `_sharedPrefsHelper.isLoggedIn`.

## Integration Points
- **Domain**: `lib/domain/repository/user/user_repository.dart` — abstract class extended.
- **Domain**: `lib/domain/entity/user/user.dart` — return type of `login()`.
- **Domain**: `lib/domain/usecase/user/login_usecase.dart` — `LoginParams` type.
- `lib/data/sharedpref/shared_preference_helper.dart` — injected for preference storage.
- Registered in `RepositoryModule` as `getIt.registerSingleton<UserRepository>(UserRepositoryImpl(getIt<SharedPreferenceHelper>()))`.