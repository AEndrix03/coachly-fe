import 'package:coachly/core/time/clock.dart';
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

  /// [clock] esiste per i test: la scadenza di un token e' esattamente il
  /// tipo di regola che va provata al minuto prima e al minuto dopo, e con
  /// l'orologio di sistema cablato non si puo'
  /// (`docs/development/19-testing.md`).
  static Duration? getTokenRemainingTime(
    String token, {
    Clock clock = const SystemClock(),
  }) {
    try {
      final expirationDate = JwtDecoder.getExpirationDate(token);
      final now = clock.now();
      if (expirationDate.isBefore(now)) return null;
      return expirationDate.difference(now);
    } catch (e) {
      return null;
    }
  }

  static bool isRefreshNeeded(
    String token, {
    Duration threshold = const Duration(minutes: 5),
    Clock clock = const SystemClock(),
  }) {
    final remaining = getTokenRemainingTime(token, clock: clock);
    if (remaining == null) return true;
    return remaining < threshold;
  }
}
