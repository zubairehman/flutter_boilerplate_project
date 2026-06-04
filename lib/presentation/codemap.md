# lib/presentation/

## Responsibility
Root of the presentation layer. Owns the `MyApp` widget — the Flutter `MaterialApp` entry point that configures routing, theming, locale, and the initial route based on authentication state. `MyApp` directly renders `HomeScreen` or `LoginScreen`; `PostListScreen` is nested inside `HomeScreen`. The DI wiring module lives in `di/`.

## Design Patterns
- **Feature-first folder structure**: `home/`, `login/`, `post/`, `di/` — each feature bundles its own screens and MobX stores.
- **MobX + Observer**: Reactive UI via `@observable`/`@action` stores consumed through `flutter_mobx` `Observer` widgets.
- **Service Locator (get_it)**: Stores resolved at widget-creation time via `getIt<T>()` from the global service locator; all store registrations happen in `di/`.

## Data & Control Flow
1. `MyApp.build()` reads `UserStore.isLoggedIn` (from `login/store/`) inside an `Observer` to choose `HomeScreen` vs `LoginScreen` as the `home` widget.
2. `ThemeStore.darkMode` drives `MaterialApp.theme` (light/dark switch).
3. `LanguageStore.locale` + `supportedLanguages` drive `MaterialApp.locale` and `supportedLocales`.
4. `Routes.routes` (from `utils/routes/`) supplies the named-route table.
5. Navigation is imperative (`Navigator.pushNamedAndRemoveUntil`, `pushReplacementNamed`).

## Integration Points
- **Domain layer**: Stores call domain use cases (`LoginUseCase`, `GetPostUseCase`, `IsLoggedInUseCase`, `SaveLoginStatusUseCase`) and repositories (`SettingRepository`).
- **DI**: `PresentationLayerInjection.configurePresentationLayerInjection()` → `StoreModule.configureStoreModuleInjection()` registers all stores as singletons into `getIt`.
- **Core stores**: `ErrorStore`, `FormStore`/`FormErrorStore` from `core/stores/` are injected into every feature store.
- **Utils**: `AppLocalizations` (i18n), `Routes` (navigation), `DeviceUtils` (keyboard), `DioExceptionUtil` (error mapping).
- **Shared preferences**: Direct `SharedPreferences` usage in `HomeScreen._buildLogoutButton()` and `LoginScreen.navigate()` for `Preferences.is_logged_in`.