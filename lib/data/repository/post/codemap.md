# lib/data/repository/post/

## Responsibility
`PostRepositoryImpl` implements `PostRepository` from the domain layer. Coordinates both remote (`PostApi`) and local (`PostDataSource`) data sources — fetches posts from the API with automatic local caching via upsert, and provides local CRUD for individual posts. Falls back to cached data on network failure.

## Design Patterns
- **Online-first with offline fallback**: `getPosts()` fetches from `PostApi`, persists each post via `PostDataSource.upsert()`, and returns the network result. On failure, falls back to `PostDataSource.getPostsFromDb()`.
- **Composite data source**: Injects both `PostApi` (remote) and `PostDataSource` (local); routes read-all to API, read-by-id/update/delete to local.
- **Error propagation**: Methods use `.catchError((error) => throw error)` to surface failures.

## Data & Control Flow
- `getPosts()` → `_postApi.getPosts()` → caches each post via `_postDataSource.upsert()` → returns `PostList`. On failure → `_postDataSource.getPostsFromDb()` → returns cached `PostList` if non-empty, otherwise rethrows.
- `findPostById(id)` → builds `Filter.equals(DBConstants.fieldId, id)` → `_postDataSource.getAllSortedByFilter(filters)` → returns `List<Post>`.
- `insert(Post)` → `_postDataSource.insert(post)` → returns record ID.
- `update(Post)` → `_postDataSource.update(post)` → returns count.
- `delete(Post)` → `_postDataSource.delete(post)` → returns count.

## Integration Points
- **Domain**: `lib/domain/repository/post/post_repository.dart` — abstract class extended.
- **Domain**: `lib/domain/entity/post/post.dart`, `post_list.dart` — entity types.
- `lib/data/network/apis/posts/post_api.dart` — remote data source.
- `lib/data/local/datasources/post/post_datasource.dart` — local data source.
- `lib/data/local/constants/db_constants.dart` — `DBConstants.fieldId` for queries.
- Registered in `RepositoryModule` as `getIt.registerSingleton<PostRepository>(PostRepositoryImpl(getIt<PostApi>(), getIt<PostDataSource>()))`.