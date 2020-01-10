import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:inject/inject.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
class PreferenceModule {
  // DI variables:--------------------------------------------------------------
  Future<SharedPreferences> sharedPref;

  // constructor
  // Note: Do not change the order in which providers are called, it might cause
  // some issues
  PreferenceModule() {
    sharedPref = provideSharedPreferences();
  }

  // DI Providers:--------------------------------------------------------------
  /// A singleton preference provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  @asynchronous
  Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  /// A singleton preference helper provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  SharedPreferenceHelper provideSharedPreferenceHelper() {
    return SharedPreferenceHelper(sharedPref);
  }
}
