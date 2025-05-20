import 'dart:async';

import 'package:boilerplate/core/data/network/dio/dio_client.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/domain/entity/user/user.dart';
import 'package:dio/dio.dart';

class LoginApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  LoginApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<UserResponse> requestLogin(String username, String password) async {
    try {
      final res = await _dioClient.dio.post(
        Endpoints.login,
        data: {
          'username': username,
          'password': password,
          'uniqueID': '0cbf57',
          'appVersion': '0.7.6',
        },
      );
      return UserResponse(
        data: res.data,
        message: res.data['message'],
        status: res.data['status'],
      );
    } catch (e) {
      if (e is DioException) {
        final errorMessage =
            e.response?.data?['message'] ?? e.message ?? 'Unknown error';
        return UserResponse(
          data: null,
          message: errorMessage,
          status: 'error',
        );
      }
      return UserResponse(
        data: null,
        message: e.toString(),
        status: 'error',
      );
    }
  }

  /// sample api call with default rest client
//   Future<PostList> getPosts() async {
//     try {
//       final res = await _restClient.get(Endpoints.getPosts);
//       return PostList.fromJson(res.data);
//     } catch (e) {
//       print(e.toString());
//       throw e;
//     }
//   }
}
