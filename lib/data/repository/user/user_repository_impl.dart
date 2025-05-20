import 'dart:async';

import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';

import '../../../domain/entity/user/user.dart';
import '../../../domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/data/network/apis/posts/login_api.dart';

class UserRepositoryImpl extends UserRepository {
  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  final LoginApi _loginApi;

  // constructor
  UserRepositoryImpl(this._loginApi, this._sharedPrefsHelper);

  // Login:---------------------------------------------------------------------
  @override
  Future<UserResponse?> login(LoginParams params) async {
    return await _loginApi.requestLogin(params.username, params.password);
  }

  @override
  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  @override
  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
}
