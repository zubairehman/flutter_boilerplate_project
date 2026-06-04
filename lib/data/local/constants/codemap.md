# lib/data/local/constants/

## Responsibility
Defines `DBConstants` — static constants for Sembast database name, store name, and field keys used across local data sources.

## Design Patterns
- **Constants class**: Private constructor; all members are `static const`.

## Data & Control Flow
- `DBConstants.DB_NAME` → used by `LocalModule` when calling `SembastClient.provideDatabase()`.
- `DBConstants.STORE_NAME` → used by `PostDataSource` to open the Sembast store.
- `DBConstants.FIELD_ID` → used by `PostRepositoryImpl.findPostById()` as a filter key.

## Integration Points
- `lib/data/di/module/local_module.dart` — uses `DBConstants.DB_NAME`.
- `lib/data/local/datasources/post/post_datasource.dart` — uses `DBConstants.STORE_NAME`.
- `lib/data/repository/post/post_repository_impl.dart` — uses `DBConstants.FIELD_ID` for query filters.