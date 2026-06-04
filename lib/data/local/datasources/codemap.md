# lib/data/local/datasources/

## Responsibility
Parent directory for local data source classes. Each subfolder contains a data source that performs CRUD operations against the Sembast local database for a specific domain entity.

## Design Patterns
- **Data source per entity**: Each entity type gets its own data source class and subfolder.
- **Sembast store mapping**: Data sources use `intMapStoreFactory.store()` to map Sembast stores to entity records.

## Data & Control Flow
Data sources receive `SembastClient` via injection → open named stores → execute find/add/update/delete operations using Sembast `Finder` and `Filter` APIs.

## Integration Points
- Consumed by repository implementations in `lib/data/repository/`.
- Initialized in `LocalModule` during DI setup.