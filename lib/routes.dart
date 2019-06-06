import 'package:flutter/material.dart';

import 'ui/home/home.dart';
import 'ui/login/login.dart';
import 'ui/navigation.dart';
import 'ui/settings/settings.dart';
import 'ui/splash/splash.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => AppNavigation(children: [
          Screen(
            iconData: Icons.home,
            title: 'Home',
            child: HomeScreen(),
          ),
          Screen(
            iconData: Icons.settings,
            title: 'Settings',
            child: SettingsScreen(),
          ),
        ]),
  };
}
