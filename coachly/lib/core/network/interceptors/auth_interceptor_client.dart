import 'dart:async';

import 'package:coachly/features/auth/data/services/auth_service.dart'; // Import AuthService
import 'package:coachly/features/auth/providers/auth_provider.dart'; // Import authServiceProvider
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor_client.g.dart';

@riverpod
http.Client httpClient(Ref ref) {
  return http.Client();
}

@riverpod
AuthHttpClient authHttpClient(Ref ref) {
  // Pass Ref directly to AuthHttpClient to resolve AuthService lazily
  return AuthHttpClient(ref.watch(httpClientProvider), ref);
}

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Ref _ref; // Inject Ref instead of AuthService

  AuthHttpClient(this._inner, this._ref);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final isAuthRequest = request.url.path.contains('/auth');
    final authService = _ref.read(authServiceProvider); // Lazily get AuthService

    String? accessToken = await authService.getAccessToken();

    if (accessToken != null && !isAuthRequest) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401 && !isAuthRequest) {
      // Token is likely expired, try to refresh it
      final didRefreshToken = await _refreshToken();
      if (didRefreshToken) {
        // Retry the original request with the new token
        accessToken = await _authService.getAccessToken(); // Get the new token
        if (accessToken != null) {
          request.headers['Authorization'] = 'Bearer $accessToken';
        }
        return await _inner.send(request);
      } else {
        // Refresh failed, logout the user
        await _authService.clearTokens();
        // It might be good to force a navigation to /login here, but that's a side effect.
        // The router's redirect logic should handle the navigation.
      }
    }

    return response;
  }

  Future<bool> _refreshToken() async {
    final authService = _ref.read(authServiceProvider); // Lazily get AuthService
    final refreshToken = await authService.getRefreshToken();

    if (refreshToken == null) {
      await authService.clearTokens(); // Clear tokens if no refresh token
      return false;
    }

    try {
      final loginResponse = await authService.refreshToken(refreshToken);
      await authService.saveTokens(loginResponse.accessToken, loginResponse.refreshToken);
      return true;
    } catch (e) {
      // Refresh failed due to network error or invalid refresh token
      await authService.clearTokens();
      return false;
    }
  }
}
