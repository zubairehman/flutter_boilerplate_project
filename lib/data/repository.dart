import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:sembast/sembast.dart';

import 'local/constants/db_constants.dart';
import 'network/apis/posts/post_api.dart';

class Repository {
  // database object
  final _postDataSource = PostDataSource.instance;

  // api objects
  final _postApi = PostApi.instance;

  // shared pref object
  final _sharedPrefsHelper = SharedPreferenceHelper.instance;

  // singleton repository object:-----------------------------------------------
  static final Repository _singleton = Repository._();

  // A private constructor. Allows us to create instances of Repository
  // only from within the Repository class itself.
  Repository._();

  // factory method to return the same object each time its needed
  factory Repository() => _singleton;

  // Singleton accessor
  static Repository get instance => _singleton;

  // Post: ---------------------------------------------------------------------
  Future<PostsList> getPosts() => _postApi
      .getPosts()
      .then((posts) => posts)
      .catchError((error) => throw error);

  Future<List<Post>> findPostById(int id) {

    //creating filter
    List<Filter> filters = List();

    //check to see if dataLogsType is not null
    if (id != null) {
      Filter dataLogTypeFilter =
      Filter.equal(DBConstants.FIELD_ID, id);
      filters.add(dataLogTypeFilter);
    }

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int> insert(Post post) => _postDataSource
      .insert(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> update(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> delete(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);
}
