import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'exceptions/network_exceptions.dart';

class RestClient {
  // singleton object
  static final RestClient _restClient = RestClient._internal();

  // named private constructor
  RestClient._internal();

  // factory method to return the same object each time its needed
  factory RestClient() => _restClient;

  // instantiate json decoder for json serialization
  final JsonDecoder _decoder = JsonDecoder();

  // Get
  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw NetworkException(message:"Error fetching data from server", statusCode: statusCode);
      }

      print(res);
      return _decoder.convert(res);
    });
  }

  // Post
  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw NetworkException(message:"Error fetching data from server", statusCode: statusCode);
      }
      return _decoder.convert(res);
    });
  }
}
