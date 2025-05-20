class User {
  final String token;
  final String refreshToken;
  final String expiresIn;
  final String username;
  final String userId;

  User({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
    required this.username,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      username: json['username'],
      userId: json['user_id'],
    );
  }
}

class UserResponse {
  final Object? data;
  final String? message;
  final String? status;

  UserResponse({
    required this.data,
    required this.message,
    required this.status,
  });
}
