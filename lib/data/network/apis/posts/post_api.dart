import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/post/post_list.dart';

class PostApi {
  // dio instance
  final DioClient dioClient;

  // rest-client instance
  final RestClient restClient;

  // injecting dio instance
  PostApi(this.dioClient, this.restClient);

  /// Returns list of post in response
  Future<PostsList> getPosts() async {
    try {
      final res = await dioClient.get(Endpoints.getPosts);
      return PostsList.fromJson(res);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
