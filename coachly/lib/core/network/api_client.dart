import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_response.dart';

part 'api_client.g.dart';

// Provider per ApiClient
@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient(
    baseUrl: 'https://your-api.com/api', // TODO: Configurare
  );
}

/// HTTP Client centralizzato
class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;
  String? _authToken;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    Map<String, String>? defaultHeaders,
  }) : defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'};

  void setAuthToken(String token) => _authToken = token;

  void clearAuthToken() => _authToken = null;

  Map<String, String> get _headers {
    final headers = Map<String, String>.from(defaultHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      print('📡 GET: $uri');

      final response = await http.get(uri, headers: _headers).timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      print('📡 POST: $uri');
      print('📦 Body: ${jsonEncode(body)}');

      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      print('📡 PUT: $uri');

      final response = await http
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      print('📡 DELETE: $uri');

      final response = await http
          .delete(uri, headers: _headers)
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    print('📥 Response ${response.statusCode}: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);

      if (fromJson != null) {
        return ApiResponse.fromJson(jsonData, fromJson);
      } else {
        return ApiResponse.success(
          data: jsonData as T?,
          statusCode: response.statusCode,
        );
      }
    } else {
      return _parseErrorResponse<T>(response);
    }
  }

  ApiResponse<T> _parseErrorResponse<T>(http.Response response) {
    try {
      final jsonData = jsonDecode(response.body);
      return ApiResponse.error(
        message: jsonData['message'] ?? 'Unknown error',
        statusCode: response.statusCode,
        errors: jsonData['errors'],
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to parse error response',
        statusCode: response.statusCode,
      );
    }
  }

  ApiResponse<T> _handleError<T>(dynamic error) {
    print('❌ Error: $error');

    if (error is TimeoutException) {
      return ApiResponse.error(
        message: 'Request timeout. Please try again.',
        statusCode: 408,
      );
    } else if (error is SocketException) {
      return ApiResponse.error(
        message: 'No internet connection',
        statusCode: 0,
      );
    } else if (error is http.ClientException) {
      return ApiResponse.error(
        message: 'Network error occurred',
        statusCode: 0,
      );
    } else {
      return ApiResponse.error(
        message: 'Unexpected error: ${error.toString()}',
      );
    }
  }
}
