# This branch is still under development


# Boilerplate Project

A boilerplate project created in flutter using MobX and Provider. Boilerplate supports both web and mobile, clone the appropriate branches mentioned below:

* For Mobile: https://github.com/zubairehman/flutter-boilerplate-project/tree/master (stable channel)
* For Web: https://github.com/zubairehman/flutter-boilerplate-project/tree/feature/web-support (beta channel)

## Getting Started

The Boilerplate contains the minimal implementation required to create a new library or project. The repository code is preloaded with some basic components like basic app architecture, app theme, constants and required dependencies to create a new project. By using boiler plate code as standard initializer, we can have same patterns in all the projects that will inherit it. This will also help in reducing setup & development time by allowing you to use same code pattern and avoid re-writing from scratch.

## How to Use 

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/zubairehman/flutter-boilerplate-project.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

## Boilerplate Features:

* Splash
* Animation helpers
* Login
* Home
* Routing
* Theme
* Dio
* Database
* Platform-specific local database path resolution
* MobX (to connect the reactive data of your application with the UI)
* Provider (State Management)
* Encryption
* Secure storage (auth token encryption)
* Validation
* JWT utility example
* Code Generation
* User Notifications
* Logging
* Dependency Injection
* Dark Theme Support (new)
* Multilingual Support (new)
* Provider example (new)
* Device Information (device_info_plus)

### Up-Coming Features:

* Connectivity Support (connectivity_plus)
* Background Fetch Support

### Libraries & Tools Used

* [Dio](https://github.com/flutterchina/dio)
* [Database](https://github.com/tekartik/sembast.dart)
* [MobX](https://github.com/mobxjs/mobx.dart) (to connect the reactive data of your application with the UI)
* [Provider](https://github.com/rrousselGit/provider) (State Management)
* [Encryption](https://github.com/xxtea/xxtea-dart)
* [Crypto](https://pub.dev/packages/crypto)
* [Validation](https://github.com/dart-league/validators)
* [Logging](https://github.com/zubairehman/Flogs)
* [Notifications](https://github.com/AndreHaueisen/flushbar)
* [Flutter Animate](https://pub.dev/packages/flutter_animate)
* [Json Serialization](https://github.com/dart-lang/json_serializable)
* [Dart JSON Web Token](https://pub.dev/packages/dart_jsonwebtoken)
* [Path Provider](https://pub.dev/packages/path_provider)
* [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
* [Device Info Plus](https://pub.dev/packages/device_info_plus)
* [Dependency Injection](https://github.com/fluttercommunity/get_it)
* [Connectivity Plus](https://pub.dev/packages/connectivity_plus)
* [Device Info Plus](https://pub.dev/packages/device_info_plus) (cross-platform device information)

### Device Information Integration

The project uses `device_info_plus` to provide device and operating system information. `DeviceInfoService` wraps the plugin and provides a simplified interface for common device properties.

**Service location:** `lib/data/device_info/device_info_service.dart`

**Registration:** Registered as a singleton in `LocalModule.configureLocalModuleInjection()`.

**Usage:**

```dart
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/data/device_info/device_info_service.dart';

final deviceInfo = getIt<DeviceInfoService>();

// Get full device info
final info = await deviceInfo.deviceInfo;

// Get human-readable device name
final name = await deviceInfo.deviceName; // e.g., "Samsung Galaxy S21"

// Get operating system
final os = await deviceInfo.operatingSystem; // e.g., "Android 12"

// Get device identifier
final id = await deviceInfo.deviceId;
```

The service automatically handles platform detection and returns the appropriate info type (AndroidDeviceInfo, IosDeviceInfo, WebBrowserInfo, etc.) through a unified interface.

### Connectivity Integration

The project uses `connectivity_plus` to monitor network connectivity status. `ConnectivityService` wraps the plugin and provides a simplified interface for checking connection status and type.

**Service location:** `lib/data/connectivity/connectivity_service.dart`

**Registration:** Registered as a singleton in `LocalModule.configureLocalModuleInjection()`.

**Usage:**

```dart
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/data/connectivity/connectivity_service.dart';

final connectivity = getIt<ConnectivityService>();

// Check if connected
final isConnected = await connectivity.isConnected; // true/false

// Get connection type
final type = await connectivity.connectionType; // "WiFi", "Mobile", "Ethernet", etc.

// Get all connectivity results
final results = await connectivity.connectivityResults; // List<ConnectivityResult>

// Listen to connectivity changes
connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
  // Handle connectivity change
});
```

The service automatically handles multiple simultaneous connection types and provides a human-readable connection type string.

### Path Provider Integration

The project uses `path_provider` to resolve a safe local storage directory for
the native Sembast database. During data-layer dependency injection,
`LocalModule.configureLocalModuleInjection()` calls
`getApplicationDocumentsDirectory()` and passes that path to
`SembastClient.provideDatabase()`.

On native platforms, the database is stored under the application documents
directory. On web, the app uses Sembast's web database factory instead, so it
does not need a device file-system path.

### Crypto Service Integration

The project uses `crypto` package to provide cryptographic operations including
AES-256 encryption/decryption, SHA-256 hashing, and HMAC authentication.

**Service location:** `lib/core/data/local/crypto_service.dart`

**Registration:** Registered as a singleton in `LocalModule.configureLocalModuleInjection()`.

**Usage:**

```dart
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/core/data/local/crypto_service.dart';

final crypto = getIt<CryptoService>();

// Encrypt data
final encrypted = crypto.encrypt('sensitive data');

// Decrypt data
final decrypted = crypto.decrypt(encrypted);

// Compute HMAC
final hmac = crypto.computeHmac('message');

// Verify HMAC
final isValid = crypto.verifyHmac('message', hmac);

// SHA-256 hash
final hash = crypto.hashSha256('input');
```

**Security Note:** Change the default secret key in `LocalModule.configureLocalModuleInjection()`
to a production-appropriate value. The key should be stored securely (e.g., environment variable
or secure storage) rather than hardcoded.

### Encryption

The project uses `xxtea` package for database-level encryption via Sembast codec.
See `lib/core/data/local/encryption/xxtea.dart` for the XXTEA encryption implementation.

### Secure Storage Integration

The project uses `flutter_secure_storage` to store the auth token in encrypted
platform-native storage. Sensitive data (auth token) uses Keychain (iOS) or
EncryptedSharedPreferences (Android) instead of plain `SharedPreferences`.

`SecureStorageHelper` wraps `flutter_secure_storage` and is registered as a
singleton in `LocalModule`. `SharedPreferenceHelper` continues to manage
non-sensitive preferences (login state, theme, language) unchanged.

`AuthInterceptor` reads the token from `SecureStorageHelper` to inject it into
API requests. The token is never stored in plaintext.

### JWT Utility Example

The project includes a standalone JWT helper at `lib/utils/jwt/jwt_helper.dart`.
It is not wired into the login flow, shared preferences, or Dio interceptors.
Use it as a starting point when your app needs to sign, verify, or inspect JWT claims.

```dart
import 'package:boilerplate/utils/jwt/jwt_helper.dart';

const secret = 'replace-with-your-secret';

final token = JwtHelper.sign(
  {'userId': 42, 'role': 'tester'},
  secret: secret,
  issuer: 'boilerplate',
  audience: 'boilerplate-example',
  expiresIn: Duration(hours: 1),
);

final claims = JwtHelper.tryVerify(
  token,
  secret: secret,
  issuer: 'boilerplate',
  audience: 'boilerplate-example',
);

final decodedClaims = JwtHelper.tryDecode(token);
```

Use `tryVerify` for trusted claims. `tryDecode` does not verify the signature,
so only use it to inspect token contents.

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- constants/
|- data/
|- stores/
|- ui/
|- utils/
|- widgets/
|- main.dart
|- routes.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- constants - All the application level constants are defined in this directory with-in their respective files. This directory contains the constants for `theme`, `dimentions`, `api endpoints`, `preferences` and `strings`.
2- data - Contains the data layer of your project, includes directories for local, network and shared pref/cache.
3- stores - Contains store(s) for state-management of your application, to connect the reactive data of your application with the UI. 
4- ui — Contains all the ui of your project, contains sub directory for each screen.
5- util — Contains the utilities/common functions of your application.
6- widgets — Contains the common widgets for your applications. For example, Button, TextField etc.
7- routes.dart — This file contains all the routes for your application.
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```

### Constants

This directory contains all the application level constants. A separate file is created for each type as shown in example below:

```
constants/
|- app_theme.dart
|- dimens.dart
|- endpoints.dart
|- preferences.dart
|- strings.dart
```

### Data

All the business logic of your application will go into this directory, it represents the data layer of your application. It is sub-divided into three directories `local`, `network` and `sharedperf`, each containing the domain specific logic. Since each layer exists independently, that makes it easier to unit test. The communication between UI and data layer is handled by using central repository.

```
data/
|- local/
    |- constants/
    |- datasources/
    |- app_database.dart
   
|- network/
    |- constants/
    |- exceptions/
    |- rest_client.dart
    
|- sharedpref
    |- constants/
    |- shared_preference_helper.dart
    
|- repository.dart

```

### Stores

The store is where all your application state lives in flutter. The Store is basically a widget that stands at the top of the widget tree and passes it's data down using special methods. In-case of multiple stores, a separate folder for each store is created as shown in the example below:

```
stores/
|- login/
    |- login_store.dart
    |- form_validator.dart
```

### UI

This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen specific widgets will be placed in `widgets` directory as shown in the example below:

```
ui/
|- login
   |- login_screen.dart
   |- widgets
      |- login_form.dart
      |- login_button.dart
```

### Utils

Contains the common file(s) and utilities used in a project. The folder structure is as follows: 

```
utils/
|- encryption
   |- xxtea.dart
|- date
  |- date_time.dart
```

### Widgets

Contains the common widgets that are shared across multiple screens. For example, Button, TextField etc.

```
widgets/
|- app_icon_widget.dart
|- empty_app_bar.dart
|- progress_indicator.dart
```

### Routes

This file contains all the routes for your application.

```dart
import 'package:flutter/material.dart';

import 'ui/post/post_list.dart';
import 'ui/login/login.dart';
import 'ui/splash/splash.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/post';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
  };
}
```

### Main

This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

```dart
import 'package:boilerplate/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/app_theme.dart';
import 'constants/strings.dart';
import 'ui/splash/splash.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: themeData,
      routes: Routes.routes,
      home: SplashScreen(),
    );
  }
}
```

## Wiki

Checkout [wiki](https://github.com/zubairehman/flutter-boilerplate-project/wiki) for more info

## Conclusion

I will be happy to answer any questions that you may have on this approach, and if you want to lend a hand with the boilerplate then please feel free to submit an issue and/or pull request 🙂

Again to note, this is example can appear as over-architectured for what it is - but it is an example only. If you liked my work, don’t forget to ⭐ star the repo to show your support.
