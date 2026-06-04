# lib/domain/entity/user/

## Responsibility

Defines the `User` entity — the immutable domain model representing an authenticated user with `id` and `email` fields.

## Design Patterns

- **Immutable entity with required non-nullable fields**: `User` uses a `const` constructor with `required String id` and `required String email`.

## Data & Control Flow

- `UserRepository.login()` returns `User?`.
- `LoginUseCase` exposes `User?` as its return type.
- Data-layer user repository implementation creates `User` instances from API responses.

## Integration Points

- **Consumed by**: `UserRepository` (return type), `LoginUseCase` (return type).
- **Produced by**: data-layer user repository implementation.