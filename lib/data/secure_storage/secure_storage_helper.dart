import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'constants/secure_storage_constants.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _secureStorage;

  SecureStorageHelper(this._secureStorage);

  Future<String?> get authToken async {
    return _secureStorage.read(key: SecureStorageKeys.authToken);
  }

  Future<bool> saveAuthToken(String token) async {
    await _secureStorage.write(
      key: SecureStorageKeys.authToken,
      value: token,
    );
    return true;
  }

  Future<bool> removeAuthToken() async {
    await _secureStorage.delete(key: SecureStorageKeys.authToken);
    return true;
  }

  Future<String> getOrCreateDatabaseEncryptionKey() async {
    final existing = await _secureStorage.read(key: SecureStorageKeys.databaseEncryptionKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final key = base64UrlEncode(bytes);
    await _secureStorage.write(key: SecureStorageKeys.databaseEncryptionKey, value: key);
    return key;
  }
}