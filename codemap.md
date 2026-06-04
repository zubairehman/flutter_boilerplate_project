# Repository Atlas: flutter_boilerplate

## Project Responsibility

A Flutter clean-architecture boilerplate application built around MobX state management, Provider-compatible dependency registration through GetIt, Dio HTTP clients, Sembast local persistence, secure storage, SharedPreferences settings, connectivity/device services, JWT helpers, and generated platform shells for Android, iOS, and Web.

## System Entry Points

- `lib/main.dart`: Flutter/Dart entry point. Initializes bindings, locks device orientations, configures service locator dependencies, and launches `MyApp`.
- `lib/presentation/my_app.dart`: Root widget. Wires routing, localization, theme stores, and login-gated initial navigation.
- `lib/di/service_locator.dart`: Application composition root using GetIt. Registers Data, Domain, and Presentation layers in sequence.
- `pubspec.yaml`: Package manifest, dependency versions, asset declarations, and ProductSans font registration.
- `analysis_options.yaml`: Dart analyzer/linter configuration using `package:flutter_lints/flutter.yaml`.
- `android/app/build.gradle`, `ios/Runner/AppDelegate.swift`, `web/index.html`: Platform entry/configuration points that host the Flutter runtime.

## Architectural Overview

- **Dependency direction**: `presentation/` and `data/` depend on `domain/`; `domain/` defines entities, repository contracts, and use cases.
- **State management**: MobX stores (`ThemeStore`, `LanguageStore`, `UserStore`, `PostStore`, `FormStore`, `ErrorStore`) expose observable state to Flutter widgets through `Observer`.
- **Data access**: Repository implementations coordinate remote APIs (`PostApi`, Dio clients), local Sembast data sources, secure storage, SharedPreferences helpers, connectivity checks, and device metadata helpers.
- **Composition**: Layer-specific injection modules register services, repositories, use cases, and stores into the global GetIt service locator.
- **Localization and routing**: JSON translations load through `AppLocalizations`; named route constants map to login/home/post screens.

## Root Asset Map

| Asset | Responsibility |
|---|---|
| `pubspec.yaml` | Declares Flutter SDK constraints, MobX/Dio/GetIt/Sembast/SharedPreferences/secure-storage/connectivity/device-info/JWT dependencies, assets, fonts, and launcher-icon/native-splash configuration. |
| `analysis_options.yaml` | Enables Flutter lint rules and centralizes analyzer behavior. |
| `android/` | Android Gradle project and native FlutterActivity host. |
| `ios/` | iOS Xcode/CocoaPods project and Runner host application. |
| `web/` | Flutter web HTML shell, PWA manifest, and generated native-splash markup. |
| `assets/` | Runtime images, icons, fonts, and translation JSON referenced from `pubspec.yaml` (translations excluded from codemap scope). |
| `test/` | Flutter tests excluded from this codemap by workflow rule. |

## Repository Directory Map

| Directory | Responsibility Summary | Detailed Map |
|---|---|---|
| `android/` | Android platform shell for the Flutter boilerplate app. Houses the Gradle build system, project-wide configuration, and the native Android app module that hosts the Flutter engine at… | [View Map](android/codemap.md) |
| `ios/` | iOS platform shell for the Flutter boilerplate app. Contains the Xcode project, CocoaPods dependency management, Flutter build configuration (xcconfig files), and the Runner application… | [View Map](ios/codemap.md) |
| `lib/` | Top-level application shell and architectural root. Owns `main.dart` (app entry point), delegates to `di/` for dependency injection, `constants/` for static configuration, and `utils/` for… | [View Map](lib/codemap.md) |
| `web/` | Web platform target for the Flutter boilerplate app. Contains the HTML entrypoint (`index.html`), PWA manifest (`manifest.json`), native splash markup/assets, and static assets. The Flutter engine is… | [View Map](web/codemap.md) |
| `android/app/` | The sole Android application module. Defines the APK/AAB build configuration, links the Flutter engine, declares the native `MainActivity` entrypoint, and provides per-build-type Android… | [View Map](android/app/codemap.md) |
| `ios/Runner/` | iOS application target containing the native entrypoint (`AppDelegate.swift`), app configuration (`Info.plist`), UI storyboards, bridging header, and asset catalogs. This is the minimal… | [View Map](ios/Runner/codemap.md) |
| `lib/constants/` | Declares app-wide static configuration values: theme data, color palettes, dimension spacing, asset paths, font family names, and string literals. All classes are non-instantiable (private… | [View Map](lib/constants/codemap.md) |
| `lib/core/` | Shared infrastructure layer for the entire app: domain models, use-case abstraction, data access (network + local persistence + shared prefs + crypto), MobX reactive stores, common widgets, and Dart… | [View Map](lib/core/codemap.md) |
| `lib/data/` | Data layer of the clean architecture — implements domain repository abstractions by coordinating remote APIs, local databases, shared preferences, secure storage, connectivity, and device services. Owns… | [View Map](lib/data/codemap.md) |
| `lib/di/` | Centralizes dependency injection configuration for the entire app. Orchestrates layer-by-layer registration of services, repositories, and presentation dependencies into the GetIt service… | [View Map](lib/di/codemap.md) |
| `lib/domain/` | Domain layer of the Clean Architecture stack. Owns all business entities, repository contracts, use case orchestration, and domain-layer DI wiring. Contains zero data-source or UI code;… | [View Map](lib/domain/codemap.md) |
| `lib/presentation/` | Root of the presentation layer. Owns the `MyApp` widget — the Flutter `MaterialApp` entry point that configures routing, theming, locale, and the initial route based on authentication… | [View Map](lib/presentation/codemap.md) |
| `lib/utils/` | Aggregates shared utility modules: device dimension helpers, Dio HTTP error handling/retry logic, JWT sign/verify/decode helpers, i18n localization, and named route definitions.… | [View Map](lib/utils/codemap.md) |
| `android/app/src/` | Android source set root, partitioned into build-type directories (`main/`, `debug/`, `profile/`) that follow the standard Android Gradle source-set merge convention. | [View Map](android/app/src/codemap.md) |
| `lib/core/data/` | Infrastructure layer for data access: network HTTP client (Dio), local NoSQL database (Sembast), encryption codec (XXTEA), and shared preferences abstraction. Houses the concrete… | [View Map](lib/core/data/codemap.md) |
| `lib/core/domain/` | Pure domain layer containing business entity models and the abstract use-case contract. Has no dependency on Flutter or infrastructure packages. | [View Map](lib/core/domain/codemap.md) |
| `lib/core/extensions/` | Reusable Dart `String` extension methods for capitalization transformations. | [View Map](lib/core/extensions/codemap.md) |
| `lib/core/stores/` | MobX reactive state management stores: form validation state (`FormStore`) and error message display (`ErrorStore`). Provide observable state and actions that UI widgets react to via… | [View Map](lib/core/stores/codemap.md) |
| `lib/core/widgets/` | Shared UI primitive widgets used across multiple feature screens: styled text field, rounded button, loading indicator, empty app bar, and responsive app icon. | [View Map](lib/core/widgets/codemap.md) |
| `lib/data/di/` | Root of data-layer dependency injection. `DataLayerInjection.configureDataLayerInjection()` is the single entry point that bootstraps all data-layer registrations by delegating to… | [View Map](lib/data/di/codemap.md) |
| `lib/data/local/` | Manages on-device persistent storage using Sembast (NoSQL) and defines database constants. Data source classes perform CRUD operations against the local database and are consumed by… | [View Map](lib/data/local/codemap.md) |
| `lib/data/network/` | Handles all remote data communication. Houses HTTP client wrappers (`DioClient`, `RestClient`), API endpoint definitions, network interceptors, and exception types. API classes under… | [View Map](lib/data/network/codemap.md) |
| `lib/data/repository/` | Contains concrete implementations of domain repository abstractions. Each subfolder maps to one domain repository interface and provides the data-layer logic that coordinates remote APIs,… | [View Map](lib/data/repository/codemap.md) |
| `lib/data/sharedpref/` | Provides `SharedPreferenceHelper` — a typed wrapper over `SharedPreferences` for reading/writing app-wide key-value settings (auth token, login state, dark mode, language). Also defines… | [View Map](lib/data/sharedpref/codemap.md) |
| `lib/domain/di/` | Wires the domain layer's dependency injection: registers all use cases and their repository dependencies with the GetIt service locator during app startup. | [View Map](lib/domain/di/codemap.md) |
| `lib/domain/entity/` | Defines all domain model / business entity classes used across the domain and presentation layers. Entities are plain Dart classes with no framework dependencies — the canonical… | [View Map](lib/domain/entity/codemap.md) |
| `lib/domain/repository/` | Defines abstract repository contracts that decouple domain business logic from data source details. Each subfolder contains one repository interface per feature area, declaring the… | [View Map](lib/domain/repository/codemap.md) |
| `lib/domain/usecase/` | Contains all use case classes — single-responsibility command objects that encapsulate domain operations. Each use case implements `UseCase<T, P>` from `core/domain/usecase/use_case.dart`,… | [View Map](lib/domain/usecase/codemap.md) |
| `lib/presentation/di/` | Presentation-layer dependency injection entry point. `PresentationLayerInjection.configurePresentationLayerInjection()` is the sole public API — it delegates to `StoreModule` to register… | [View Map](lib/presentation/di/codemap.md) |
| `lib/presentation/home/` | Home screen after successful login. `HomeScreen` is a `StatefulWidget` that renders an `AppBar` with theme-toggle, language-picker, and logout actions, and a `PostListScreen` body. | [View Map](lib/presentation/home/codemap.md) |
| `lib/presentation/login/` | Login screen with email/password form. `LoginScreen` is a `StatefulWidget` that renders a responsive layout (landscape: side-by-side, portrait: centered form), drives authentication via… | [View Map](lib/presentation/login/codemap.md) |
| `lib/presentation/post/` | Post list feature screen. `PostListScreen` is a `StatefulWidget` that fetches and displays a `ListView` of posts from `PostStore`. Loaded in the body of `HomeScreen`. | [View Map](lib/presentation/post/codemap.md) |
| `lib/utils/device/` | Provides device and screen dimension utility methods for responsive layout calculations and keyboard management. | [View Map](lib/utils/device/codemap.md) |
| `lib/utils/dio/` | Provides Dio HTTP client utilities: human-readable error message mapping and automatic request retry with configurable retry count, interval, and evaluator. | [View Map](lib/utils/dio/codemap.md) |
| `lib/utils/jwt/` | Provides `JwtHelper`, a safe-by-default wrapper around `dart_jsonwebtoken` for signing, verifying, and decoding JWT payloads. | [View Map](lib/utils/jwt/codemap.md) |
| `lib/utils/locale/` | Implements runtime i18n by loading locale-specific JSON string files from assets and providing translation lookups to the widget tree via Flutter's `Localizations` framework. | [View Map](lib/utils/locale/codemap.md) |
| `lib/utils/routes/` | Defines named route path constants and a static route-to-`WidgetBuilder` map for Flutter's `Navigator` 1.0 API. | [View Map](lib/utils/routes/codemap.md) |
| `android/app/src/debug/` | Debug-specific Android manifest overlay that declares the `INTERNET` permission required by the Flutter tooling for hot-reload, breakpoint debugging, and DevTools communication during… | [View Map](android/app/src/debug/codemap.md) |
| `android/app/src/main/` | Primary Android source set containing the production application definition: `AndroidManifest.xml` (activity declaration, permissions, Flutter embedding metadata), the Kotlin `MainActivity`… | [View Map](android/app/src/main/codemap.md) |
| `android/app/src/profile/` | Profile-specific Android manifest overlay that declares the `INTERNET` permission required by the Flutter tooling for performance profiling builds. Profile builds use AOT compilation like… | [View Map](android/app/src/profile/codemap.md) |
| `lib/core/data/local/` | Local data infrastructure: Sembast NoSQL database client and XXTEA encryption codec for database-level encryption. Supports both native and web platforms. | [View Map](lib/core/data/local/codemap.md) |
| `lib/core/data/network/` | Network infrastructure: HTTP client configuration (Dio), connection constants, and an interceptor chain (auth, retry, logging). Provides all HTTP communication primitives for feature… | [View Map](lib/core/data/network/codemap.md) |
| `lib/core/data/sharedpref/` | Defines the `BaseSharedPreferenceHelper` mixin contract for shared preferences cleanup. Concrete implementations live in feature or DI modules. | [View Map](lib/core/data/sharedpref/codemap.md) |
| `lib/core/domain/model/` | Defines shared domain DTOs used for inter-screen navigation and argument passing. | [View Map](lib/core/domain/model/codemap.md) |
| `lib/core/domain/usecase/` | Provides the abstract `UseCase<T, P>` contract that all feature-level use cases implement. Enforces a single `call({required P params})` signature returning `FutureOr<T>`. | [View Map](lib/core/domain/usecase/codemap.md) |
| `lib/core/stores/error/` | MobX store for displaying transient error messages. Auto-clears `errorMessage` 200ms after being set via a MobX reaction. | [View Map](lib/core/stores/error/codemap.md) |
| `lib/core/stores/form/` | MobX stores for form field state and validation: `FormStore` manages email/password/confirm-password inputs and computed readiness flags; `FormErrorStore` tracks per-field validation error… | [View Map](lib/core/stores/form/codemap.md) |
| `lib/data/di/module/` | Contains three DI module classes that register data-layer singletons into the global `getIt` service locator: `LocalModule`, `NetworkModule`, `RepositoryModule`. | [View Map](lib/data/di/module/codemap.md) |
| `lib/data/connectivity/` | Provides `ConnectivityService`, a facade over `connectivity_plus` for connection status, connection type, and connectivity change streams. | [View Map](lib/data/connectivity/codemap.md) |
| `lib/data/device_info/` | Provides `DeviceInfoService`, a platform-dispatch facade over `device_info_plus` for device metadata, device name, operating system, and device identifier access. | [View Map](lib/data/device_info/codemap.md) |
| `lib/data/local/constants/` | Defines `DBConstants` — static constants for Sembast database name, store name, and field keys used across local data sources. | [View Map](lib/data/local/constants/codemap.md) |
| `lib/data/local/datasources/` | Parent directory for local data source classes. Each subfolder contains a data source that performs CRUD operations against the Sembast local database for a specific domain entity. | [View Map](lib/data/local/datasources/codemap.md) |
| `lib/data/network/apis/` | Parent directory for API classes organized by domain resource. Each subfolder contains an API class that makes HTTP calls for that resource using `DioClient` and/or `RestClient`. | [View Map](lib/data/network/apis/codemap.md) |
| `lib/data/network/constants/` | Defines `Endpoints` — static constants for the base URL, timeouts, and API route paths used by network clients and API classes. | [View Map](lib/data/network/constants/codemap.md) |
| `lib/data/network/exceptions/` | Defines network-related exception types: `NetworkException` (base) and `AuthException` (for authentication failures). | [View Map](lib/data/network/exceptions/codemap.md) |
| `lib/data/network/interceptors/` | Contains `ErrorInterceptor` — a Dio interceptor that captures request errors and publishes them via `EventBus` for app-wide error handling. | [View Map](lib/data/network/interceptors/codemap.md) |
| `lib/data/repository/post/` | `PostRepositoryImpl` implements `PostRepository` from the domain layer. Coordinates both remote (`PostApi`) and local (`PostDataSource`) data sources — fetches posts from the API with… | [View Map](lib/data/repository/post/codemap.md) |
| `lib/data/repository/setting/` | `SettingRepositoryImpl` implements `SettingRepository` from the domain layer. Manages app settings (dark mode toggle, language selection) by delegating all operations to… | [View Map](lib/data/repository/setting/codemap.md) |
| `lib/data/repository/user/` | `UserRepositoryImpl` implements `UserRepository` from the domain layer. Handles user login (currently simulated) and login-state persistence via `SharedPreferenceHelper`. | [View Map](lib/data/repository/user/codemap.md) |
| `lib/data/secure_storage/` | Provides `SecureStorageHelper`, an async facade over `flutter_secure_storage` for auth token CRUD backed by platform encryption options. | [View Map](lib/data/secure_storage/codemap.md) |
| `lib/data/secure_storage/constants/` | Defines `SecureStorageKeys`, the key namespace for secure-storage values such as `authToken`. | [View Map](lib/data/secure_storage/constants/codemap.md) |
| `lib/data/sharedpref/constants/` | Defines `Preferences` — static string constants for SharedPreferences key names used by `SharedPreferenceHelper`. | [View Map](lib/data/sharedpref/constants/codemap.md) |
| `lib/domain/di/module/` | `UseCaseModule` registers all domain use cases as singletons in the GetIt service locator, resolving their repository dependencies from already-registered repository implementations. | [View Map](lib/domain/di/module/codemap.md) |
| `lib/domain/entity/language/` | Defines the `Language` entity — domain model for locale/language settings including country code, locale code, display name, and an optional industry-specific dictionary map. | [View Map](lib/domain/entity/language/codemap.md) |
| `lib/domain/entity/post/` | Defines the `Post` and `PostList` entities — domain models representing a single blog post and a collection of posts respectively. | [View Map](lib/domain/entity/post/codemap.md) |
| `lib/domain/entity/user/` | Defines the `User` entity — the domain model representing an authenticated user. Currently a stub class with no fields (placeholder for future extension). | [View Map](lib/domain/entity/user/codemap.md) |
| `lib/domain/repository/post/` | Defines `PostRepository` — the abstract contract for CRUD operations on `Post` entities. | [View Map](lib/domain/repository/post/codemap.md) |
| `lib/domain/repository/setting/` | Defines `SettingRepository` — the abstract contract for app-wide settings: theme brightness mode and language preference. | [View Map](lib/domain/repository/setting/codemap.md) |
| `lib/domain/repository/user/` | Defines `UserRepository` — the abstract contract for user authentication and login-status persistence. | [View Map](lib/domain/repository/user/codemap.md) |
| `lib/domain/usecase/post/` | Post CRUD use cases: fetch all posts, find by ID, insert, update, and delete. Each wraps a single `PostRepository` method. | [View Map](lib/domain/usecase/post/codemap.md) |
| `lib/domain/usecase/user/` | User authentication and login-status use cases: logging in, checking login state, and persisting the login flag. | [View Map](lib/domain/usecase/user/codemap.md) |
| `lib/presentation/di/module/` | Concrete DI registration for all presentation-layer MobX stores. `StoreModule.configureStoreModuleInjection()` registers factories for `ErrorStore`, `FormErrorStore`, `FormStore` and… | [View Map](lib/presentation/di/module/codemap.md) |
| `lib/presentation/home/store/` | Container folder for home-feature MobX stores — delegates to `theme/` and `language/` sub-folders. No Dart files exist at this level; it groups `ThemeStore` and `LanguageStore` as the… | [View Map](lib/presentation/home/store/codemap.md) |
| `lib/presentation/login/store/` | Authentication state management. `UserStore` (MobX) manages login flow, logged-in status, and success state. Delegates actual authentication to domain `LoginUseCase` and persistence to… | [View Map](lib/presentation/login/store/codemap.md) |
| `lib/presentation/post/store/` | Post data state management. `PostStore` (MobX) fetches posts via `GetPostUseCase`, tracks loading/success/error state, and exposes `postList` observable for UI consumption. | [View Map](lib/presentation/post/store/codemap.md) |
| `android/app/src/main/kotlin/` | Kotlin source root for the Android application module. Contains the native platform code under the reverse-domain package path `com/iotecksolutions/flutterboilerplate/`. | [View Map](android/app/src/main/kotlin/codemap.md) |
| `lib/core/data/local/encryption/` | Provides XXTEA-based encryption codec for Sembast database encryption. Implements `dart:convert` `Codec<Map<String, dynamic>, String>` for transparent encode/decode. | [View Map](lib/core/data/local/encryption/codemap.md) |
| `lib/core/data/local/sembast/` | Provides `SembastClient`, the database accessor for Sembast NoSQL storage. Handles platform-aware database initialization with optional XXTEA encryption. | [View Map](lib/core/data/local/sembast/codemap.md) |
| `lib/core/data/network/constants/` | Centralizes network configuration constants: base API URL, receive timeout, and connection timeout. | [View Map](lib/core/data/network/constants/codemap.md) |
| `lib/core/data/network/dio/` | Wraps the `Dio` HTTP client with configurable options (`DioConfigs`) and pluggable interceptors. Central entry point for all HTTP requests in the app. | [View Map](lib/core/data/network/dio/codemap.md) |
| `lib/data/local/datasources/post/` | `PostDataSource` provides local CRUD operations for `Post` entities using Sembast. Acts as the offline cache layer consumed by `PostRepositoryImpl`. | [View Map](lib/data/local/datasources/post/codemap.md) |
| `lib/data/network/apis/posts/` | `PostApi` provides remote data access for the Post domain entity. Fetches posts from `jsonplaceholder.typicode.com` via `DioClient`. | [View Map](lib/data/network/apis/posts/codemap.md) |
| `lib/presentation/home/store/language/` | Manages the app's locale/language state. `LanguageStore` exposes `locale` observable, `supportedLanguages` list, and `changeLanguage(String)` action. Persists preference via… | [View Map](lib/presentation/home/store/language/codemap.md) |
| `lib/presentation/home/store/theme/` | Manages the app's dark/light theme state. `ThemeStore` exposes `darkMode` observable and `changeBrightnessToDark(bool)` action. Persists preference via `SettingRepository`. | [View Map](lib/presentation/home/store/theme/codemap.md) |
| `android/app/src/main/kotlin/com/` | Top of the reverse-domain package hierarchy (`com.*`). Contains the `iotecksolutions/` organization package. | [View Map](android/app/src/main/kotlin/com/codemap.md) |
| `lib/core/data/network/dio/configs/` | Defines `DioConfigs`, an immutable configuration object holding HTTP client settings: base URL, receive timeout, connection timeout. | [View Map](lib/core/data/network/dio/configs/codemap.md) |
| `lib/core/data/network/dio/interceptors/` | HTTP interceptors for the Dio client: authentication token injection (`AuthInterceptor`), automatic retry on transient failures (`RetryInterceptor`), and structured request/response logging… | [View Map](lib/core/data/network/dio/interceptors/codemap.md) |
| `android/app/src/main/kotlin/com/iotecksolutions/` | Organization-level namespace package (`com.iotecksolutions`). Contains the `flutterboilerplate/` application package. | [View Map](android/app/src/main/kotlin/com/iotecksolutions/codemap.md) |
| `android/app/src/main/kotlin/com/iotecksolutions/flutterboilerplate/` | Application package containing `MainActivity.kt` — the native Android entrypoint for the Flutter app. This is the thinnest possible native layer; all business logic resides in the Dart… | [View Map](android/app/src/main/kotlin/com/iotecksolutions/flutterboilerplate/codemap.md) |

## Change Detection

Codemap state is tracked in `.slim/codemap.json`. Re-run the codemap workflow to detect changed source/config files and update only affected directory maps.
