import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';

class ErrorInterceptor extends Interceptor {
  final EventBus _eventBus;

  ErrorInterceptor(this._eventBus);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _eventBus.fire(
      ErrorEvent(
          path: err.requestOptions.path,
          response: err.response),
    );
    super.onError(err, handler);
  }
}

class ErrorEvent {
  final String path;
  final Response? response;

  ErrorEvent({required this.path, this.response});
}
