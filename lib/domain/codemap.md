# lib/domain/

## Responsibility

Domain layer of the Clean Architecture stack. Owns all business entities, repository contracts, use case orchestration, and domain-layer DI wiring. Contains zero data-source or UI code; defines the contracts that `data/` implements and the operations that `presentation/` consumes.

## Directory Map

| Directory | Purpose |
|---|---|
| `di/` | Domain-layer DI wiring (use case registration via GetIt) |
| `entity/` | Domain model / business entity classes |
| `repository/` | Abstract repository contracts |
| `usecase/` | Use case classes (single-responsibility command objects) |

## Design Patterns

- **Clean Architecture**: domain is the innermost ring — depends on nothing outside itself except `core/domain/usecase/use_case.dart` (abstract `UseCase<T, P>` base).
- **Repository pattern**: abstract repository classes in `repository/` define data-access contracts; concrete implementations live in `data/`.
- **Use Case pattern**: each business operation is a single-responsibility class extending/implementing `UseCase<T, P>`, injected via GetIt.
- **Dependency Injection via GetIt**: `di/DomainLayerInjection` registers all use cases as singletons, resolving their repository dependencies from the same service locator.
- **Immutable entities**: domain entities are plain immutable Dart classes with `const` constructors and non-nullable required fields. Serialization is handled by the data layer via DTOs and mapper extensions, not by entities themselves.

## Data & Control Flow

1. `presentation/` calls a use case (e.g., `LoginUseCase.call(params)`).
2. Use case delegates to its injected repository (e.g., `UserRepository.login(params)`).
3. Repository contract is fulfilled at runtime by a data-layer implementation (registered in `data/di/`).
4. Data layer maps DTOs → domain entities via mapper extensions (e.g., `PostDto.toDomain()` converts `PostDto` → `Post`).
5. Data flows back: repository → use case → caller.
6. DI bootstrap order: `DataLayerInjection` → `DomainLayerInjection` (registers use cases) → `PresentationLayerInjection`.

## Integration Points

- **Upward (consumers)**: `presentation/` layer imports use cases and entities.
- **Downward (providers)**: `data/` layer implements abstract repositories, maps DTOs to entities via mapper extensions, and registers concrete repository instances with GetIt.
- **Core**: `core/domain/usecase/use_case.dart` provides the `UseCase<T, P>` abstract base class.
- **DI**: `di/service_locator.dart` (`getIt`) is the shared service-locator instance; `DomainLayerInjection` is called by `ServiceLocator.configureDependencies()`.