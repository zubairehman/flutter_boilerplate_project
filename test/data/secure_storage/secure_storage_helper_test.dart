import 'package:boilerplate/data/secure_storage/secure_storage_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('database encryption key is generated once and reused', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final helper = SecureStorageHelper(const FlutterSecureStorage());

    final first = await helper.getOrCreateDatabaseEncryptionKey();
    final second = await helper.getOrCreateDatabaseEncryptionKey();

    expect(first, isNotEmpty);
    expect(second, first);
    expect(first, isNot('your-app-secret-key-change-in-production'));
  });
}