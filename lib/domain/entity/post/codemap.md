# lib/domain/entity/post/

## Responsibility

Defines the `Post` and `PostList` entities — domain models representing a single blog post and a collection of posts respectively.

## Design Patterns

- **DTO-style entity with nullable fields**: `Post` has `fromMap`/`toMap` for JSON serialization, acting as its own DTO. All fields (`userId`, `id`, `title`, `body`) are nullable (`int?`/`String?`) to accommodate partial API responses.
- **Collection wrapper**: `PostList` wraps `List<Post>?` with a `fromJson` factory that maps a `List<dynamic>` of JSON maps into `Post` instances.
- **Per-feature files**: `post.dart` (entity), `post_list.dart` (collection wrapper).

## Data & Control Flow

- Raw API JSON → `Post.fromMap()` → `Post` instance.
- Array JSON → `PostList.fromJson()` → iterates `Post.fromMap()` per element → `PostList`.
- `Post` instances flow through `PostRepository` and all post use cases to the presentation layer.

## Integration Points

- **Consumed by**: `PostRepository` (return/param types), `GetPostUseCase`, `FindPostByIdUseCase`, `InsertPostUseCase`, `UpdatePostUseCase`, `DeletePostUseCase`.
- **Produced by**: data-layer post repository and API/local mappers.