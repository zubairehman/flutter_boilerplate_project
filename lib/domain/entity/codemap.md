# lib/domain/entity/

## Responsibility

Defines all domain model / business entity classes used across the domain and presentation layers. Entities are immutable plain Dart classes with `const` constructors and non-nullable required fields — the canonical representations of domain objects. Serialization is handled externally by the data layer (DTOs + mapper extensions).

## Directory Map

| Directory | Purpose |
|---|---|
| `language/` | Language entity |
| `post/` | `Post` and `PostList` entities |
| `user/` | `User` entity |

## Design Patterns

- **Immutable domain models**: entities carry data only — no serialization logic (`fromMap`/`toMap`/`fromJson` removed from entities; serialization is now in data-layer DTOs and mappers).
- **Collection wrapper**: `PostList` wraps `List<Post>` with a `const` constructor.
- **Per-feature subfoldering**: `user/`, `post/`, `language/` — one entity class per subfolder.

## Data & Control Flow

- `data/` layer parses raw API/local JSON into DTOs (e.g., `PostDto.fromJson`), then mapper extensions convert DTOs → domain entities (e.g., `PostDto.toDomain()` → `Post`).
- Entities flow upward through repositories → use cases → presentation.
- Entities no longer own deserialization; the data layer is responsible for producing entity instances.

## Integration Points

- **Consumed by**: `repository/` (return types), `usecase/` (parameter/return types), `presentation/` (UI models).
- **Produced by**: `data/` layer mappers (e.g., `PostDtoMapper.toDomain()`) and repository implementations.