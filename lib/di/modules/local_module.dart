import 'dart:async';

import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/utils/encryption/xxtea.dart';
import 'package:inject/inject.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'netwok_module.dart';

@module
class LocalModule extends NetworkModule {
  /// A singleton preference provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  @asynchronous
  Future<SharedPreferences> provideSharedPreferences() async =>
      await SharedPreferences.getInstance();

  /// A singleton preference helper provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  SharedPreferenceHelper provideSharedPreferenceHelper() =>
      SharedPreferenceHelper(provideSharedPreferences());

  /// A singleton database provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  @asynchronous
  Future<Database> provideDatabase() async {
    // Key for encryption
    var encryptionKey = "";

    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, DBConstants.DB_NAME);

    // Check to see if encryption is set, then provide codec
    // else init normal db with path
    var database;
    if (encryptionKey.isNotEmpty) {
      // Initialize the encryption codec with a user password
      var codec = getXXTeaCodec(password: encryptionKey);
      database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    } else {
      database = await databaseFactoryIo.openDatabase(dbPath);
    }

    // Return database instance
    return database;
  }

  // DataSources:---------------------------------------------------------------
  // Define all your data sources here
  /// A singleton post dataSource provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  PostDataSource providePostDataSource() => PostDataSource(provideDatabase());
  // DataSources End:-----------------------------------------------------------

  /// A singleton repository provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  Repository provideRepository() =>
      Repository(providePostApi(), provideSharedPreferenceHelper(), providePostDataSource());


}
