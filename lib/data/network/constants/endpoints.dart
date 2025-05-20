class Endpoints {
  Endpoints._();

  // base url
  static const String demoBaseUrl = "http://jsonplaceholder.typicode.com";
  static const String baseUrl = "https://qa-bbapp-qa01.hz1.developbb.dev";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = demoBaseUrl + "/posts";

  // login endpoints
  static const String login =
      baseUrl + "/wp-json/buddyboss-app/auth/v2/jwt/login";
}
