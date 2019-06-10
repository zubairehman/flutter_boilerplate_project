import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:inject/inject.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'netwok_module.dart';

@module
class LocalModule extends NetworkModule {
  /// A singleton preference provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  @asynchronous
  Future<SharedPreferences> provideSharedPreferences() async =>
      await SharedPreferences.getInstance();

  /// A singleton preference helper provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  SharedPreferenceHelper provideSharedPreferenceHelper() =>
      SharedPreferenceHelper(provideSharedPreferences());

  /// A singleton repository provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  Repository provideRepository() =>
      Repository(providePostApi(), provideSharedPreferenceHelper());
}
