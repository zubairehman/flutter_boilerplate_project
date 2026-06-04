# lib/data/network/apis/posts/

## Responsibility
`PostApi` provides remote data access for the Post domain entity. Fetches posts from `jsonplaceholder.typicode.com` via `DioClient`, deserializes responses into `PostDto` list, and converts to domain `PostList` via mapper extensions.

## Design Patterns
- **Repository data source**: `PostApi` serves as the remote data source consumed by `PostRepositoryImpl`.
- **DTO + mapper deserialization**: Response JSON → `PostDto.fromJson` → `dto.toDomain()` (via `PostDtoMapper` extension) → domain `Post` list.

## Data & Control Flow
1. `PostApi.getPosts()` calls `_dioClient.dio.get<List<dynamic>>(Endpoints.getPosts)`.
2. Response is cast to `List<Map<String, dynamic>>`, each mapped via `PostDto.fromJson`.
3. DTOs are converted to domain entities via `dto.toDomain()`, wrapped in `PostList`.
4. Errors are caught and re-thrown.

## Integration Points
- `lib/data/network/constants/endpoints.dart` — `Endpoints.getPosts` URL.
- `lib/core/data/network/dio/dio_client.dart` — `DioClient` used for HTTP.
- `lib/data/network/dto/post_dto.dart` — `PostDto` for JSON deserialization.
- `lib/data/mapper/post_mapper.dart` — `PostDto.toDomain()` extension.
- `lib/domain/entity/post/post_list.dart` — `PostList` return type.
- `lib/data/repository/post/post_repository_impl.dart` — consumes `PostApi`.
- Registered in `NetworkModule` as `getIt.registerSingleton(PostApi(getIt<DioClient>()))`.