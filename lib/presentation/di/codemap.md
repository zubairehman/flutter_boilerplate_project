# lib/presentation/di/

## Responsibility
Presentation-layer dependency injection entry point. `PresentationLayerInjection.configurePresentationLayerInjection()` is the sole public API — it delegates to `StoreModule` to register all MobX stores into the global `getIt` service locator.

## Design Patterns
- **Facade**: `PresentationLayerInjection` hides the module-level wiring behind a single static method.
- **Centralized registration**: All store construction and registration lives in `module/StoreModule`, keeping this folder a thin orchestration shim.

## Data & Control Flow
1. App startup calls `PresentationLayerInjection.configurePresentationLayerInjection()`.
2. That calls `StoreModule.configureStoreModuleInjection()`, which registers factories (ErrorStore, FormErrorStore, FormStore) and singletons (UserStore, PostStore, ThemeStore, LanguageStore) into `getIt`.
3. Widgets resolve stores via `getIt<T>()` at construction time.

## Integration Points
- **`module/store_module.dart`**: Performs all `getIt.registerSingleton`/`registerFactory` calls.
- **`../../di/service_locator.dart`**: Provides the global `getIt` instance.
- **Domain layer**: `StoreModule` imports domain use cases and repositories to inject them into stores.