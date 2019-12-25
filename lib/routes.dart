import 'package:flutter/material.dart';

import 'ui/home/home.dart';
// initial screens
import 'ui/login/login.dart';
import 'ui/splash/splash.dart';
import 'ui/register/register.dart';
import 'ui/guide/guide.dart';
import 'ui/filter/filter.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String guide = '/guide';
  static const String filter = '/filter';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    register: (BuildContext context) => RegisterScreen(),
    guide: (BuildContext context) => GuideScreen(),
    filter: (BuildContext context) => FilterScreen(),
  };
}
