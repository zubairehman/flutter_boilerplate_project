import 'dart:async';

import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';

import '../../../domain/entity/user/user.dart';
import '../../../domain/usecase/user/login_usecase.dart';

class UserRepositoryImpl extends UserRepository {
  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  UserRepositoryImpl(this._sharedPrefsHelper);

  // Login:---------------------------------------------------------------------
  @override
  Future<User?> login(LoginParams params) async {
    return await Future.delayed(Duration(seconds: 2), () => User());
  }

  @override
  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  @override
  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
}
