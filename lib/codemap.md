# lib/

## Responsibility

Top-level application shell and architectural root. Owns `main.dart` (app entry point), delegates to `di/` for dependency injection, `constants/` for static configuration, and `utils/` for shared utilities such as Dio, localization, routes, and JWT helpers. Orchestrates startup: initializes bindings, configures orientations, registers DI, and launches the Flutter widget tree.

## Design Patterns

- **Clean Architecture layers**: `data/`, `domain/`, `presentation/` separated by dependency direction (data & presentation depend on domain; domain has no dependencies).
- **Service Locator (GetIt)**: `di/service_locator.dart` registers singletons/factories per layer; accessed globally via `getIt`.
- **Static-only classes**: `constants/` and `utils/` use private constructors (`._()`) to prevent instantiation.
- **Layered DI initialization**: Each layer owns its own injection module (`DataLayerInjection`, `DomainLayerInjection`, `PresentationLayerInjection`).

## Data & Control Flow

1. `main()` → `WidgetsFlutterBinding.ensureInitialized()`
2. `main()` → `setPreferredOrientations()` (locks to portrait + landscape via `SystemChrome`)
3. `main()` → `ServiceLocator.configureDependencies()` (registers all DI bindings layer by layer)
4. `main()` → `runApp(MyApp())` (hands off to presentation layer)

## Integration Points

- [di/codemap.md](di/codemap.md) — dependency injection registry and GetIt configuration
- [constants/codemap.md](constants/codemap.md) — theme, colors, dimensions, assets, strings, fonts
- [utils/codemap.md](utils/codemap.md) — device helpers, Dio interceptors, JWT helpers, localization, routing
- `presentation/` — widget tree root (`MyApp`), receives DI via `getIt`
- `data/` — network/repository/storage/service layer, provides `DataLayerInjection`
- `domain/` — business logic layer, provides `DomainLayerInjection`
