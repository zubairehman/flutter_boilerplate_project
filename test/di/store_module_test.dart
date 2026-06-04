import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/entity/post/post.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';
import 'package:boilerplate/domain/entity/user/user.dart';
import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/domain/usecase/post/get_post_usecase.dart';
import 'package:boilerplate/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/save_login_in_status_usecase.dart';
import 'package:boilerplate/presentation/di/module/store_module.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/presentation/post/store/post_store.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();

    // Register fakes for all dependencies needed by StoreModule
    final settingRepository = _FakeSettingRepository();
    final userRepository = _FakeUserRepository();
    final postRepository = _FakePostRepository();

    // Data layer dependencies (repositories)
    getIt.registerSingleton<SettingRepository>(settingRepository);
    getIt.registerSingleton<UserRepository>(userRepository);
    getIt.registerSingleton<PostRepository>(postRepository);

    // Domain layer dependencies (use cases)
    getIt.registerSingleton<GetPostUseCase>(GetPostUseCase(postRepository));
    getIt.registerSingleton<IsLoggedInUseCase>(
      IsLoggedInUseCase(userRepository),
    );
    getIt.registerSingleton<SaveLoginStatusUseCase>(
      SaveLoginStatusUseCase(userRepository),
    );
    getIt.registerSingleton<LoginUseCase>(LoginUseCase(userRepository));

    // Store module
    await StoreModule.configureStoreModuleInjection();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('feature stores are not shared singleton instances', () {
    final first = getIt<PostStore>();
    final second = getIt<PostStore>();

    expect(identical(first, second), isFalse);
  });

  test('app-wide stores are shared singleton instances', () {
    expect(identical(getIt<ThemeStore>(), getIt<ThemeStore>()), isTrue);
    expect(identical(getIt<LanguageStore>(), getIt<LanguageStore>()), isTrue);
    expect(identical(getIt<UserStore>(), getIt<UserStore>()), isTrue);
    expect(identical(getIt<SettingsStore>(), getIt<SettingsStore>()), isTrue);
  });
}

class _FakeSettingRepository implements SettingRepository {
  @override
  Future<void> changeBrightnessToDark(bool value) async {}

  @override
  bool get isDarkMode => false;

  @override
  Future<void> changeLanguage(String value) async {}

  @override
  String? get currentLanguage => null;
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
