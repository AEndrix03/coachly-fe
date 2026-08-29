import 'package:coachly/core/network/session_gateway.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';

/// Implementazione di [SessionGateway] per la feature auth.
///
/// La dipendenza punta verso il basso: è auth a conoscere `core/network`, non
/// il contrario. Vedi `docs/development/01-principles.md`, dependency rule D5.
class AuthSessionGateway implements SessionGateway {
  AuthSessionGateway(this._authService, this._onSessionInvalidated);

  final AuthService _authService;
  final void Function() _onSessionInvalidated;

  @override
  Future<String?> accessToken() => _authService.getAccessToken();

  @override
  bool shouldRefresh(String accessToken) =>
      JwtValidator.isRefreshNeeded(accessToken);

  @override
  Future<bool> refresh() async {
    final refreshToken = await _authService.getRefreshToken();

    if (refreshToken == null) {
      await invalidateSession();
      return false;
    }

    try {
      final tokens = await _authService.refreshToken(refreshToken);
      await _authService.saveTokens(tokens.accessToken, tokens.refreshToken);
      return true;
    } catch (_) {
      // Un rinnovo fallito non è di per sé fine della sessione: può essere la
      // rete. La sessione muore solo su rifiuto esplicito (401 sul replay).
      return false;
    }
  }

  @override
  Future<void> invalidateSession() async {
    await _authService.clearTokens();
    _onSessionInvalidated();
  }
}
