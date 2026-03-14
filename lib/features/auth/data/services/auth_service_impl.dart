import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class AuthServiceImpl implements AuthService {
  final TokenManager _tokenManager;
  final FlutterAppAuth _appAuth;

  AuthServiceImpl(this._tokenManager) : _appAuth = const FlutterAppAuth();

  @override
  Future<LoginResponseDto> login() async {
    try {
      final response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          ApiEndpoints.keycloakClientId,
          ApiEndpoints.keycloakRedirectUri,
          issuer: ApiEndpoints.keycloakIssuer,
          discoveryUrl: ApiEndpoints.keycloakDiscoveryUrl,
          scopes: ApiEndpoints.openIdScopes,
        ),
      );

      if (response == null ||
          response.accessToken == null ||
          response.refreshToken == null) {
        throw const ServerFailure(
          'Keycloak ha completato il login ma non ha restituito i token attesi.',
        );
      }

      final loginResponse = LoginResponseDto.fromTokens(
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken!,
      );

      await saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
        idToken: response.idToken,
      );
      return loginResponse;
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }
      throw ServerFailure('Errore durante il login con Keycloak: $e');
    }
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    try {
      final response = await _appAuth.token(
        TokenRequest(
          ApiEndpoints.keycloakClientId,
          ApiEndpoints.keycloakRedirectUri,
          issuer: ApiEndpoints.keycloakIssuer,
          discoveryUrl: ApiEndpoints.keycloakDiscoveryUrl,
          scopes: ApiEndpoints.openIdScopes,
          refreshToken: refreshToken,
        ),
      );

      if (response == null ||
          response.accessToken == null ||
          response.refreshToken == null) {
        throw const ServerFailure(
          'Keycloak non ha restituito i token aggiornati.',
        );
      }

      final loginResponse = LoginResponseDto.fromTokens(
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken!,
      );

      await saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
        idToken: response.idToken,
      );
      return loginResponse;
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }
      throw NetworkFailure(
        'Impossibile aggiornare la sessione tramite Keycloak: $e',
      );
    }
  }

  @override
  Future<void> saveTokens(
    String accessToken,
    String refreshToken, {
    String? idToken,
  }) async {
    await _tokenManager.saveTokens(accessToken, refreshToken, idToken: idToken);
  }

  @override
  Future<void> clearTokens() async {
    await _tokenManager.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return _tokenManager.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return _tokenManager.getRefreshToken();
  }

  @override
  Future<String?> getIdToken() async {
    return _tokenManager.getIdToken();
  }

  @override
  Future<void> endSession() async {
    final idToken = await getIdToken();
    if (idToken == null) {
      return;
    }

    try {
      await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: ApiEndpoints.keycloakPostLogoutRedirectUri,
          issuer: ApiEndpoints.keycloakIssuer,
          discoveryUrl: ApiEndpoints.keycloakDiscoveryUrl,
        ),
      );
    } catch (_) {
      return;
    }
  }
}
