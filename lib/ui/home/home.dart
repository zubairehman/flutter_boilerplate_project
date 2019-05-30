import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home Screen'),
            RoundedButtonWidget(
              buttonColor: Colors.orangeAccent,
              textColor: Colors.white,
              buttonText: 'Logout',
              onPressed: () {
                SharedPreferences.getInstance().then((preference) {
                  preference.setBool(Preferences.is_logged_in, false);
                  Navigator.of(context).pushReplacementNamed(Routes.login);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
