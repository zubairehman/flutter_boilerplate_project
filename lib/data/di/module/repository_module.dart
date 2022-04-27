import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/data/repository/post/post_repository_impl.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/data/repository/setting/setting_repository_impl.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/data/repository/user/user_repository_impl.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

mixin RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    injector.registerSingleton<SettingRepository>(SettingRepositoryImpl(
      injector<SharedPreferenceHelper>(),
    ));

    injector.registerSingleton<UserRepository>(UserRepositoryImpl(
      injector<SharedPreferenceHelper>(),
    ));

    injector.registerSingleton<PostRepository>(PostRepositoryImpl(
      injector<PostApi>(),
      injector<PostDataSource>(),
    ));
  }
}
