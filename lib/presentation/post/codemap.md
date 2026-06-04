# lib/presentation/post/

## Responsibility
Post list feature screen. `PostListScreen` is a `StatefulWidget` that fetches and displays a `ListView` of posts from `PostStore`. Loaded in the body of `HomeScreen`.

## Design Patterns
- **Lifecycle-driven fetch**: `didChangeDependencies()` triggers `_postStore.getPosts()` on first build (guarded by `!_postStore.loading`).
- **Observer pattern**: Loading state, post list, and error messages all consumed via `Observer` widgets.
- **Service Locator**: `PostStore` resolved via `getIt<PostStore>()`.

## Data & Control Flow
1. `didChangeDependencies()` → `_postStore.getPosts()` (if not already loading).
2. `getPosts()` sets `fetchPostsFuture` → `loading` computed returns true → `CustomProgressIndicatorWidget` shown.
3. On completion: `postList` populated → `ListView.separated` renders `ListTile` per post (title + body, single-line ellipsis).
4. Error: `PostStore.errorStore.errorMessage` rendered via `FlushbarHelper.createError()`.

## Integration Points
- **`store/post_store.dart`**: `PostStore` manages fetch state and post data.
- **`core/widgets/progress_indicator_widget.dart`**: `CustomProgressIndicatorWidget` for loading state.
- **`core/stores/error/error_store.dart`**: `ErrorStore` for error message propagation.
- **`utils/locale/app_localization.dart`**: `AppLocalizations` for translated strings.