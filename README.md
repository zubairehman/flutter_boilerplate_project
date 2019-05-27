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

1- ui — Contains the ui of your application. All files from here get imported into routes.dart.
2- util — Contains the utilities/common functions of your application.
3- widgets — Contains the common widgets for your applications. For example, Button , TextField etc.
4- data - Contains the data layer of your application which includes local, network and shared pref packages.
5- stores - Contains stores for state-management of your application.
6- routes.dart — Contains the routes of your application.

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

