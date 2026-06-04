import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/usecase/post/get_post_usecase.dart';
import 'package:boilerplate/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/save_login_in_status_usecase.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';
import 'package:boilerplate/domain/entity/post/post.dart';
import 'package:boilerplate/domain/entity/user/user.dart';
import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/presentation/di/module/store_module.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/settings/settings_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    locale: const Locale('en'),
    home: Builder(
      builder: (context) => Scaffold(body: Center(child: child)),
    ),
  );
}

class _FakeSettingRepository implements SettingRepository {
  @override
  bool get isDarkMode => false;
  @override
  String? get currentLanguage => 'en';
  @override
  Future<void> changeBrightnessToDark(bool value) async {}
  @override
  Future<void> changeLanguage(String value) async {}
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<User?> login(LoginParams params) async => null;
  @override
  Future<void> saveIsLoggedIn(bool value) async {}
  @override
  Future<bool> get isLoggedIn async => false;
}

class _FakePostRepository implements PostRepository {
  @override
  Future<PostList> getPosts() async => PostList(posts: []);
  @override
  Future<List<Post>> findPostById(int id) async => [];
  @override
  Future<int> insert(Post post) async => 0;
  @override
  Future<int> update(Post post) async => 0;
  @override
  Future<int> delete(Post post) async => 0;
}

Future<void> _setUpGetIt({bool darkMode = false}) async {
  await getIt.reset();

  getIt.registerSingleton<SettingRepository>(_FakeSettingRepository());
  getIt.registerSingleton<UserRepository>(_FakeUserRepository());
  getIt.registerSingleton<PostRepository>(_FakePostRepository());
  getIt.registerSingleton<GetPostUseCase>(GetPostUseCase(getIt<PostRepository>()));
  getIt.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase(getIt<UserRepository>()));
  getIt.registerSingleton<SaveLoginStatusUseCase>(
    SaveLoginStatusUseCase(getIt<UserRepository>()),
  );
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<UserRepository>()));

  await StoreModule.configureStoreModuleInjection();

  if (darkMode) {
    await getIt<ThemeStore>().changeBrightnessToDark(true);
  }
}

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders all three rows with default values', (tester) async {
    await _setUpGetIt();

    await tester.pumpWidget(_wrap(SettingsDialog(
      themeStore: getIt<ThemeStore>(),
      languageStore: getIt<LanguageStore>(),
      settingsStore: getIt<SettingsStore>(),
    )));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('theme row toggles ThemeStore', (tester) async {
    await _setUpGetIt();
    final themeStore = getIt<ThemeStore>();
    expect(themeStore.darkMode, isFalse);

    await tester.pumpWidget(_wrap(SettingsDialog(
      themeStore: themeStore,
      languageStore: getIt<LanguageStore>(),
      settingsStore: getIt<SettingsStore>(),
    )));
    await tester.pumpAndSettle();

    // The theme row is the ListTile whose title is "Theme".
    final themeRow = find.widgetWithText(ListTile, 'Theme');
    expect(themeRow, findsOneWidget);
    await tester.tap(themeRow);
    await tester.pumpAndSettle();

    expect(themeStore.darkMode, isTrue);
    expect(find.text('Dark'), findsOneWidget);
  });
}