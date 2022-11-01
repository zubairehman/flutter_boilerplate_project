import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/login/login.dart';
import 'package:boilerplate/ui/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();

  // Static variables
  static const Duration duration = Duration(milliseconds: 500);
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  static PageTransition routes(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return PageTransition(
          child: SplashScreen(),
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          duration: duration,
        );
      case login:
        return PageTransition(
          child: LoginScreen(),
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          duration: duration,
        );
      case home:
        return PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          duration: duration,
        );

      default:
        return PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          duration: duration,
        );
    }
  }
}
