import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/constants/app_theme.dart';
import 'package:todo_app/constants/strings_const.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/ui/splash/splash.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
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
