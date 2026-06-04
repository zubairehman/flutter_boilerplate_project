# Settings Dialog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a basic placeholder settings dialog, reachable from the home app bar, that exposes live language/theme shortcuts and an About screen showing app + device info.

**Architecture:** New `lib/presentation/settings/` feature mirroring the existing `home/` and `post/` layered pattern. A `SettingsStore` (MobX) lazy-loads app/device info from `package_info_plus` and `device_info_plus`. Two stateless dialog widgets (`SettingsDialog`, `AboutDialog`) read existing `ThemeStore` and `LanguageStore` from `getIt` plus the new `SettingsStore`. The home app bar gets a fourth `IconButton` that opens the dialog; the existing language dialog is extracted into a reusable top-level helper to avoid duplication.

**Tech Stack:** Flutter, MobX + mobx_codegen, get_it, package_info_plus, device_info_plus, the existing JSON localization pattern (`assets/lang/*.json`).

---

## File Map

New:
- `lib/presentation/settings/settings_dialog.dart` — main placeholder dialog
- `lib/presentation/settings/about_dialog.dart` — secondary dialog with app + device info
- `lib/presentation/settings/store/settings_store.dart` — MobX store
- `lib/presentation/settings/store/settings_store.g.dart` — generated
- `test/presentation/settings/settings_dialog_test.dart`
- `test/presentation/settings/about_dialog_test.dart`
- `test/presentation/settings/store/settings_store_test.dart`

Modified:
- `pubspec.yaml` — add `package_info_plus`, `device_info_plus`
- `lib/presentation/di/module/store_module.dart` — register `SettingsStore`
- `lib/presentation/home/home.dart` — add settings `IconButton`; extract `_buildLanguageDialog` into a top-level `showLanguageDialog`
- `assets/lang/en.json`, `es.json`, `da.json` — add new keys
- `test/di/store_module_test.dart` — register the new dependency registration is observed

---

## Conventions

- TDD: write the failing test first, run it, implement, re-run, commit.
- Each commit must leave the project compiling (`flutter analyze` clean) and all existing tests passing.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after writing any `*.dart` file in `lib/**/store/` that has a `part '*.g.dart';` directive.
- Use only platform-agnostic code in `SettingsStore.loadAboutInfo` so the same file works on the host VM (the only platform where the unit test will execute).
- Pre-existing LSP errors in `lib/data/network/rest_client.dart` and `lib/data/network/interceptors/error_interceptor.dart` are out of scope. New errors introduced by this plan are not.

---

## Task 1: Add dependencies and run `pub get`

**Files:**
- Modify: `pubspec.yaml:15-66` (add two lines under `dependencies:`)

- [ ] **Step 1: Add the new runtime dependencies**

In `pubspec.yaml`, under `dependencies:` (alphabetical position: `P` then `D`), add:

```yaml
  # D
  device_info_plus: ^10.0.0
  # P
  package_info_plus: ^8.0.0
```

Insertion (replace the existing `# P` and `# D` comment lines, between `path_provider` and `flutter_secure_storage`):

```yaml
  path_provider: ^2.0.14
  # P
  package_info_plus: ^8.0.0
  # Q
```

And under `# D` (between `crypto` and `dio`):

```yaml
  # D
  dart_jsonwebtoken: ^3.4.1
  device_info_plus: ^10.0.0
  dio: ^5.1.1
```

- [ ] **Step 2: Resolve dependencies**

Run: `flutter pub get`
Expected: `Got dependencies!` and the lockfile is updated. No error.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "deps: add package_info_plus and device_info_plus"
```

---

## Task 2: Add localization keys

**Files:**
- Modify: `assets/lang/en.json`
- Modify: `assets/lang/es.json`
- Modify: `assets/lang/da.json`

- [ ] **Step 1: Add keys to `assets/lang/en.json`**

Replace the file contents with:

```json
{
  "login_start": "Below are list of strings for login",
  "login_et_user_email": "Enter user email",
  "login_et_user_password": "Enter password",
  "login_btn_forgot_password": "Forgot Password?",
  "login_btn_sign_in": "Sign In",
  "login_error_fill_fields": "Please fill in all fields",
  "login_end": "------------------------------------------------------------------------------------",

  "home_start": "Below are list of strings for home",
  "home_tv_posts": "Posts",
  "home_tv_error": "Error",
  "home_tv_no_post_found": "No posts found",
  "home_tv_choose_language": "Choose Language",
  "home_tv_settings": "Settings",
  "home_tv_about": "About",
  "home_end": "-------------------------------------------------------------------------------------",

  "settings_start": "Below are list of strings for settings",
  "settings_et_app_name": "Boilerplate",
  "settings_et_about_description": "A Flutter boilerplate showcasing layered architecture, MobX, and dependency injection.",
  "settings_btn_close": "Close",
  "settings_tv_loading": "Loading…",
  "settings_tv_theme": "Theme",
  "settings_tv_theme_dark": "Dark",
  "settings_tv_theme_light": "Light",
  "settings_tv_error_loading_info": "Unable to load device info.",
  "settings_end": "-------------------------------------------------------------------------------------"
}
```

- [ ] **Step 2: Add keys to `assets/lang/es.json`**

Replace the file contents with:

```json
{
  "login_start": "Below are list of strings for login es ",
  "login_et_user_email": "Ingrese el correo electrónico del usuario",
  "login_et_user_password": "Introducir la contraseña",
  "login_btn_forgot_password": "¿Se te olvidó tu contraseña",
  "login_btn_sign_in": "Registrarse",
  "login_error_fill_fields": "Por favor complete todos los campos e",
  "login_end": "------------------------------------------------------------------------------------",

  "home_start": "Below are list of strings for home",
  "home_tv_posts": "Publicaciones",
  "home_tv_error": "Error",
  "home_tv_no_post_found": "No se han encontrado publicaciones",
  "home_tv_choose_language": "Elige lengua",
  "home_tv_settings": "Ajustes",
  "home_tv_about": "Acerca de",
  "home_end": "-------------------------------------------------------------------------------------",

  "settings_start": "Below are list of strings for settings es",
  "settings_et_app_name": "Boilerplate",
  "settings_et_about_description": "Un boilerplate de Flutter que muestra arquitectura en capas, MobX e inyección de dependencias.",
  "settings_btn_close": "Cerrar",
  "settings_tv_loading": "Cargando…",
  "settings_tv_theme": "Tema",
  "settings_tv_theme_dark": "Oscuro",
  "settings_tv_theme_light": "Claro",
  "settings_tv_error_loading_info": "No se pudo cargar la información del dispositivo.",
  "settings_end": "-------------------------------------------------------------------------------------"
}
```

- [ ] **Step 3: Add keys to `assets/lang/da.json`**

Replace the file contents with:

```json
{
  "login_start": "Below are list of strings for login da ",
  "login_et_user_email": "Brugernavn",
  "login_et_user_password": "Adgangskode",
  "login_btn_forgot_password": "Glemt adgangskode?",
  "login_btn_sign_in": "Log ind",
  "login_error_fill_fields": "Udfyld venligst alle felterne",
  "login_end": "------------------------------------------------------------------------------------",

  "home_start": "Below are list of strings for home",
  "home_tv_posts": "Indlæg",
  "home_tv_error": "Fejl",
  "home_tv_no_post_found": "Ingen indlæg fundet",
  "home_tv_choose_language": "Vælg sprog",
  "home_tv_settings": "Indstillinger",
  "home_tv_about": "Om",
  "home_end": "-------------------------------------------------------------------------------------",

  "settings_start": "Below are list of strings for settings da",
  "settings_et_app_name": "Boilerplate",
  "settings_et_about_description": "En Flutter-skabelon der demonstrerer lagdelt arkitektur, MobX og dependency injection.",
  "settings_btn_close": "Luk",
  "settings_tv_loading": "Indlæser…",
  "settings_tv_theme": "Tema",
  "settings_tv_theme_dark": "Mørk",
  "settings_tv_theme_light": "Lys",
  "settings_tv_error_loading_info": "Kunne ikke indlæse enhedsoplysninger.",
  "settings_end": "-------------------------------------------------------------------------------------"
}
```

- [ ] **Step 4: Validate JSON**

Run: `python3 -c "import json; [json.load(open(p)) for p in ['assets/lang/en.json','assets/lang/es.json','assets/lang/da.json']]; print('ok')"`
Expected: `ok`

- [ ] **Step 5: Commit**

```bash
git add assets/lang/en.json assets/lang/es.json assets/lang/da.json
git commit -m "i18n: add settings and about keys"
```

---

## Task 3: Write failing test for `SettingsStore`

**Files:**
- Create: `test/presentation/settings/store/settings_store_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/presentation/settings/store/settings_store_test.dart` with the following content. The test injects fake `PackageInfo` and `DeviceInfoPlugin` shims via the store's constructor parameters (this is the seam the store exposes for testing without platform channels).

```dart
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  group('SettingsStore', () {
    test('initial state has null info, not loading, no error', () {
      final store = SettingsStore.withSources(
        packageInfoLoader: () async => _packageInfo('Boilerplate', '1.0.0', '1'),
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      expect(store.aboutInfo, isNull);
      expect(store.loading, isFalse);
      expect(store.errorMessage, isNull);
    });

    test('loadAboutInfo populates aboutInfo from injected sources', () async {
      final store = SettingsStore.withSources(
        packageInfoLoader: () async => _packageInfo('Boilerplate', '1.0.0', '1'),
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      await store.loadAboutInfo();

      expect(store.loading, isFalse);
      expect(store.errorMessage, isNull);
      expect(store.aboutInfo, isNotNull);
      expect(store.aboutInfo, contains('Boilerplate'));
      expect(store.aboutInfo, contains('1.0.0'));
      expect(store.aboutInfo, contains('Pixel 6'));
      expect(store.aboutInfo, contains('Android 14'));
    });

    test('loadAboutInfo is idempotent', () async {
      var packageInfoCalls = 0;
      final store = SettingsStore.withSources(
        packageInfoLoader: () async {
          packageInfoCalls += 1;
          return _packageInfo('Boilerplate', '1.0.0', '1');
        },
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      await store.loadAboutInfo();
      await store.loadAboutInfo();
      await store.loadAboutInfo();

      expect(packageInfoCalls, 1);
    });

    test('loadAboutInfo records error when package info throws', () async {
      final store = SettingsStore.withSources(
        packageInfoLoader: () async => throw Exception('platform boom'),
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      await store.loadAboutInfo();

      expect(store.loading, isFalse);
      expect(store.aboutInfo, isNull);
      expect(store.errorMessage, isNotNull);
    });
  });
}

PackageInfo _packageInfo(String appName, String version, String build) {
  return PackageInfo(
    appName: appName,
    packageName: 'com.example.boilerplate',
    version: version,
    buildNumber: build,
    buildSignature: '',
  );
}

AndroidDeviceInfo _androidDeviceInfo(String model, String osVersion) {
  return AndroidDeviceInfo(
    id: 'id',
    host: 'host',
    brand: 'google',
    model: model,
    device: 'device',
    product: 'product',
    hardware: 'hardware',
    display: 'display',
    fingerprint: 'fingerprint',
    manufacturer: 'Google',
    name: 'name',
    isPhysicalDevice: true,
    version: _androidSdkInt(osVersion),
    type: 'type',
    tags: 'tags',
    supported32BitAbis: const [],
    supported64BitAbis: const [],
    supportedAbis: const [],
    systemFeatures: const [],
    serialNumber: 'serial',
    isLowRamDevice: false,
    freezingThreshold: 0,
    manufacturerExt: 'manufacturerExt',
    modelExt: 'modelExt',
    progressBarEndColor: 0,
    progressBarStartColor: 0,
  );
}

AndroidBuildVersion _androidSdkInt(String release) {
  return AndroidBuildVersion(
    baseOS: '',
    codename: '',
    incremental: '',
    previewSdkInt: 0,
    release: release,
    sdkInt: 34,
    securityPatch: '',
  );
}
```

Note: The exact field set of `AndroidDeviceInfo` and `AndroidBuildVersion` may have changed in newer `device_info_plus` versions. If the test fails to compile on a field mismatch, drop the fields that don't exist and keep the ones that do (`id`, `version.release`, `model`, `manufacturer` are sufficient for the test). The plan's intent is to verify that `SettingsStore.loadAboutInfo` calls both injectables, populates `_aboutInfo`, and surfaces errors.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/presentation/settings/store/settings_store_test.dart`
Expected: FAIL with "Target of URI doesn't exist: 'package:boilerplate/presentation/settings/store/settings_store.dart'"

- [ ] **Step 3: Commit the failing test**

```bash
git add test/presentation/settings/store/settings_store_test.dart
git commit -m "test(settings): add failing tests for SettingsStore"
```

---

## Task 4: Implement `SettingsStore`

**Files:**
- Create: `lib/presentation/settings/store/settings_store.dart`

- [ ] **Step 1: Write the store**

Create `lib/presentation/settings/store/settings_store.dart`:

```dart
// ignore_for_file: library_private_types_in_public_api

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_store.g.dart';

typedef PackageInfoLoader = Future<PackageInfo> Function();
typedef DeviceInfoLoader = Future<BaseDeviceInfo> Function();

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore with Store {
  // Injectable loaders. Defaults call the platform plugins directly.
  final PackageInfoLoader _packageInfoLoader;
  final DeviceInfoLoader _deviceInfoLoader;

  // constructor:---------------------------------------------------------------
  _SettingsStore()
      : _packageInfoLoader = PackageInfo.fromPlatform,
        _deviceInfoLoader = DeviceInfoPlugin().deviceInfo;

  _SettingsStore.withSources({
    required PackageInfoLoader packageInfoLoader,
    required DeviceInfoLoader deviceInfoLoader,
  })  : _packageInfoLoader = packageInfoLoader,
        _deviceInfoLoader = deviceInfoLoader;

  // store variables:-----------------------------------------------------------
  @observable
  String? _aboutInfo;

  @observable
  bool _loading = false;

  @observable
  String? _errorMessage;

  // getters:-------------------------------------------------------------------
  String? get aboutInfo => _aboutInfo;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> loadAboutInfo() async {
    if (_aboutInfo != null) return;
    _loading = true;
    _errorMessage = null;
    try {
      final packageInfo = await _packageInfoLoader();
      final deviceInfo = await _deviceInfoLoader();

      final buffer = StringBuffer()
        ..writeln('App: ${packageInfo.appName} ${packageInfo.version}+${packageInfo.buildNumber}')
        ..writeln('Package: ${packageInfo.packageName}');

      if (deviceInfo is AndroidDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.manufacturer} ${deviceInfo.model}')
          ..writeln('Android: ${deviceInfo.version.release} (SDK ${deviceInfo.version.sdkInt})');
      } else if (deviceInfo is IosDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.name} (${deviceInfo.model})')
          ..writeln('iOS: ${deviceInfo.systemVersion}');
      } else if (deviceInfo is LinuxDeviceInfo) {
        buffer.writeln('Device: ${deviceInfo.name} ${deviceInfo.version}');
      } else if (deviceInfo is MacOsDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.model}')
          ..writeln('macOS: ${deviceInfo.osRelease}');
      } else if (deviceInfo is WindowsDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.computerName}')
          ..writeln('Windows: ${deviceInfo.majorVersion}.${deviceInfo.minorVersion}');
      } else if (deviceInfo is WebBrowserInfo) {
        buffer
          ..writeln('Browser: ${deviceInfo.browserName} ${deviceInfo.appVersion}')
          ..writeln('Platform: ${deviceInfo.platform}');
      } else {
        buffer.writeln('Device info unavailable on this platform.');
      }

      _aboutInfo = buffer.toString().trimRight();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false;
    }
  }
}
```

- [ ] **Step 2: Run code generation**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`
Expected: a new `settings_store.g.dart` is generated next to the source.

- [ ] **Step 3: Run the test to verify it passes**

Run: `flutter test test/presentation/settings/store/settings_store_test.dart`
Expected: PASS (4 passing).

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/settings/store/settings_store.dart lib/presentation/settings/store/settings_store.g.dart
git commit -m "feat(settings): add SettingsStore"
```

---

## Task 5: Register `SettingsStore` in the DI module

**Files:**
- Modify: `lib/presentation/di/module/store_module.dart`

- [ ] **Step 1: Add the import and registration**

In `lib/presentation/di/module/store_module.dart`:

After line 13 (the existing post import), add:

```dart
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
```

Before the final `}` of `configureStoreModuleInjection` (after the `LanguageStore` registration block ending at line 56), add:

```dart
    getIt.registerSingleton<SettingsStore>(SettingsStore());
```

- [ ] **Step 2: Run existing DI tests**

Run: `flutter test test/di/store_module_test.dart`
Expected: PASS — `SettingsStore` is a singleton like `ThemeStore` and `LanguageStore`, so existing assertions still hold.

- [ ] **Step 3: Update the DI test to assert `SettingsStore` is a singleton**

Modify `test/di/store_module_test.dart`. After the `UserStore` assertion (line 61-62), add a new assertion:

```dart
    expect(identical(getIt<SettingsStore>(), getIt<SettingsStore>()), isTrue);
```

And after the import block, add the new store import:

```dart
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
```

- [ ] **Step 4: Run the updated DI test**

Run: `flutter test test/di/store_module_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/di/module/store_module.dart test/di/store_module_test.dart
git commit -m "feat(settings): register SettingsStore in DI module"
```

---

## Task 6: Extract `showLanguageDialog` helper from `home.dart`

**Files:**
- Modify: `lib/presentation/home/home.dart:78-142`

- [ ] **Step 1: Add the top-level helper above the `_HomeScreenState` class**

In `lib/presentation/home/home.dart`, replace lines 78-142 (the entire `_buildLanguageButton` and `_buildLanguageDialog` plus `_showDialog`) with the refactored versions.

The new file content for that range (replace the existing block from line 78 to the end of the file at line 143, with `_showDialog` removed entirely):

```dart
  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        showLanguageDialog(
          context: context,
          themeStore: _themeStore,
          languageStore: _languageStore,
        );
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }
}

// Top-level helpers:----------------------------------------------------------

void showLanguageDialog({
  required BuildContext context,
  required ThemeStore themeStore,
  required LanguageStore languageStore,
}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate('home_tv_choose_language'),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: languageStore.supportedLanguages
          .map(
            (object) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.all(0.0),
              title: Text(
                object.language,
                style: TextStyle(
                  color: languageStore.locale == object.locale
                      ? Theme.of(context).primaryColor
                      : themeStore.darkMode
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                languageStore.changeLanguage(object.locale);
              },
            ),
          )
          .toList(),
    ),
  );
}
```

Note: the file already imports `theme_store.dart` and `language_store.dart` (lines 4-5), so no new imports are required.

- [ ] **Step 2: Run `flutter analyze` on `home.dart`**

Run: `flutter analyze lib/presentation/home/home.dart`
Expected: no NEW errors. (The pre-existing errors in `lib/data/network/...` are unrelated and out of scope.)

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/home/home.dart
git commit -m "refactor(home): extract showLanguageDialog top-level helper"
```

---

## Task 7: Add the settings `IconButton` to the home app bar

**Files:**
- Modify: `lib/presentation/home/home.dart:42-48`

- [ ] **Step 1: Insert a settings button between theme and logout**

In `_buildActions` (line 42-48), replace the current method body:

```dart
  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
      _buildThemeButton(),
      _buildSettingsButton(),
      _buildLogoutButton(),
    ];
  }
```

After the `_buildLogoutButton` method (after line 76), add:

```dart
  Widget _buildSettingsButton() {
    return IconButton(
      onPressed: () {
        showSettingsDialog(
          context: context,
          themeStore: _themeStore,
          languageStore: _languageStore,
          settingsStore: getIt<SettingsStore>(),
        );
      },
      icon: Icon(
        Icons.settings,
      ),
    );
  }
```

Add the import at the top of the file (next to the other `presentation/` imports):

```dart
import 'package:boilerplate/presentation/settings/settings_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
```

- [ ] **Step 2: Run `flutter analyze`**

Run: `flutter analyze lib/presentation/home/home.dart`
Expected: errors about `showSettingsDialog` not existing yet (Task 8 is next). That's the expected failure mode for this step.

- [ ] **Step 3: Commit the partial work**

```bash
git add lib/presentation/home/home.dart
git commit -m "feat(home): wire settings button (calls into not-yet-defined dialog)"
```

---

## Task 8: Write failing widget test for `SettingsDialog`

**Files:**
- Create: `test/presentation/settings/settings_dialog_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/presentation/settings/settings_dialog_test.dart`:

```dart
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/usecase/post/get_post_usecase.dart';
import 'package:boilerplate/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/save_login_in_status_usecase.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';
import 'package:boilerplate/domain/entity/post/post.dart';
import 'package:boilerplate/domain/entity/user/user.dart';
import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/presentation/di/module/store_module.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/settings/settings_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    locale: const Locale('en'),
    home: Builder(
      builder: (context) => Scaffold(body: Center(child: child)),
    ),
  );
}

class _FakeSettingRepository implements SettingRepository {
  @override
  bool get isDarkMode => false;
  @override
  String? get currentLanguage => 'en';
  @override
  Future<void> changeBrightnessToDark(bool value) async {}
  @override
  Future<void> changeLanguage(String value) async {}
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<User?> login(LoginParams params) async => null;
  @override
  Future<void> saveIsLoggedIn(bool value) async {}
  @override
  Future<bool> get isLoggedIn async => false;
}

class _FakePostRepository implements PostRepository {
  @override
  Future<PostList> getPosts() async => PostList(posts: []);
  @override
  Future<List<Post>> findPostById(int id) async => [];
  @override
  Future<int> insert(Post post) async => 0;
  @override
  Future<int> update(Post post) async => 0;
  @override
  Future<int> delete(Post post) async => 0;
}

Future<void> _setUpGetIt({bool darkMode = false}) async {
  await getIt.reset();

  getIt.registerSingleton<SettingRepository>(_FakeSettingRepository());
  getIt.registerSingleton<UserRepository>(_FakeUserRepository());
  getIt.registerSingleton<PostRepository>(_FakePostRepository());
  getIt.registerSingleton<GetPostUseCase>(GetPostUseCase(getIt<PostRepository>()));
  getIt.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase(getIt<UserRepository>()));
  getIt.registerSingleton<SaveLoginStatusUseCase>(
    SaveLoginStatusUseCase(getIt<UserRepository>()),
  );
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<UserRepository>()));

  await StoreModule.configureStoreModuleInjection();

  if (darkMode) {
    await getIt<ThemeStore>().changeBrightnessToDark(true);
  }
}

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders all three rows with default values', (tester) async {
    await _setUpGetIt();

    await tester.pumpWidget(_wrap(SettingsDialog(
      themeStore: getIt<ThemeStore>(),
      languageStore: getIt<LanguageStore>(),
      settingsStore: getIt<SettingsStore>(),
    )));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('theme row toggles ThemeStore', (tester) async {
    await _setUpGetIt();
    final themeStore = getIt<ThemeStore>();
    expect(themeStore.darkMode, isFalse);

    await tester.pumpWidget(_wrap(SettingsDialog(
      themeStore: themeStore,
      languageStore: getIt<LanguageStore>(),
      settingsStore: getIt<SettingsStore>(),
    )));
    await tester.pumpAndSettle();

    // The theme row is the ListTile whose title is "Theme".
    final themeRow = find.widgetWithText(ListTile, 'Theme');
    expect(themeRow, findsOneWidget);
    await tester.tap(themeRow);
    await tester.pumpAndSettle();

    expect(themeStore.darkMode, isTrue);
    expect(find.text('Dark'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/presentation/settings/settings_dialog_test.dart`
Expected: FAIL with "Target of URI doesn't exist: 'package:boilerplate/presentation/settings/settings_dialog.dart'"

- [ ] **Step 3: Commit the failing test**

```bash
git add test/presentation/settings/settings_dialog_test.dart
git commit -m "test(settings): add failing SettingsDialog widget tests"
```

---

## Task 9: Implement `SettingsDialog`

**Files:**
- Create: `lib/presentation/settings/settings_dialog.dart`

- [ ] **Step 1: Implement the dialog**

Create `lib/presentation/settings/settings_dialog.dart`:

```dart
import 'package:boilerplate/presentation/home/home.dart' show showLanguageDialog;
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/settings/about_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SettingsDialog extends StatelessWidget {
  final ThemeStore themeStore;
  final LanguageStore languageStore;
  final SettingsStore settingsStore;

  const SettingsDialog({
    super.key,
    required this.themeStore,
    required this.languageStore,
    required this.settingsStore,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('home_tv_settings')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLanguageRow(context),
          const Divider(height: 0),
          _buildThemeRow(context),
          const Divider(height: 0),
          _buildAboutRow(context),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).translate('settings_btn_close')),
        ),
      ],
    );
  }

  Widget _buildLanguageRow(BuildContext context) {
    return Observer(
      builder: (_) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.language),
        title: Text(AppLocalizations.of(context).translate('home_tv_choose_language')),
        subtitle: Text(languageStore.getLanguage() ?? languageStore.locale),
        onTap: () {
          Navigator.of(context).pop();
          showLanguageDialog(
            context: context,
            themeStore: themeStore,
            languageStore: languageStore,
          );
        },
      ),
    );
  }

  Widget _buildThemeRow(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Observer(
      builder: (_) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.brightness_6),
        title: Text(localizations.translate('settings_tv_theme')),
        subtitle: Text(
          themeStore.darkMode
              ? localizations.translate('settings_tv_theme_dark')
              : localizations.translate('settings_tv_theme_light'),
        ),
        onTap: () {
          themeStore.changeBrightnessToDark(!themeStore.darkMode);
        },
      ),
    );
  }

  Widget _buildAboutRow(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.info_outline),
      title: Text(AppLocalizations.of(context).translate('home_tv_about')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).pop();
        showAboutDialog(
          context: context,
          settingsStore: settingsStore,
        );
      },
    );
  }
}

Future<void> showSettingsDialog({
  required BuildContext context,
  required ThemeStore themeStore,
  required LanguageStore languageStore,
  required SettingsStore settingsStore,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => SettingsDialog(
      themeStore: themeStore,
      languageStore: languageStore,
      settingsStore: settingsStore,
    ),
  );
}
```

- [ ] **Step 2: Run the dialog test**

Run: `flutter test test/presentation/settings/settings_dialog_test.dart`
Expected: PASS.

If the test fails because `AboutDialog` is not yet defined (`showAboutDialog` reference is unresolved), that's expected — Task 10 creates it. In that case, temporarily comment out `_buildAboutRow` and the body of `_buildAboutRow` reference, run the tests (the row count assertion will fail), then restore the row and proceed to Task 10.

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/settings/settings_dialog.dart
git commit -m "feat(settings): add SettingsDialog"
```

---

## Task 10: Write failing widget test for `AboutDialog`

**Files:**
- Create: `test/presentation/settings/about_dialog_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/presentation/settings/about_dialog_test.dart`:

```dart
import 'package:boilerplate/presentation/settings/about_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    locale: const Locale('en'),
    home: Builder(
      builder: (context) => Scaffold(body: Center(child: child)),
    ),
  );
}

SettingsStore _storeWith({required String? info, required String? error, required bool loading}) {
  final store = SettingsStore.withSources(
    packageInfoLoader: () async => throw StateError('not used in this test'),
    deviceInfoLoader: () async => throw StateError('not used in this test'),
  );
  // Force the store into a known state by mutating observables directly via a
  // public method, then load. Simpler: drive it through loadAboutInfo by
  // installing injectables that resolve the values we want.
  return store;
}

SettingsStore _resolvedStore() {
  return SettingsStore.withSources(
    packageInfoLoader: () async {
      throw StateError('not used');
    },
    deviceInfoLoader: () async {
      throw StateError('not used');
    },
  );
}

void main() {
  testWidgets('renders loading then info after loadAboutInfo resolves',
      (tester) async {
    final store = SettingsStore.withSources(
      packageInfoLoader: () async {
        // Yield a microtask so the UI can render the loading state first.
        await Future<void>.delayed(Duration.zero);
        return _packageInfo();
      },
      deviceInfoLoader: () async {
        await Future<void>.delayed(Duration.zero);
        return _androidDeviceInfo();
      },
    );

    await tester.pumpWidget(_wrap(AboutDialog(settingsStore: store)));
    // Trigger load.
    unawaited(store.loadAboutInfo());
    // Loading state.
    await tester.pump();
    expect(find.text('Loading…'), findsOneWidget);
    // After both futures resolve, info renders.
    await tester.pumpAndSettle();
    expect(find.text('Loading…'), findsNothing);
    expect(find.textContaining('Boilerplate'), findsOneWidget);
    expect(find.textContaining('Pixel 6'), findsOneWidget);
  });

  testWidgets('renders error text when loadAboutInfo throws', (tester) async {
    final store = SettingsStore.withSources(
      packageInfoLoader: () async => throw Exception('platform boom'),
      deviceInfoLoader: () async => _androidDeviceInfo(),
    );

    await tester.pumpWidget(_wrap(AboutDialog(settingsStore: store)));
    unawaited(store.loadAboutInfo());
    await tester.pumpAndSettle();

    expect(find.text('Unable to load device info.'), findsOneWidget);
  });
}

// Inline imports to keep the test file self-contained, with stubbed
// AndroidDeviceInfo matching the structure used in
// test/presentation/settings/store/settings_store_test.dart.

PackageInfo _packageInfo() {
  return PackageInfo(
    appName: 'Boilerplate',
    packageName: 'com.example.boilerplate',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );
}

AndroidDeviceInfo _androidDeviceInfo() {
  return AndroidDeviceInfo(
    id: 'id',
    host: 'host',
    brand: 'google',
    model: 'Pixel 6',
    device: 'device',
    product: 'product',
    hardware: 'hardware',
    display: 'display',
    fingerprint: 'fingerprint',
    manufacturer: 'Google',
    name: 'name',
    isPhysicalDevice: true,
    version: AndroidBuildVersion(
      baseOS: '',
      codename: '',
      incremental: '',
      previewSdkInt: 0,
      release: '14',
      sdkInt: 34,
      securityPatch: '',
    ),
    type: 'type',
    tags: 'tags',
    supported32BitAbis: const [],
    supported64BitAbis: const [],
    supportedAbis: const [],
    systemFeatures: const [],
    serialNumber: 'serial',
    isLowRamDevice: false,
    freezingThreshold: 0,
    manufacturerExt: 'manufacturerExt',
    modelExt: 'modelExt',
    progressBarEndColor: 0,
    progressBarStartColor: 0,
  );
}

void unawaited(Future<void> future) {}
```

(If `unawaited` is already in `dart:async`, replace the inline stub with `import 'dart:async';` and use the existing one.)

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/presentation/settings/about_dialog_test.dart`
Expected: FAIL with "Target of URI doesn't exist: 'package:boilerplate/presentation/settings/about_dialog.dart'"

- [ ] **Step 3: Commit the failing test**

```bash
git add test/presentation/settings/about_dialog_test.dart
git commit -m "test(settings): add failing AboutDialog widget tests"
```

---

## Task 11: Implement `AboutDialog`

**Files:**
- Create: `lib/presentation/settings/about_dialog.dart`

- [ ] **Step 1: Implement the dialog**

Create `lib/presentation/settings/about_dialog.dart`:

```dart
import 'package:boilerplate/core/widgets/app_icon_widget.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AboutDialog extends StatelessWidget {
  final SettingsStore settingsStore;

  const AboutDialog({
    super.key,
    required this.settingsStore,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Kick off the load lazily; the store is idempotent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settingsStore.loadAboutInfo();
    });

    return AlertDialog(
      title: Text(localizations.translate('home_tv_about')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(child: AppIconWidget(image: 'assets/icons/ic_launcher.png')),
            const SizedBox(height: 16),
            Center(
              child: Text(
                localizations.translate('settings_et_app_name'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(localizations.translate('settings_et_about_description')),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Observer(
              builder: (_) {
                if (settingsStore.loading) {
                  return Text(localizations.translate('settings_tv_loading'));
                }
                if (settingsStore.errorMessage != null) {
                  return Text(localizations.translate('settings_tv_error_loading_info'));
                }
                return Text(settingsStore.aboutInfo ?? '');
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.translate('settings_btn_close')),
        ),
      ],
    );
  }
}

Future<void> showAboutDialog({
  required BuildContext context,
  required SettingsStore settingsStore,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => AboutDialog(settingsStore: settingsStore),
  );
}
```

- [ ] **Step 2: Run both settings widget tests**

Run: `flutter test test/presentation/settings/`
Expected: PASS for both `settings_dialog_test.dart` and `about_dialog_test.dart`.

- [ ] **Step 3: Run `flutter analyze`**

Run: `flutter analyze`
Expected: no NEW errors. (Pre-existing errors in `lib/data/network/...` are out of scope.)

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/settings/about_dialog.dart
git commit -m "feat(settings): add AboutDialog with app + device info"
```

---

## Task 12: Run the full test suite and final analyze

**Files:** none modified

- [ ] **Step 1: Run all tests**

Run: `flutter test`
Expected: all tests pass.

- [ ] **Step 2: Run analyzer**

Run: `flutter analyze`
Expected: same pre-existing errors as before this plan started, no new ones.

- [ ] **Step 3: Manual smoke (optional, requires a connected device or emulator)**

Run: `flutter run` and verify:
1. Home screen renders normally.
2. A new `Icons.settings` button appears between the theme and logout buttons.
3. Tapping it opens the settings dialog with three rows: Language, Theme, About.
4. Tapping Theme flips dark/light immediately and the subtitle updates.
5. Tapping Language opens the existing language dialog.
6. Tapping About opens the About dialog. The "Loading…" text appears briefly, then the app name, version, and device info appear.

- [ ] **Step 4: Final commit if any straggler files were missed**

```bash
git status
# If anything is unstaged, add and commit it with a descriptive message.
```

---

## Self-Review

Spec coverage:

| Spec section | Task(s) |
|--------------|---------|
| Add `package_info_plus` and `device_info_plus` | Task 1 |
| New `lib/presentation/settings/` feature folder | Tasks 3-11 |
| `SettingsStore` MobX with idempotent `loadAboutInfo` | Tasks 3, 4 |
| `SettingsDialog` with 3 rows + Close | Tasks 8, 9 |
| `AboutDialog` with app + device info | Tasks 10, 11 |
| App-bar settings `IconButton` | Task 7 |
| Reuse existing language dialog (extract `showLanguageDialog`) | Task 6 |
| Localize new keys in en/es/da | Task 2 |
| Register `SettingsStore` in DI module | Task 5 |
| Widget tests | Tasks 3, 8, 10 |

Placeholder scan: every code block contains concrete code; no "TBD", "TODO", or "implement later" markers.

Type/method consistency:
- `SettingsStore` API: `aboutInfo`, `loading`, `errorMessage`, `loadAboutInfo()`. Used identically in Tasks 4, 5, 8, 9, 10, 11.
- `SettingsDialog` constructor: `themeStore`, `languageStore`, `settingsStore` (positional, required). Used identically in Tasks 7, 8, 9.
- `AboutDialog` constructor: `settingsStore`. Used identically in Tasks 9, 10, 11.
- `showSettingsDialog` helper signature matches the call site in Task 7.
- `showLanguageDialog` helper signature matches the call site in Task 6 and the call site in `SettingsDialog` (Task 9).

All checks pass. Plan is ready for execution.
