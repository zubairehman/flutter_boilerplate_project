# lib/presentation/di/module/

## Responsibility
Concrete DI registration for all presentation-layer MobX stores. `StoreModule.configureStoreModuleInjection()` registers factories for `ErrorStore`, `FormErrorStore`, `FormStore` and singletons for `UserStore`, `PostStore`, `ThemeStore`, `LanguageStore` into the global `getIt` service locator.

## Design Patterns
- **Manual DI via `get_it`**: No code generation; each `registerSingleton`/`registerFactory` call constructs the store with resolved dependencies.
- **Factory vs Singleton**: `ErrorStore` and `FormErrorStore`/`FormStore` are factories (new instance per resolve); feature stores are singletons (shared state across app).

## Data & Control Flow
1. `configureStoreModuleInjection()` is called once at startup.
2. Factory registrations: `ErrorStore()`, `FormErrorStore()`, `FormStore(FormErrorStore, ErrorStore)`.
3. Singleton registrations in order: `UserStore(IsLoggedInUseCase, SaveLoginStatusUseCase, LoginUseCase, FormErrorStore, ErrorStore)`, `PostStore(GetPostUseCase, ErrorStore)`, `ThemeStore(SettingRepository, ErrorStore)`, `LanguageStore(SettingRepository, ErrorStore)`.

## Integration Points
- **Domain use cases**: `IsLoggedInUseCase`, `SaveLoginStatusUseCase`, `LoginUseCase`, `GetPostUseCase` — resolved from `getIt` (registered earlier by domain-layer DI).
- **Domain repositories**: `SettingRepository` — resolved from `getIt`.
- **Core stores**: `ErrorStore`, `FormErrorStore` — used as factory dependencies.
- **`../../../di/service_locator.dart`**: Provides the `getIt` singleton.