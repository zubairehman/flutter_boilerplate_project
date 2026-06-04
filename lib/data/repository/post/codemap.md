# lib/data/repository/post/

## Responsibility
`PostRepositoryImpl` implements `PostRepository` from the domain layer. Coordinates both remote (`PostApi`) and local (`PostDataSource`) data sources — fetches posts from the API with automatic local caching, and provides local CRUD for individual posts.

## Design Patterns
- **Online-first with local cache**: `getPosts()` fetches from `PostApi`, then persists each post to `PostDataSource` before returning the network result.
- **Composite data source**: Injects both `PostApi` (remote) and `PostDataSource` (local); routes read-all to API, read-by-id/update/delete to local.
- **Error propagation**: All methods use `.catchError((error) => throw error)` to surface failures.

## Data & Control Flow
- `getPosts()` → `_postApi.getPosts()` → caches each post via `_postDataSource.insert()` → returns `PostList`.
- `findPostById(id)` → builds `Filter.equals(DBConstants.FIELD_ID, id)` → `_postDataSource.getAllSortedByFilter(filters)` → returns `List<Post>`.
- `insert(Post)` → `_postDataSource.insert(post)` → returns record ID.
- `update(Post)` → `_postDataSource.update(post)` → returns count.
- `delete(Post)` → `_postDataSource.delete(post)` → returns count.

## Integration Points
- **Domain**: `lib/domain/repository/post/post_repository.dart` — abstract class extended.
- **Domain**: `lib/domain/entity/post/post.dart`, `post_list.dart` — entity types.
- `lib/data/network/apis/posts/post_api.dart` — remote data source.
- `lib/data/local/datasources/post/post_datasource.dart` — local data source.
- `lib/data/local/constants/db_constants.dart` — `DBConstants.FIELD_ID` for queries.
- Registered in `RepositoryModule` as `getIt.registerSingleton<PostRepository>(PostRepositoryImpl(getIt<PostApi>(), getIt<PostDataSource>()))`.