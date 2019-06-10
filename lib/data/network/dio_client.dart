import 'package:dio/dio.dart';
import 'package:inject/inject.dart';

@provide
class DioClient {
  // dio instance
  final Dio dio;

  // injecting dio instance
  DioClient(this.dio);

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
