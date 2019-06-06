import 'package:boilerplate/locale/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sharedpref/constants/index.dart';
import '../routes.dart';
import '../widgets/index.dart';
import 'home/home.dart';
import 'settings/settings.dart';

class AppNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicNavigation(
      type: NavigationType.bottomTabs,
      children: [
        Screen(
            iconData: Icons.home,
            title: AppLocalizations.of(context).posts_title,
            child: HomeScreen(),
            actions: [
              IconButton(
                onPressed: () {
                  SharedPreferences.getInstance().then((preference) {
                    preference.setBool(Preferences.is_logged_in, false);
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  });
                },
                icon: Icon(
                  Icons.power_settings_new,
                ),
              ),
            ]),
        Screen(
          iconData: Icons.settings,
          title: AppLocalizations.of(context).settings_title,
          child: SettingsScreen(),
        ),
      ],
    );
  }
}
