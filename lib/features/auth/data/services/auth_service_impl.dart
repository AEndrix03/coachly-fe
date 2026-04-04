import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class AuthServiceImpl implements AuthService {
  final TokenManager _tokenManager;
  final FlutterAppAuth _appAuth;
  static const AuthorizationServiceConfiguration _serviceConfiguration =
      AuthorizationServiceConfiguration(
        authorizationEndpoint: ApiEndpoints.keycloakAuthorizationEndpoint,
        tokenEndpoint: ApiEndpoints.keycloakTokenEndpoint,
        endSessionEndpoint: ApiEndpoints.keycloakLogoutEndpoint,
      );

  AuthServiceImpl(this._tokenManager) : _appAuth = const FlutterAppAuth();

  @override
  Future<LoginResponseDto> login() async {
    try {
      final response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          ApiEndpoints.keycloakClientId,
          ApiEndpoints.keycloakRedirectUri,
          serviceConfiguration: _serviceConfiguration,
          scopes: ApiEndpoints.openIdScopes,
        ),
      );

      if (response.accessToken == null || response.refreshToken == null) {
        throw const ServerFailure(
          'Keycloak completed login but did not return the expected tokens.',
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
      throw ServerFailure('Error during Keycloak login: $e');
    }
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    try {
      final response = await _appAuth.token(
        TokenRequest(
          ApiEndpoints.keycloakClientId,
          ApiEndpoints.keycloakRedirectUri,
          serviceConfiguration: _serviceConfiguration,
          scopes: ApiEndpoints.openIdScopes,
          refreshToken: refreshToken,
        ),
      );

      if (response.accessToken == null || response.refreshToken == null) {
        throw const ServerFailure('Keycloak did not return refreshed tokens.');
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
      throw NetworkFailure('Unable to refresh session via Keycloak: $e');
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
          serviceConfiguration: _serviceConfiguration,
        ),
      );
    } catch (_) {
      return;
    }
  }
}
