# lib/data/mapper/

## Responsibility
Provides bidirectional mapping extensions between DTOs (`data/network/dto/`) and domain entities (`domain/entity/`). Keeps serialization/deserialization logic out of API classes and data sources.

## Design Patterns
- **Extension-method mappers**: Uses Dart `extension` on DTO and domain types to add `toDomain()` and `toDto()` conversion methods without modifying the original classes.
- **Bidirectional**: Each entity–DTO pair has two extensions — one for each direction.

## Data & Control Flow
- `PostDto.toDomain()` → converts `PostDto` → `Post` (used after JSON deserialization in `PostApi` and `PostDataSource`).
- `Post.toDto()` → converts `Post` → `PostDto` (used before persistence in `PostDataSource`).

## Integration Points
- `lib/data/network/dto/post_dto.dart` — `PostDto` type extended by `PostDtoMapper`.
- `lib/domain/entity/post/post.dart` — `Post` type extended by `PostDomainMapper`.
- `lib/data/network/apis/posts/post_api.dart` — calls `PostDto.toDomain()`.
- `lib/data/local/datasources/post/post_datasource.dart` — calls both `Post.toDto()` and `PostDto.toDomain()`.