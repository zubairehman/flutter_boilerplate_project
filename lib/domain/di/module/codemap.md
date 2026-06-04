# lib/domain/di/module/

## Responsibility

`UseCaseModule` registers all domain use cases as singletons in the GetIt service locator, resolving their repository dependencies from already-registered repository implementations.

## Design Patterns

- **Module pattern**: single class `UseCaseModule` with one static method `configureUseCaseModuleInjection()`.
- **Singleton registration**: all use cases registered as `getIt.registerSingleton<T>()`.
- **Constructor injection via locator**: each use case is constructed with `getIt<RepositoryType>()` — pulling the concrete repository from GetIt.

### Registered Singletons

| Singleton Type | Concrete Instance | Repository Dependency |
|---|---|---|
| `IsLoggedInUseCase` | `IsLoggedInUseCase(getIt<UserRepository>())` | `UserRepository` |
| `SaveLoginStatusUseCase` | `SaveLoginStatusUseCase(getIt<UserRepository>())` | `UserRepository` |
| `LoginUseCase` | `LoginUseCase(getIt<UserRepository>())` | `UserRepository` |
| `GetPostUseCase` | `GetPostUseCase(getIt<PostRepository>())` | `PostRepository` |
| `FindPostByIdUseCase` | `FindPostByIdUseCase(getIt<PostRepository>())` | `PostRepository` |
| `InsertPostUseCase` | `InsertPostUseCase(getIt<PostRepository>())` | `PostRepository` |
| `UpdatePostUseCase` | `UpdatePostUseCase(getIt<PostRepository>())` | `PostRepository` |
| `DeletePostUseCase` | `DeletePostUseCase(getIt<PostRepository>())` | `PostRepository` |

## Data & Control Flow

1. Called by `DomainLayerInjection.configureDomainLayerInjection()`.
2. Resolves `UserRepository` and `PostRepository` from GetIt (registered earlier by data-layer DI).
3. Constructs use cases with resolved repositories and registers each as a singleton.

## Integration Points

- **Called by**: `di/domain_layer_injection.dart` (`DomainLayerInjection`).
- **Depends on**: `getIt` from `di/service_locator.dart`, all use case classes, `UserRepository`, `PostRepository`.
- **Prerequisite**: data-layer DI must have already registered repository implementations.