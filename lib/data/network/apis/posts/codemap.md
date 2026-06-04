# lib/data/network/apis/posts/

## Responsibility
`PostApi` provides remote data access for the Post domain entity. Fetches posts from `jsonplaceholder.typicode.com` via `DioClient`.

## Design Patterns
- **Repository data source**: `PostApi` serves as the remote data source consumed by `PostRepositoryImpl`.
- **Dual client**: Receives both `DioClient` (used actively) and `RestClient` (available but commented out as alternative).

## Data & Control Flow
1. `PostApi.getPosts()` calls `_dioClient.dio.get(Endpoints.getPosts)`.
2. Response JSON is deserialized into `PostList` via `PostList.fromJson()`.
3. Errors are caught and re-thrown.

## Integration Points
- `lib/data/network/constants/endpoints.dart` — `Endpoints.getPosts` URL.
- `lib/core/data/network/dio/dio_client.dart` — `DioClient` used for HTTP.
- `lib/data/network/rest_client.dart` — `RestClient` (injected but not actively used).
- `lib/domain/entity/post/post_list.dart` — `PostList` return type.
- `lib/data/repository/post/post_repository_impl.dart` — consumes `PostApi`.
- Registered in `NetworkModule` as `getIt.registerSingleton(PostApi(...))`.