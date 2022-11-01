class NetworkException implements Exception {
  String? message;
  int? statusCode;

  NetworkException({this.message, this.statusCode});
}

class AuthException extends NetworkException {
  AuthException({String? message, int? statusCode})
      : super(message: message, statusCode: statusCode);
}
