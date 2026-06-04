import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtHelper {
  JwtHelper._();

  static String sign(
    Map<String, dynamic> claims, {
    required String secret,
    Duration expiresIn = const Duration(hours: 1),
    String? issuer,
    String? audience,
    String? subject,
  }) {
    final jwt = JWT(
      claims,
      issuer: issuer,
      audience: _audience(audience),
      subject: subject,
    );

    return jwt.sign(
      SecretKey(secret),
      expiresIn: expiresIn,
    );
  }

  static Map<String, dynamic>? tryVerify(
    String token, {
    required String secret,
    String? issuer,
    String? audience,
    String? subject,
  }) {
    final jwt = JWT.tryVerify(
      token,
      SecretKey(secret),
      issuer: issuer,
      audience: _audience(audience),
      subject: subject,
    );

    return _claimsFromPayload(jwt?.payload);
  }

  static Map<String, dynamic>? tryDecode(String token) {
    final jwt = JWT.tryDecode(token);

    return _claimsFromPayload(jwt?.payload);
  }

  static Audience? _audience(String? audience) {
    if (audience == null) {
      return null;
    }

    return Audience.one(audience);
  }

  static Map<String, dynamic>? _claimsFromPayload(Object? payload) {
    if (payload is! Map) {
      return null;
    }

    return payload.map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }
}
