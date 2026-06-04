# lib/core/domain/usecase/
## Responsibility
Provides the abstract `UseCase<T, P>` contract that all feature-level use cases implement. Enforces a single `call({required P params})` signature returning `FutureOr<T>`.

## Design Patterns
- **Command Pattern**: Each use case encapsulates one business operation as a callable object.
- **Generic interface**: `T` = return type, `P` = parameter type, allowing type-safe specialization per feature.

## Data & Control Flow
- Feature use cases implement `call()` → invoke repository methods → return domain models or failures.
- Callers simply `useCase.call(params: myParams)` to execute.

## Integration Points
- Extended by every feature use case (e.g., login, post fetching) in `lib/feature/`.
- Injected via DI and consumed by presentation/view-model layers.