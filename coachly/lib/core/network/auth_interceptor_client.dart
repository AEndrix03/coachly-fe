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
  // Resolve circular dependency by reading authServiceProvider here
  final authService = ref.watch(authServiceProvider);
  return AuthHttpClient(ref.watch(httpClientProvider), authService);
}

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final AuthService _authService; // Inject AuthService

  AuthHttpClient(this._inner, this._authService);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final isAuthRequest = request.url.path.contains('/auth');

    String? accessToken = await _authService.getAccessToken();

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
    final refreshToken = await _authService.getRefreshToken();

    if (refreshToken == null) {
      await _authService.clearTokens(); // Clear tokens if no refresh token
      return false;
    }

    try {
      final loginResponse = await _authService.refreshToken(refreshToken);
      await _authService.saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      );
      return true;
    } catch (e) {
      // Refresh failed due to network error or invalid refresh token
      await _authService.clearTokens();
      return false;
    }
  }
}
