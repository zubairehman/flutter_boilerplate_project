import 'dart:async';

import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/data/di/data_layer_injection.dart';
import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/presentation/post/store/post_store.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

mixin StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());
    getIt.registerFactory(() => FormErrorStore());
    getIt.registerFactory(
      () => FormStore(injector<FormErrorStore>(), injector<ErrorStore>()),
    );

    // stores:------------------------------------------------------------------
    injector.registerSingleton<PostStore>(
      PostStore(injector<PostRepository>(), injector<ErrorStore>()),
    );
    injector.registerSingleton<UserStore>(
      UserStore(injector<UserRepository>(), injector<FormErrorStore>(),
          injector<ErrorStore>()),
    );
    injector.registerSingleton<ThemeStore>(
      ThemeStore(injector<SettingRepository>(), injector<ErrorStore>()),
    );
    injector.registerSingleton<LanguageStore>(
      LanguageStore(injector<SettingRepository>(), injector<ErrorStore>()),
    );
  }
}
