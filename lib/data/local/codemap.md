# lib/data/local/

## Responsibility
Manages on-device persistent storage using Sembast (NoSQL) and defines database constants. Data source classes perform CRUD operations against the local database and are consumed by repository implementations as the local caching layer.

## Design Patterns
- **Data source pattern**: `PostDataSource` encapsulates all Sembast operations for the Post entity, keeping DB logic separate from repository logic.
- **Store-per-entity**: Each Sembast `Store` corresponds to one domain entity type.

## Data & Control Flow
1. `SembastClient` is initialized with `DBConstants.DB_NAME` and application documents path.
2. Data sources open named stores (`intMapStoreFactory.store()`) and perform CRUD via Sembast API.
3. Repositories call data source methods for local reads/writes, typically after a network fetch.

## Integration Points
- **Core**: `lib/core/data/local/sembast/sembast_client.dart` — provides `SembastClient` with `database` accessor.
- **Domain**: `lib/domain/entity/post/post.dart`, `post_list.dart` — entity types stored/retrieved.
- **DI**: `LocalModule` initializes `SembastClient` and registers data sources.
- **External**: `sembast` package, `path_provider` package.