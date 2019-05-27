# Boilerplate Project

A flutter boilerplate project created using MobX and Provider

## Getting Started

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
|- main.dart
|- routes.dart
|- ui/
|- util/
|- widgets/
|- data/
|- services/
```

Now, lets dive into the lib folder which has the main code for the application.

1- screens — Contains the screens of your application. All files from here get imported into routes.dart.
2- util — Contains the utilities/common functions of your application.
3- widgets — Contains the common widgets for your applications. For example, Button , TextField etc.
4- data - Contains the local database.
5- services - Contains all network logic of your application.
6- routes.dart — Contains the routes of your application and imports all screens.

### UI
Contains the screens of your application. All files from here get imported into `routes.dart`

```
ui/
|- login
   |- auth.dart
   |- index.dart
   |- widgets
      |- loginForm
        |- login_form.dart
      |- loginButton
        |- login_button.dart
```

### Util


For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
