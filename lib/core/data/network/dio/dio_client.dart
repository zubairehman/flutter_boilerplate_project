import 'package:dio/dio.dart';

import 'configs/dio_configs.dart';

class DioClient {
  final DioConfigs dioConfigs;
  final Dio _dio;

  DioClient({required this.dioConfigs})
      : _dio = Dio()
    ..options.baseUrl = dioConfigs.baseUrl
    ..options.connectTimeout = Duration(milliseconds: dioConfigs.connectionTimeout)
    ..options.receiveTimeout = Duration(milliseconds: dioConfigs.receiveTimeout);

  Dio get dio => _dio;

  Dio addInterceptors(Iterable<Interceptor> interceptors) {
    return _dio..interceptors.addAll(interceptors);
  }
}