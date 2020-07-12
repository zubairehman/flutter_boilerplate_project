import 'dart:async';

import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    print('inside initState()');
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    print('inside build()');

    return Material(
      child: Center(child: AppIconWidget(image: 'assets/icons/ic_appicon.png')),
    );
  }

  startTimer() {
    print('inside startTimer()');
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  navigate() async {
    print('inside navigate()');

    SharedPreferences preferences = await SharedPreferences.getInstance();

    print('inside if');
    if (preferences.getBool(Preferences.is_logged_in) ?? false) {
      Navigator.of(context).pushNamed(Routes.home);
    } else {
      Navigator.of(context).pushNamed(Routes.login);
    }
  }
}
