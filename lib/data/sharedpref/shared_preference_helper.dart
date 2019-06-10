import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {

  // shared pref instance
  final Future<SharedPreferences> sharedPreference;

  // constructor
  SharedPreferenceHelper(this.sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<String> get authToken async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(Preferences.auth_token);
  }

  Future<void> saveAuthToken(String authToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(Preferences.auth_token, authToken);
  }

  Future<void> removeAuthToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(Preferences.auth_token);
  }

  Future<bool> get isLoggedIn async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(Preferences.auth_token) ?? false;
  }
}
