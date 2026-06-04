# lib/domain/repository/

## Responsibility

Defines abstract repository contracts that decouple domain business logic from data source details. Each subfolder contains one repository interface per feature area, declaring the operations the domain layer requires.

## Design Patterns

- **Repository pattern (abstract)**: pure Dart `abstract class` interfaces with no implementations — data layer provides concrete classes.
- **Dependency inversion**: domain owns the contracts; data layer depends on domain (not vice versa).
- **Per-feature subfoldering**: `user/`, `post/`, `setting/`.

## Data & Control Flow

- Use cases depend on repository abstractions (injected via constructor).
- At runtime, GetIt resolves abstract types to concrete data-layer implementations.
- All repository methods return `Future` for async data access.

## Integration Points

- **Implemented by**: `data/` layer repository implementations (registered in `data/di/`).
- **Consumed by**: `usecase/` classes via constructor injection.
- **DI binding**: `UseCaseModule` resolves `UserRepository` and `PostRepository` from GetIt when constructing use cases.