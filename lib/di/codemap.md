# lib/di/

## Responsibility

Centralizes dependency injection configuration for the entire app. Orchestrates layer-by-layer registration of services, repositories, and presentation dependencies into the GetIt service locator.

## Design Patterns

- **Service Locator (GetIt)**: `service_locator.dart` exports `getIt` (`GetIt.instance`) as the global IoC container.
- **Layered registration**: `ServiceLocator.configureDependencies()` calls each layer's injection module in order: `DataLayerInjection` → `DomainLayerInjection` → `PresentationLayerInjection`.
- **Async registration**: `configureDependencies()` is async to support async factory registrations (e.g., DB initialization, token refresh).

## Data & Control Flow

1. `main()` calls `ServiceLocator.configureDependencies()`
2. `DataLayerInjection.configureDataLayerInjection()` — registers data sources, repositories, API clients
3. `DomainLayerInjection.configureDomainLayerInjection()` — registers use cases, domain services
4. `PresentationLayerInjection.configurePresentationLayerInjection()` — registers ViewModels/BLoCs, navigators
5. Any code can resolve dependencies via `getIt<MyType>()`

## Integration Points

- `lib/main.dart` — calls `ServiceLocator.configureDependencies()` at startup
- `lib/data/di/data_layer_injection.dart` — `DataLayerInjection` class
- `lib/domain/di/domain_layer_injection.dart` — `DomainLayerInjection` class
- `lib/presentation/di/presentation_layer_injection.dart` — `PresentationLayerInjection` class
- `package:get_it` — third-party IoC container