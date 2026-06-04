# lib/data/local/constants/

## Responsibility
Defines `DBConstants` — static constants for Sembast database name, store name, and field keys used across local data sources.

## Design Patterns
- **Constants class**: Private constructor; all members are `static const`.

## Data & Control Flow
- `DBConstants.dbName` → used by `LocalModule` when calling `SembastClient.provideDatabase()`.
- `DBConstants.storeName` → used by `PostDataSource` to open the Sembast store.
- `DBConstants.fieldId` → used by `PostRepositoryImpl.findPostById()` and `PostDataSource.upsert()` as a filter key.

## Integration Points
- `lib/data/di/module/local_module.dart` — uses `DBConstants.dbName`.
- `lib/data/local/datasources/post/post_datasource.dart` — uses `DBConstants.storeName`, `DBConstants.fieldId`.
- `lib/data/repository/post/post_repository_impl.dart` — uses `DBConstants.fieldId` for query filters.