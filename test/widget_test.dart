// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/entity/user/user.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/save_login_in_status_usecase.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/presentation/my_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();

    final settingRepository = _FakeSettingRepository();
    final userRepository = _FakeUserRepository();
    final errorStore = ErrorStore();
    final formErrorStore = FormErrorStore();

    getIt.registerSingleton<ErrorStore>(errorStore);
    getIt.registerSingleton<FormErrorStore>(formErrorStore);
    getIt.registerSingleton<FormStore>(FormStore(formErrorStore, errorStore));
    getIt.registerSingleton<ThemeStore>(
      ThemeStore(settingRepository, errorStore),
    );
    getIt.registerSingleton<LanguageStore>(
      LanguageStore(settingRepository, errorStore),
    );
    getIt.registerSingleton<UserStore>(
      UserStore(
        IsLoggedInUseCase(userRepository),
        SaveLoginStatusUseCase(userRepository),
        LoginUseCase(userRepository),
        formErrorStore,
        errorStore,
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
  });
}

class _FakeSettingRepository implements SettingRepository {
  bool _isDarkMode = false;
  String? _currentLanguage;

  @override
  Future<void> changeBrightnessToDark(bool value) async {
    _isDarkMode = value;
  }

  @override
  bool get isDarkMode => _isDarkMode;

  @override
  Future<void> changeLanguage(String value) async {
    _currentLanguage = value;
  }

  @override
  String? get currentLanguage => _currentLanguage;
}

class _FakeUserRepository implements UserRepository {
  bool _isLoggedIn = false;

  @override
  Future<User?> login(LoginParams params) async =>
      User(id: 'demo-user', email: params.username);

  @override
  Future<void> saveIsLoggedIn(bool value) async {
    _isLoggedIn = value;
  }

  @override
  Future<bool> get isLoggedIn async => _isLoggedIn;
}
