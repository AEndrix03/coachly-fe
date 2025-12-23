import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coachly/core/network/interceptors/auth_interceptor_client.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_response.dart';

part 'api_client.g.dart';

// Provider per ApiClient
@riverpod
ApiClient apiClient(Ref ref) {
  // Inject the authenticated client
  final httpClient = ref.watch(authHttpClientProvider);
  return ApiClient(
    client: httpClient,
    baseUrl: 'https://dev.aredegalli.it:8800/api',
  );
}

/// HTTP Client centralizzato
class ApiClient {
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required http.Client client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    Map<String, String>? defaultHeaders,
  }) : _client = client,
       defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      print('📡 GET: $uri');

      final response = await _client
          .get(uri, headers: defaultHeaders)
          .timeout(timeout);

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

      final response = await _client
          .post(
            uri,
            headers: defaultHeaders,
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

      final response = await _client
          .put(
            uri,
            headers: defaultHeaders,
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

      final response = await _client
          .delete(uri, headers: defaultHeaders)
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
      // Handle empty response body for success codes like 204 No Content
      if (response.body.isEmpty) {
        return ApiResponse.success(data: null, statusCode: response.statusCode);
      }
      final jsonData = jsonDecode(response.body);

      if (fromJson != null) {
        // The fromJson function is now responsible for converting the decoded
        // JSON (which could be a Map or a List) into the final type T.
        return ApiResponse.success(
          data: fromJson(jsonData),
          statusCode: response.statusCode,
        );
      } else {
        // This case is kept for when no parsing function is provided,
        // but it's less type-safe.
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
        message: 'Failed to parse error response: ${response.body}',
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
