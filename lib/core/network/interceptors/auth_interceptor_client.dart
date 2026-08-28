import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/core/network/session_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor_client.g.dart';

@riverpod
http.Client httpClient(Ref ref) {
  return http.Client();
}

@riverpod
AuthHttpClient authHttpClient(Ref ref) {
  return AuthHttpClient(
    ref.watch(httpClientProvider),
    ref.watch(sessionGatewayProvider),
  );
}

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final SessionGateway _session;
  Future<bool>? _ongoingTokenRefresh;

  AuthHttpClient(this._inner, this._session);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final isAuthRequest = _isAuthRequest(request.url);
    final retryRequest = isAuthRequest ? null : _copyRequest(request);

    String? accessToken = await _session.accessToken();

    if (!isAuthRequest) {
      final needsRefresh =
          accessToken == null || _session.shouldRefresh(accessToken);
      if (needsRefresh) {
        final didRefreshToken = await _refreshToken();
        if (didRefreshToken) {
          accessToken = await _session.accessToken();
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
        final refreshedAccessToken = await _session.accessToken();
        final replayRequest = retryRequest;
        if (refreshedAccessToken != null && replayRequest != null) {
          replayRequest.headers['Authorization'] =
              'Bearer $refreshedAccessToken';
        }
        if (replayRequest != null) {
          return _inner.send(replayRequest);
        }
      }

      await _session.invalidateSession();
    }

    return response;
  }

  bool _isAuthRequest(Uri uri) {
    return uri.toString().startsWith(ApiEndpoints.keycloakTokenEndpoint);
  }

  http.BaseRequest _copyRequest(http.BaseRequest request) {
    if (request is http.Request) {
      final copy = http.Request(request.method, request.url)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection
        ..headers.addAll(request.headers)
        ..bodyBytes = request.bodyBytes;
      return copy;
    }

    if (request is http.MultipartRequest) {
      final copy = http.MultipartRequest(request.method, request.url)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection
        ..headers.addAll(request.headers)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
      return copy;
    }

    throw StateError('Cannot retry requests of type ${request.runtimeType}.');
  }

  Future<bool> _refreshToken() async {
    final ongoingRefresh = _ongoingTokenRefresh;
    if (ongoingRefresh != null) {
      return ongoingRefresh;
    }

    final refresh = _performTokenRefresh();
    _ongoingTokenRefresh = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_ongoingTokenRefresh, refresh)) {
        _ongoingTokenRefresh = null;
      }
    }
  }

  Future<bool> _performTokenRefresh() => _session.refresh();
}
