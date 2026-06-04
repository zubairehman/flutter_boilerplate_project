# lib/domain/entity/

## Responsibility

Defines all domain model / business entity classes used across the domain and presentation layers. Entities are plain Dart classes with no framework dependencies — the canonical representations of domain objects.

## Design Patterns

- **Anemic domain models**: entities carry data and serialization logic (`fromMap`/`toMap`) but no business behaviour; behaviour is in use cases.
- **Collection wrappers**: `PostList` wraps `List<Post>` with a `fromJson` factory for batch deserialization.
- **Per-feature subfoldering**: `user/`, `post/`, `language/` — one entity class per subfolder.

## Data & Control Flow

- `data/` layer maps raw API/local data → entity instances via `fromMap`/`fromJson` factories.
- Entities flow upward through repositories → use cases → presentation.
- `PostList.fromJson(List<dynamic>)` delegates to `Post.fromMap(Map<String, dynamic>)` per item.

## Integration Points

- **Consumed by**: `repository/` (return types), `usecase/` (parameter/return types), `presentation/` (UI models).
- **Produced by**: `data/` layer mappers and repository implementations.