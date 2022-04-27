import 'dart:async';

abstract class UserRepository {
  Future<bool> login(String email, String password);

  Future<void> saveIsLoggedIn(bool value);

  Future<bool> get isLoggedIn;
}
