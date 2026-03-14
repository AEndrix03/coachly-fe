import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor_client.g.dart';

@riverpod
http.Client httpClient(Ref ref) {
  return http.Client();
}

@riverpod
AuthHttpClient authHttpClient(Ref ref) {
  return AuthHttpClient(ref.watch(httpClientProvider), ref);
}

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Ref _ref;

  AuthHttpClient(this._inner, this._ref);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final isAuthRequest = _isAuthRequest(request.url);
    final authService = _ref.read(authServiceProvider);

    String? accessToken = await authService.getAccessToken();

    if (!isAuthRequest && accessToken != null) {
      if (JwtValidator.isRefreshNeeded(accessToken)) {
        final didRefreshToken = await _refreshToken();
        if (didRefreshToken) {
          accessToken = await authService.getAccessToken();
        }
      }

      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401 && !isAuthRequest) {
      final didRefreshToken = await _refreshToken();
      if (didRefreshToken) {
        final refreshedAccessToken = await authService.getAccessToken();
        if (refreshedAccessToken != null) {
          request.headers['Authorization'] = 'Bearer $refreshedAccessToken';
        }
        return _inner.send(request);
      }

      await authService.clearTokens();
      _ref.invalidate(authProvider);
    }

    return response;
  }

  bool _isAuthRequest(Uri uri) {
    return uri.toString().startsWith(ApiEndpoints.keycloakTokenEndpoint);
  }

  Future<bool> _refreshToken() async {
    final authService = _ref.read(authServiceProvider);
    final refreshToken = await authService.getRefreshToken();

    if (refreshToken == null) {
      await authService.clearTokens();
      _ref.invalidate(authProvider);
      return false;
    }

    try {
      final loginResponse = await authService.refreshToken(refreshToken);
      await authService.saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      );
      return true;
    } catch (_) {
      await authService.clearTokens();
      _ref.invalidate(authProvider);
      return false;
    }
  }
}
