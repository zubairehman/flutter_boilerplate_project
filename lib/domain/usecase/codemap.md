# lib/domain/usecase/

## Responsibility

Contains all use case classes — single-responsibility command objects that encapsulate domain operations. Each use case implements `UseCase<T, P>` from `core/domain/usecase/use_case.dart`, takes a repository via constructor injection, and exposes a `call({required P params})` method.

## Design Patterns

- **Use Case / Interactor pattern**: one class per business operation, implementing `UseCase<T, P>` where `T` is the return type and `P` is the parameter type.
- **Constructor injection**: repositories are injected at construction time by `UseCaseModule`.
- **Singleton registration**: all use cases registered as GetIt singletons in `UseCaseModule`.
- **Per-feature subfoldering**: `user/`, `post/`.

## Data & Control Flow

1. Presentation layer obtains use case from GetIt.
2. Calls `useCase.call(params: ...)`.
3. Use case delegates to its repository (e.g., `_userRepository.login(params)`).
4. Repository result flows back to the caller.

## Integration Points

- **Depends on**: `repository/` (abstract contracts), `core/domain/usecase/use_case.dart` (base class), `entity/` (param/return types).
- **Consumed by**: `presentation/` layer (view models / stores / BLoCs).
- **Registered by**: `di/module/usecase_module.dart` via GetIt singletons.