# lib/data/di/

## Responsibility
Root of data-layer dependency injection. `DataLayerInjection.configureDataLayerInjection()` is the single entry point that bootstraps all data-layer registrations by delegating to `LocalModule`, `NetworkModule`, and `RepositoryModule`.

## Design Patterns
- **Facade pattern**: Single static method hides the three-module registration sequence.
- **Ordered initialization**: Local → Network → Repository, ensuring dependencies (including `SecureStorageHelper`, `DeviceInfoService`, `ConnectivityService`) are available before dependents register.

## Data & Control Flow
`DataLayerInjection.configureDataLayerInjection()` → `LocalModule.configureLocalModuleInjection()` → `NetworkModule.configureNetworkModuleInjection()` → `RepositoryModule.configureRepositoryModuleInjection()`.

## Integration Points
- Called from app startup (outside data layer) to register all data-layer singletons.
- Delegates to `module/` subdirectory for concrete registrations.
- Uses `getIt` from `lib/di/service_locator.dart`.