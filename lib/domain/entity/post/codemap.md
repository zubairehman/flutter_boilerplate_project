# lib/domain/entity/post/

## Responsibility

Defines the `Post` and `PostList` entities — immutable domain models representing a single blog post and a collection of posts respectively.

## Design Patterns

- **Immutable entity with required non-nullable fields**: `Post` uses a `const` constructor with `required` non-nullable fields (`int userId`, `int id`, `String title`, `String body`). No serialization logic — all JSON mapping handled by `PostDto` and `PostDtoMapper` in the data layer.
- **Collection wrapper**: `PostList` wraps `List<Post>` with a `const` constructor. No `fromJson` factory — batch deserialization is handled in the data layer.
- **Per-feature files**: `post.dart` (entity), `post_list.dart` (collection wrapper).

## Data & Control Flow

- Raw API JSON → `PostDto.fromJson()` (data layer) → `PostDtoMapper.toDomain()` → `Post` instance.
- `PostList` instances are assembled by the data-layer repository implementation from lists of mapped `Post` entities.
- `Post` instances flow through `PostRepository` and all post use cases to the presentation layer.

## Integration Points

- **Consumed by**: `PostRepository` (return/param types), `GetPostUseCase`, `FindPostByIdUseCase`, `InsertPostUseCase`, `UpdatePostUseCase`, `DeletePostUseCase`.
- **Produced by**: data-layer `PostDtoMapper.toDomain()` extension and post repository implementation.
- **Mapped from**: `PostDto` (`data/network/dto/post_dto.dart`) via `PostDtoMapper` (`data/mapper/post_mapper.dart`).