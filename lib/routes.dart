import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/home.dart';
import 'package:todo_app/ui/login/login.dart';
import 'package:todo_app/ui/splash/splash.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String map = '/map';
  static const String feedback = '/feedback';
  static const String empty = '/empty';
  static const String chat = '/chat';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
//    rc.Routes.map: (BuildContext context) => MapScreen(),
//    rc.Routes.feedback: (BuildContext context) => FeedbackScreen(),
//    rc.Routes.empty: (BuildContext context) => EmptyScreen(),
//    rc.Routes.chat: (BuildContext context) => ChatScreen(),
  };
}



