# lib/data/local/datasources/post/

## Responsibility
`PostDataSource` provides local CRUD operations for `Post` entities using Sembast. Acts as the offline cache layer consumed by `PostRepositoryImpl`.

## Design Patterns
- **DAO pattern**: `PostDataSource` is a Data Access Object — encapsulates all Sembast store operations for the Post entity.
- **Snapshot-to-entity mapping**: Sembast `RecordSnapshot` values are converted to `Post` domain entities, with the record key assigned as `post.id`.

## Data & Control Flow
- `insert(Post)` → `_postsStore.add()` with `post.toMap()`.
- `getAllSortedByFilter(filters)` → `_postsStore.find()` with `Finder` (filter + sort by `FIELD_ID`) → maps snapshots to `List<Post>`.
- `getPostsFromDb()` → `_postsStore.find()` without filters → maps to `PostList`.
- `update(Post)` → `_postsStore.update()` with `Filter.byKey(post.id)`.
- `delete(Post)` → `_postsStore.delete()` with `Filter.byKey(post.id)`.
- `deleteAll()` → `_postsStore.drop()`.

## Integration Points
- `lib/core/data/local/sembast/sembast_client.dart` — `SembastClient` provides `database` accessor.
- `lib/data/local/constants/db_constants.dart` — `DBConstants.STORE_NAME`, `FIELD_ID`.
- `lib/domain/entity/post/post.dart` — `Post` entity with `toMap()`/`fromMap()`.
- `lib/domain/entity/post/post_list.dart` — `PostList` return type.
- `lib/data/repository/post/post_repository_impl.dart` — consumes `PostDataSource`.
- Registered in `LocalModule` as `getIt.registerSingleton(PostDataSource(...))`.