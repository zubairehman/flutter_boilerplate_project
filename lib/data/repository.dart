import 'dart:async';

import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:sembast/sembast.dart';

class Repository {
  // data source object
  final PostDataSource _postDataSource;

  // api objects
  final PostApi _postApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(this._postApi, this._sharedPrefsHelper, this._postDataSource);

  // Post: ---------------------------------------------------------------------
  Future<PostList> getPosts() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return _postApi.getPosts().then((postsList) {
      postsList.posts?.forEach((post) {
        _postDataSource.insert(post);
      });

      return postsList;
    }).catchError((error) => throw error as Object);
  }

  Future<List<Post>> findPostById(int id) {
    //creating filter
    final List<Filter> filters = [];

    //check to see if dataLogsType is not null
    final Filter dataLogTypeFilter = Filter.equals(DBConstants.fieldID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((Object error) => throw error);
  }

  Future<int> insert(Post post) => _postDataSource
      .insert(post)
      .then((id) => id)
      .catchError((Object error) => throw error);

  Future<int> update(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((Object error) => throw error);

  Future<int> delete(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((Object error) => throw error);


  // Login:---------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    return Future.delayed(const Duration(seconds: 2), ()=> true);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // Theme: --------------------------------------------------------------------
  // ignore: avoid_positional_boolean_parameters
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;
}
