import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {

  @factoryMethod
  Dio provideDio(SharedPreferenceHelper sharedPrefHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      // ..interceptors.add(
      //   InterceptorsWrapper(
      //     onRequest: (RequestOptions options,
      //         RequestInterceptorHandler handler) async {
      //       // // getting shared pref instance
      //       // var prefs = await SharedPreferences.getInstance();
      //       //
      //       // // getting token
      //       // var token = prefs.getString(Preferences.auth_token);
      //       //
      //       // if (token != null) {
      //       //   options.headers.putIfAbsent('Authorization', () => token);
      //       // } else {
      //       //   print('Auth token is null');
      //       // }
      //     },
      //   ),
      // )
    ;

    return dio;
  }
}
