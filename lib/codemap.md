# lib/

## Responsibility

Top-level application shell and architectural root. Owns `main.dart` (app entry point), delegates to `di/` for dependency injection, `constants/` for static configuration, and `utils/` for shared utilities such as Dio, localization, routes, and JWT helpers. Orchestrates startup: initializes bindings, configures orientations, registers DI, and launches the Flutter widget tree with auth bootstrap.

## Design Patterns

- **Clean Architecture layers**: `data/`, `domain/`, `presentation/` separated by dependency direction (data & presentation depend on domain; domain has no dependencies).
- **Service Locator (GetIt)**: `di/service_locator.dart` registers singletons/factories per layer; accessed globally via `getIt`.
- **Static-only classes**: `constants/` and `utils/` use private constructors (`._()`) to prevent instantiation.
- **Layered DI initialization**: Each layer owns its own injection module (`DataLayerInjection`, `DomainLayerInjection`, `PresentationLayerInjection`).
- **DTO + Mapper separation**: Data layer uses DTOs (`data/network/dto/`) and mapper extensions (`data/mapper/`) to convert between wire-format JSON and immutable domain entities.
- **Encrypted local persistence**: Sembast database encrypted via key from `SecureStorageHelper.getOrCreateDatabaseEncryptionKey()`.

## Data & Control Flow

1. `main()` → `WidgetsFlutterBinding.ensureInitialized()`
2. `main()` → `setPreferredOrientations()` (locks to portrait + landscape via `SystemChrome`)
3. `main()` → `ServiceLocator.configureDependencies()` (registers all DI bindings layer by layer; async for encrypted DB init)
4. `main()` → `runApp(MyApp())` (hands off to presentation layer)
5. `MyApp.initState()` → `_userStore.bootstrapAuth()` → sets `isAuthBootstrapped` + `isLoggedIn`

## Integration Points

- [di/codemap.md](di/codemap.md) — dependency injection registry and GetIt configuration
- [constants/codemap.md](constants/codemap.md) — theme, colors, dimensions, assets (`appLogo`, `carBackground`), strings (`appName`), fonts (non-const `FontFamily`)
- [utils/codemap.md](utils/codemap.md) — device helpers, Dio interceptors (retry with `shouldLog`/`dart:developer.log`), JWT helpers, localization (key fallback, escape normalization), routing
- `presentation/` — widget tree root (`MyApp` with `bootstrapAuth`/`isAuthBootstrapped` gate), receives DI via `getIt`
- `data/` — network/repository/storage layer with DTO+mapper pattern, encrypted Sembast, offline fallback; provides `DataLayerInjection`
- `domain/` — business logic layer with immutable entities, repository contracts, use cases; provides `DomainLayerInjection`