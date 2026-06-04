# lib/presentation/post/store/

## Responsibility
Post data state management. `PostStore` (MobX) fetches posts via `GetPostUseCase`, tracks loading/success/error state, and exposes `postList` observable for UI consumption.

## Design Patterns
- **MobX store**: `_PostStore` (abstract) → `PostStore = _PostStore with _$PostStore`. Uses `@observable`, `@computed`, `@action`.
- **ObservableFuture tracking**: `fetchPostsFuture` wraps the async fetch; `loading` computed from `fetchPostsFuture.status == FutureStatus.pending`.
- **Error delegation**: Errors are not thrown but written to `errorStore.errorMessage` via `DioExceptionUtil.handleError()`.

## Data & Control Flow
1. `getPosts()` → `_getPostUseCase.call(params: null)` → wrapped in `ObservableFuture` → `fetchPostsFuture` updated.
2. On success: `postList` set to returned `PostList`.
3. On error: `errorStore.errorMessage = DioExceptionUtil.handleError(error)` — UI picks this up via `Observer`.
4. `loading` computed: returns true while `fetchPostsFuture` is pending.

## Integration Points
- **`domain/usecase/post/get_post_usecase.dart`**: `GetPostUseCase` for fetching posts.
- **`domain/entity/post/post_list.dart`**: `PostList` entity with `posts` list.
- **`core/stores/error/error_store.dart`**: `ErrorStore` for error message propagation.
- **`utils/dio/dio_error_util.dart`**: `DioExceptionUtil.handleError()` maps Dio exceptions to user-facing strings.