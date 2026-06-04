# lib/domain/di/

## Responsibility

Wires the domain layer's dependency injection: registers all use cases and their repository dependencies with the GetIt service locator during app startup.

## Design Patterns

- **Layer DI entry point**: `DomainLayerInjection` is the facade called by `ServiceLocator.configureDependencies()`; delegates to `UseCaseModule`.
- **Module pattern**: `module/UseCaseModule` encapsulates use-case registration, keeping DI wiring separate from domain logic.

## Data & Control Flow

1. `ServiceLocator.configureDependencies()` calls `DomainLayerInjection.configureDomainLayerInjection()`.
2. `DomainLayerInjection` delegates to `UseCaseModule.configureUseCaseModuleInjection()`.
3. `UseCaseModule` resolves repository singletons from GetIt and constructs each use case, registering them as singletons.

## Integration Points

- **Called by**: `di/service_locator.dart` (`ServiceLocator`), after `DataLayerInjection` (repositories must exist first).
- **Imports**: `usecase/` (all use case classes), `repository/` (`UserRepository`, `PostRepository`), `di/service_locator.dart` (`getIt`).