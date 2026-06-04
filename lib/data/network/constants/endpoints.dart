class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 30000;
  static const String getPosts = '$baseUrl/posts';
}
