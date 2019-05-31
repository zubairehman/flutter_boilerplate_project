import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio dio = new Dio()
  ..options.baseUrl = Endpoints.baseUrl
  ..options.connectTimeout = 5000
  ..options.receiveTimeout = 3000
  ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
  ..interceptors.add(LogInterceptor(responseBody: true))
  ..interceptors.add(InterceptorsWrapper(onRequest: (Options options) async {
    // getting shared pref instance
    var prefs = await SharedPreferences.getInstance();

    // getting token
    var token = prefs.getString(Preferences.auth_token);

    if (token != null) {
      options.headers.putIfAbsent('Authorization', () => token);
    } else {
      print('Auth token is null');
    }
  }));

class DioClient {

  // singleton object
  static final DioClient _singleton = DioClient._();

  // A private constructor. Allows us to create instances of WebClient
  // only from within the WebClient class itself.
  DioClient._();

  // factory method to return the same object each time its needed
  factory DioClient() => _singleton;

  // Singleton accessor
  static DioClient get instance => DioClient();
  
  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(String uri) async {
    try {
      final Response response = await dio.get(uri);
      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(String uri, dynamic data) async {
    try {
      final Response response = await dio.post(uri, data: data);
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
