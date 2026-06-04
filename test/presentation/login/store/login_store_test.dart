import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/domain/entity/user/user.dart';
import 'package:boilerplate/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/save_login_in_status_usecase.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:flutter_test/flutter_test.dart';

// --- Inline fake use cases (no mockito needed) ---

class _FakeIsLoggedInUseCase implements IsLoggedInUseCase {
  final bool _loggedIn;
  _FakeIsLoggedInUseCase(this._loggedIn);

  @override
  Future<bool> call({required void params}) async => _loggedIn;
}

class _FakeSaveLoginStatusUseCase implements SaveLoginStatusUseCase {
  @override
  Future<void> call({required bool params}) async {}
}

class _FakeLoginUseCase implements LoginUseCase {
  @override
  Future<User?> call({required LoginParams params}) async => null;
}

// --- Test helper ---

UserStore buildUserStoreForTest({bool initialLoggedIn = false}) {
  return UserStore(
    _FakeIsLoggedInUseCase(initialLoggedIn),
    _FakeSaveLoginStatusUseCase(),
    _FakeLoginUseCase(),
    FormErrorStore(),
    ErrorStore(),
  );
}

void main() {
  test('auth bootstrap exposes loading then logged-in state', () async {
    final store = buildUserStoreForTest(initialLoggedIn: true);

    expect(store.isAuthBootstrapped, isFalse);
    await store.bootstrapAuth();

    expect(store.isAuthBootstrapped, isTrue);
    expect(store.isLoggedIn, isTrue);
  });

  test('auth bootstrap sets isLoggedIn to false when not logged in', () async {
    final store = buildUserStoreForTest(initialLoggedIn: false);

    expect(store.isAuthBootstrapped, isFalse);
    await store.bootstrapAuth();

    expect(store.isAuthBootstrapped, isTrue);
    expect(store.isLoggedIn, isFalse);
  });
}