import 'dart:async';

import 'package:boilerplate/core/data/local/sembast/sembast_client.dart';
import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.instance;

mixin LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    // preference manager:------------------------------------------------------
    injector.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);
    injector.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(await injector.getAsync<SharedPreferences>()),
    );

    // database:----------------------------------------------------------------
    injector.registerSingletonAsync<SembastClient>(
        () async => SembastClient.provideDatabase(
              databaseName: DBConstants.DB_NAME,
              databasePath: (await getApplicationDocumentsDirectory()).path,
            ));

    // data sources:------------------------------------------------------------
    injector.registerSingleton(
        PostDataSource(await injector.getAsync<SembastClient>()));
  }
}
