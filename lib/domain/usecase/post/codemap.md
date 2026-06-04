# lib/domain/usecase/post/

## Responsibility

Post CRUD use cases: fetch all posts, find by ID, insert, update, and delete. Each wraps a single `PostRepository` method.

## Design Patterns

- **Use Case pattern**: five classes extending `UseCase<T, P>`.
- **CRUD alignment**: each use case maps 1:1 to a `PostRepository` method.
- **Note**: All five post use cases use `extends UseCase`, while the user use cases use `implements UseCase` — minor inconsistency in subtyping style across features.

### Classes

| Class | Return Type | Param Type | Repository Call |
|---|---|---|---|
| `GetPostUseCase` | `PostList` | `void` | `_postRepository.getPosts()` |
| `FindPostByIdUseCase` | `List<Post>` | `int` | `_postRepository.findPostById(params)` |
| `InsertPostUseCase` | `int` | `Post` | `_postRepository.insert(params)` |
| `UpdatePostUseCase` | `int` | `Post` | `_postRepository.update(params)` |
| `DeletePostUseCase` | `int` | `Post` | `_postRepository.delete(params)` |

## Data & Control Flow

- Read: `GetPostUseCase` / `FindPostByIdUseCase` → `PostRepository.getPosts()` / `findPostById()`.
- Write: `InsertPostUseCase` / `UpdatePostUseCase` / `DeletePostUseCase` → `PostRepository.insert()` / `update()` / `delete()` — each returns affected row count as `int`.

## Integration Points

- **Injected repository**: `PostRepository` (resolved from GetIt in `UseCaseModule`).
- **Consumed by**: presentation post list/store or BLoC.
- **File naming**: `udpate_post_usecase.dart` has a typo (should be `update_post_usecase.dart`).