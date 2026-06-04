import 'package:boilerplate/data/repository/user/user_repository_impl.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('demo login returns a non-empty demo user and saves no auth token',
      () async {
    final repo = UserRepositoryImpl(
      SharedPreferenceHelper(await SharedPreferences.getInstance()),
    );

    final user = await repo.login(LoginParams(
      username: 'demo@example.com',
      password: 'password',
    ));

    expect(user, isNotNull);
    expect(user!.id, 'demo-user');
    expect(user.email, 'demo@example.com');
  });
}
