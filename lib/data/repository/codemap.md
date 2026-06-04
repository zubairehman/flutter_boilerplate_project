# lib/data/repository/

## Responsibility
Contains concrete implementations of domain repository abstractions. Each subfolder maps to one domain repository interface and provides the data-layer logic that coordinates remote APIs, local data sources, and SharedPreferences.

## Design Patterns
- **Repository implementation pattern**: Classes extend abstract domain repositories (`PostRepository`, `UserRepository`, `SettingRepository`) and delegate to injected data sources.
- **Cache-on-fetch**: `PostRepositoryImpl.getPosts()` fetches from `PostApi` then persists each post to `PostDataSource` before returning.
- **Error propagation**: All repository methods use `.catchError((error) => throw error)` to bubble failures to the domain layer.

## Data & Control Flow
1. Domain use cases call repository interface methods.
2. Repository implementations route to appropriate data sources (API for network, DataSource for local, SharedPreferenceHelper for settings).
3. Data is transformed/mapped as needed (Sembast snapshots → entities, JSON → entities).
4. Results or errors propagate back to the domain layer.

## Integration Points
- **Domain**: `lib/domain/repository/` — abstract base classes implemented here.
- **Network**: `lib/data/network/apis/` — API classes injected into repository implementations.
- **Local**: `lib/data/local/datasources/` — data sources injected for local persistence.
- **SharedPref**: `lib/data/sharedpref/shared_preference_helper.dart` — for settings/user state.
- **DI**: `RepositoryModule` registers all repository implementations as singletons.