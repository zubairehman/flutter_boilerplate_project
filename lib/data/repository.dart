import 'dart:async';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';

import 'local/datasources/post/post_datasource.dart';
import 'network/apis/posts/post_api.dart';

class Repository {
  // database object
  final _postDataSource = PostDataSource();

  // api objects
  final _postApi = PostApi();

  // shared pref object
  final _sharedPrefsHelper = SharedPreferenceHelper();

  // singleton repository object
  static final Repository _repository = Repository._internal();

  // named private constructor
  Repository._internal();

  // factory method to return the same object each time its needed
  factory Repository() => _repository;

  // General Methods: ----------------------------------------------------------
  static Repository get() => _repository;

  // Post: ---------------------------------------------------------------------
  Future<List<Post>> getPosts() => _postApi
      .getPosts()
      .then((posts) => posts)
      .catchError((error) => throw error);
}
