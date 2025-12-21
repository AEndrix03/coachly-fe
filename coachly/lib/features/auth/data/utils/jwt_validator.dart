import 'package:jwt_decoder/jwt_decoder.dart';

class JwtValidator {
  static bool isTokenValid(String token) {
    try {
      if (token.isEmpty) return false;
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  static Map<String, dynamic>? decodeToken(String token) {
    try {
      if (token.isEmpty) return null;
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  static Duration? getTokenRemainingTime(String token) {
    try {
      final expirationDate = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      if (expirationDate.isBefore(now)) return null;
      return expirationDate.difference(now);
    } catch (e) {
      return null;
    }
  }

  static bool isRefreshNeeded(
    String token, {
    Duration threshold = const Duration(minutes: 5),
  }) {
    final remaining = getTokenRemainingTime(token);
    if (remaining == null) return true;
    return remaining < threshold;
  }
}
