# lib/core/
## Responsibility
Shared infrastructure layer for the entire app: domain models, use-case abstraction, data access (network + local persistence + shared prefs), MobX reactive stores, common widgets, and Dart extensions. Provides reusable building blocks that feature modules depend on.

## Design Patterns
- **Clean Architecture**: `domain/` (pure), `data/` (infrastructure), `stores/` (presentation state), `widgets/` (UI). Domain has zero dependency on data layer.
- **MobX code-gen stores**: `FormStore`, `FormErrorStore`, `ErrorStore` use `@observable`/`@action`/`@computed` with generated `.g.dart` mixin merging.
- **Repository/Data-source separation**: `data/local` and `data/network` are independent data-source packages; feature repositories compose them.
- **Interceptor chain**: Dio HTTP client configured with pluggable interceptors (auth, retry, logging).

## Data & Control Flow
1. Feature modules invoke `UseCase<T, P>.call(params)`.
2. Use cases delegate to repositories which call `DioClient.dio` (network) or `SembastClient.database` (local) or `BaseSharedPreferenceHelper` (prefs) or `CryptoService` (string encryption/HMAC/hashing).
3. Network responses flow through `AuthInterceptor` → `RetryInterceptor` → `LoggingInterceptor`.
4. Local DB writes/reads pass through `xxtea` codec when encryption key is provided.
5. Store observables (`FormStore`, `ErrorStore`) drive UI reactivity via `Observer` widgets in feature layers.

## Integration Points
- **domain/** → consumed by feature use cases and repositories.
- **data/network** → consumed by feature repository implementations for remote data.
- **data/local** → consumed by feature repository implementations for cached/persisted data; `CryptoService` for string-level encryption, HMAC, and hashing.
- **data/sharedpref** → consumed by feature repositories for key-value preferences.
- **stores/** → consumed by feature ViewModels and injected via DI.
- **widgets/** → consumed by feature screen widgets.
- **extensions/** → imported wherever `String` casing utilities are needed.