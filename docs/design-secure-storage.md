# Secure Storage Integration Design

Date: 2026-06-04
Approach: Split Storage (A)

## Goal

Store the auth token in encrypted platform-native storage (Keychain/Keystore) instead of plaintext `SharedPreferences`, using `flutter_secure_storage`. Non-sensitive preferences (theme, language, login state) remain in `SharedPreferences`.

## Background

`SharedPreferenceHelper` currently stores `authToken` as a plain string. SharedPreferences is not encrypted on any platform — the token is readable on a rooted/emulator device. The auth token is the only truly sensitive value in the preferences store.

## Architecture

```
lib/data/
├── secure_storage/                          # NEW
│   ├── secure_storage_helper.dart           # wraps flutter_secure_storage
│   └── constants/
│       └── secure_storage_constants.dart    # key constants
└── sharedpref/
    ├── shared_preference_helper.dart         # UNCHANGED
    └── ...
```

`SharedPreferenceHelper` stays unchanged and continues managing `isLoggedIn`, `isDarkMode`, `currentLanguage`.

`SecureStorageHelper` manages only `authToken`.

## Components

### 1. `pubspec.yaml`
Add dependency:
```yaml
flutter_secure_storage: ^9.0.0
```

### 2. `lib/data/secure_storage/constants/secure_storage_constants.dart` (NEW)
```dart
class SecureStorageKeys {
  SecureStorageKeys._();
  static const String authToken = 'auth_token';
}
```

### 3. `lib/data/secure_storage/secure_storage_helper.dart` (NEW)
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants/secure_storage_constants.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _secureStorage;

  SecureStorageHelper(this._secureStorage);

  Future<String?> get authToken async {
    return _secureStorage.read(key: SecureStorageKeys.authToken);
  }

  Future<bool> saveAuthToken(String token) async {
    await _secureStorage.write(key: SecureStorageKeys.authToken, value: token);
    return true;
  }

  Future<bool> removeAuthToken() async {
    await _secureStorage.delete(key: SecureStorageKeys.authToken);
    return true;
  }
}
```

### 4. `lib/data/di/module/local_module.dart` (MODIFY)
Add registration:
```dart
getIt.registerSingleton<FlutterSecureStorage>(
  const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  ),
);
getIt.registerSingleton<SecureStorageHelper>(
  SecureStorageHelper(getIt<FlutterSecureStorage>()),
);
```

Note: `FlutterSecureStorage` does not require async init — no `registerSingletonAsync` needed.

### 5. `lib/data/repository/user/user_repository_impl.dart` (MODIFY)
Replace `_sharedPrefsHelper.authToken` calls with `_secureStorageHelper`:
- `login()` → `_secureStorageHelper.saveAuthToken(token)`
- `logout()` → `_secureStorageHelper.removeAuthToken()`

### 6. `lib/data/di/module/network_module.dart` (MODIFY)
Update `AuthInterceptor` registration:
```dart
getIt.registerSingleton<AuthInterceptor>(
  AuthInterceptor(
    accessToken: () async =>
        await getIt<SecureStorageHelper>().authToken,
  ),
);
```

## Data Flow

| Operation | Before | After |
|---|---|---|
| Login save token | `SharedPreferenceHelper.saveAuthToken` | `SecureStorageHelper.saveAuthToken` |
| Logout remove token | `SharedPreferenceHelper.removeAuthToken` | `SecureStorageHelper.removeAuthToken` |
| Read token for API | `SharedPreferenceHelper.authToken` | `SecureStorageHelper.authToken` |
| AuthInterceptor | Reads from `SharedPreferenceHelper` | Reads from `SecureStorageHelper` |

## Platform Behaviour

| Platform | Storage Backend |
|---|---|
| iOS | Keychain (via `flutter_secure_storage`) |
| Android | EncryptedSharedPreferences (API 23+) or KeyStore |
| Web | localStorage (session-scoped, browser-encrypted) |

## Dependency Order

`LocalModule.configureLocalModuleInjection()` registers `FlutterSecureStorage` → `SecureStorageHelper` synchronously. `SharedPreferences` still registers async but they are independent — no ordering constraint between them.

## Testing Notes

`SecureStorageHelper` can be mocked in unit tests the same way `SharedPreferenceHelper` is mocked — inject a fake in tests.

## Scope Boundaries

- `SharedPreferenceHelper` — unchanged
- `SharedPreferences` dependency — stays (used for non-sensitive prefs)
- No changes to domain entities, use cases, or stores