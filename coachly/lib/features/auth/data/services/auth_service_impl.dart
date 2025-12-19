import 'dart:convert';

import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/core/network/interceptors/auth_interceptor_client.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthServiceImpl implements AuthService {
  final ValueGetter<AuthHttpClient> _getHttpClient;
  final TokenManager _tokenManager; // Add TokenManager dependency

  AuthServiceImpl(this._getHttpClient, this._tokenManager);

  @override
  Future<LoginResponseDto> login(LoginRequestDto loginRequest) async {
    final client = _getHttpClient();
    late final http.Response response;

    try {
      response = await client.post(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest.toJson()),
      );
    } catch (e) {
      // If the error is already a Failure, rethrow it. Otherwise, wrap it.
      if (e is Failure) {
        rethrow;
      }
      throw NetworkFailure(
        'Errore di connessione. Controlla la tua connessione internet.',
      );
    }

    if (response.statusCode == 200) {
      final loginResponse = LoginResponseDto.fromJson(
        jsonDecode(response.body),
      );
      await saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      ); // Save tokens after successful login
      return loginResponse;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw const InvalidCredentialsFailure();
    } else {
      throw ServerFailure(
        'Errore del server. Riprova più tardi.',
        response.statusCode,
      );
    }
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    final client = _getHttpClient();
    final response = await client.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.refreshEndpoint}'),
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
      throw ServerFailure(
        'Impossibile aggiornare la sessione. Effettua nuovamente il login.',
        response.statusCode,
      );
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
