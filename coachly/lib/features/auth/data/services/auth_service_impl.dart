import 'dart:convert';

import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/core/network/interceptors/auth_interceptor_client.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';

class AuthServiceImpl implements AuthService {
  final AuthHttpClient _client;
  final TokenManager _tokenManager; // Add TokenManager dependency

  AuthServiceImpl(this._client, this._tokenManager);

  @override
  Future<LoginResponseDto> login(LoginRequestDto loginRequest) async {
    final response = await _client.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.loginEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponseDto.fromJson(
        jsonDecode(response.body),
      );
      await saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      ); // Save tokens after successful login
      return loginResponse;
    } else {
      // In a real app, parse the error response from the server
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    final response = await _client.post(
      Uri.parse('${ApiEndpoints.baseUrl}/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponseDto.fromJson(
        jsonDecode(response.body),
      );
      await saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      ); // Save tokens after refresh
      return loginResponse;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _tokenManager.saveTokens(accessToken, refreshToken);
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
}
