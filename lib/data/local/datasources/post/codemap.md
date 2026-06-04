# lib/data/local/datasources/post/

## Responsibility
`PostDataSource` provides local CRUD operations for `Post` entities using Sembast. Acts as the offline cache layer consumed by `PostRepositoryImpl`. Stores data as `PostDto` JSON maps and reconstructs domain `Post` entities via mapper extensions.

## Design Patterns
- **DAO pattern**: `PostDataSource` is a Data Access Object — encapsulates all Sembast store operations for the Post entity.
- **DTO-mediated mapping**: Snapshots are deserialized into `PostDto` via `fromJson`, then converted to domain `Post` via `dto.toDomain()`. Inserts/updates use `post.toDto().toJson()`.
- **Upsert support**: `upsert()` checks for existing records before inserting or updating, supporting cache-on-fetch without duplicate key errors.

## Data & Control Flow
- `insert(Post)` → `_postsStore.add()` with `post.toDto().toJson()`.
- `upsert(Post)` → finds existing by `DBConstants.fieldId` → inserts if not found, updates record if found.
- `count()` → `_postsStore.count()`.
- `getAllSortedByFilter(filters)` → `_postsStore.find()` with `Finder` (filter + sort by `fieldId`) → `PostDto.fromJson` → `dto.toDomain()` → `List<Post>`.
- `getPostsFromDb()` → `_postsStore.find()` without filters → `PostDto.fromJson` → `dto.toDomain()` → `PostList`.
- `update(Post)` → `_postsStore.update()` with `Filter.byKey(post.id)`, data = `post.toDto().toJson()`.
- `delete(Post)` → `_postsStore.delete()` with `Filter.byKey(post.id)`.
- `deleteAll()` → `_postsStore.drop()`.

## Integration Points
- `lib/core/data/local/sembast/sembast_client.dart` — `SembastClient` provides `database` accessor.
- `lib/data/local/constants/db_constants.dart` — `DBConstants.storeName`, `fieldId`.
- `lib/data/network/dto/post_dto.dart` — `PostDto` used for serialization.
- `lib/data/mapper/post_mapper.dart` — `PostDto.toDomain()` and `Post.toDto()` extensions.
- `lib/domain/entity/post/post.dart` — `Post` entity.
- `lib/domain/entity/post/post_list.dart` — `PostList` return type.
- `lib/data/repository/post/post_repository_impl.dart` — consumes `PostDataSource`.
- Registered in `LocalModule` as `getIt.registerSingleton(PostDataSource(...))`.