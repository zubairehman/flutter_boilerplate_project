import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // singleton object
  static final SharedPreferenceHelper _singleton = SharedPreferenceHelper._();

  // A private constructor. Allows us to create instances of SharedPreferenceHelper
  // only from within the SharedPreferenceHelper class itself.
  SharedPreferenceHelper._();

  // factory method to return the same object each time its needed
  factory SharedPreferenceHelper() => _singleton;

  // Singleton accessor
  static SharedPreferenceHelper get instance => _singleton;

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
