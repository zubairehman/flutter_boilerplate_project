import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/exceptions/network_exceptions.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/post/post_list.dart';

class PostApi {
  // singleton object
  static final PostApi _postApi = PostApi._internal();

  // named private constructor
  PostApi._internal();

  // factory method to return the same object each time its needed
  factory PostApi() => _postApi;

  // rest client
  final _restClient = RestClient();

  /// Returns list of post in response
  Future<PostsList> getPosts() {

    return _restClient
        .get(Endpoints.getPosts)
        .then((dynamic res) => PostsList.fromJson(res))
        .catchError((error) => throw NetworkException(message: error));
  }

}
