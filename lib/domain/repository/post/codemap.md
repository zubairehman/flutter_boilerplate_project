# lib/domain/repository/post/

## Responsibility

Defines `PostRepository` — the abstract contract for CRUD operations on `Post` entities.

## Design Patterns

- **Repository pattern**: `abstract class PostRepository` declares five CRUD operations.
- **Entity-typed parameters**: `insert(Post)`, `update(Post)`, `delete(Post)` accept `Post` entity directly, avoiding primitive obsession.

## Data & Control Flow

- `getPosts()` → `Future<PostList>` — fetches all posts (wrapped in `PostList`).
- `findPostById(int)` → `Future<List<Post>>` — searches by ID.
- `insert(Post)` → `Future<int>` — returns inserted row ID.
- `update(Post)` → `Future<int>` — returns updated row count.
- `delete(Post)` → `Future<int>` — returns deleted row count.

## Integration Points

- **Implemented by**: data-layer `PostRepositoryImpl` (in `data/`).
- **Consumed by**: `GetPostUseCase`, `FindPostByIdUseCase`, `InsertPostUseCase`, `UpdatePostUseCase`, `DeletePostUseCase`.