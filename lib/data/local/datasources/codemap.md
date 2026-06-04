# lib/data/local/datasources/

## Responsibility
Parent directory for local data source classes. Each subfolder contains a data source that performs CRUD operations against the Sembast local database for a specific domain entity.

## Design Patterns
- **Data source per entity**: Each entity type gets its own data source class and subfolder.
- **Sembast store mapping**: Data sources use `intMapStoreFactory.store()` to map Sembast stores to entity records.
- **DTO-mediated I/O**: Data sources serialize entities as `PostDto.toJson()` before writing and deserialize via `PostDto.fromJson()` on read, then convert to domain entities via mapper extensions.

## Data & Control Flow
Data sources receive `SembastClient` via injection → open named stores → execute find/add/update/delete/upsert operations using Sembast `Finder` and `Filter` APIs. All persistence uses `PostDto` as the wire format.

## Integration Points
- Consumed by repository implementations in `lib/data/repository/`.
- Uses `lib/data/network/dto/post_dto.dart` for serialization format.
- Uses `lib/data/mapper/post_mapper.dart` for DTO ↔ domain entity conversion.
- Initialized in `LocalModule` during DI setup.