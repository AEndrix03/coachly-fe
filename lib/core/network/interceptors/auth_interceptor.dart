import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/core/network/session_gateway.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor.g.dart';

@riverpod
Dio dioClient(Ref ref) => Dio();

@riverpod
Dio authDio(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  dio.interceptors.add(AuthInterceptor(ref.watch(sessionGatewayProvider), dio));
  return dio;
}

/// Aggancia il token a ogni richiesta, lo rinnova quando serve e ritenta una
/// volta sola dopo un 401.
///
/// ADR-006: era un `http.BaseClient` che ricopiava a mano la richiesta per
/// poterla rigiocare, con un ramo per `Request` e uno per `MultipartRequest` e
/// uno `StateError` per tutto il resto. Con Dio la `RequestOptions` è già un
/// valore riutilizzabile e quel codice sparisce.
///
/// Il refresh resta **coalescente**: dieci richieste che scadono insieme
/// producono un solo refresh, non dieci. È la proprietà che il vecchio client
/// aveva e che non doveva perdersi nella migrazione.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._session, this._retryDio);

  final SessionGateway _session;

  /// Usato per rigiocare la richiesta dopo un refresh riuscito. È lo stesso
  /// `Dio`: il replay riparte dalla catena completa, ma `_replayed` impedisce
  /// che il 401 di ritorno inneschi un secondo giro.
  final Dio _retryDio;

  Future<bool>? _ongoingTokenRefresh;

  static const _replayed = 'coachly.auth.replayed';

  bool _isAuthRequest(Uri uri) =>
      uri.toString().startsWith(ApiEndpoints.keycloakTokenEndpoint);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthRequest(options.uri)) return handler.next(options);

    var accessToken = await _session.accessToken();
    if (accessToken == null || _session.shouldRefresh(accessToken)) {
      if (await _refreshToken()) {
        accessToken = await _session.accessToken();
      }
    }

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;
    final shouldRetry =
        response.statusCode == 401 &&
        !_isAuthRequest(options.uri) &&
        options.extra[_replayed] != true;

    if (!shouldRetry) return handler.next(response);

    if (await _refreshToken()) {
      final token = await _session.accessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        options.extra[_replayed] = true;
        try {
          return handler.resolve(await _retryDio.fetch<dynamic>(options));
        } on DioException catch (error) {
          return handler.next(error.response ?? response);
        }
      }
    }

    await _session.invalidateSession();
    return handler.next(response);
  }

  /// Un solo refresh alla volta: chi arriva mentre è in corso aspetta lo
  /// stesso esito invece di aprirne un altro.
  Future<bool> _refreshToken() {
    final ongoing = _ongoingTokenRefresh;
    if (ongoing != null) return ongoing;

    final refresh = _session.refresh();
    _ongoingTokenRefresh = refresh;
    return refresh.whenComplete(() {
      if (identical(_ongoingTokenRefresh, refresh)) {
        _ongoingTokenRefresh = null;
      }
    });
  }
}
