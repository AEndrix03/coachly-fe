import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/network/interceptors/auth_interceptor.dart';
import 'package:coachly/core/network/request_coalescer.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Annullamento di una richiesta in volo (ADR-006).
///
/// È il `CancelToken` di Dio, non più il surrogato costruito su
/// `package:http`: quello scartava la risposta, ma il traffico partiva e
/// arrivava comunque. Ora la richiesta viene realmente interrotta — che su un
/// client local-first, dove ogni GET è opzionale per definizione, è la
/// differenza fra sprecare banda e non sprecarla.
///
/// Uso previsto:
///
/// ```dart
/// final token = CancelToken();
/// ref.onDispose(token.cancel);
/// ```
///
/// **Una cancellazione non è un errore.** Si mappa su [CancelledFailure] e non
/// produce mai un messaggio all'utente né una segnalazione al crash reporter.
export 'package:dio/dio.dart' show CancelToken;

part 'api_client.g.dart';

/// Timeout di rete. Vedi `docs/development/06-networking.md`.
///
/// I 30 s uniformi precedenti erano troppi per una chiamata interattiva e
/// troppo pochi per un batch di sync. Con Dio sono due timeout distinti e non
/// più una scadenza unica in cui connect e receive si sommavano.
abstract final class NetworkTimeouts {
  /// Tempo massimo per stabilire la connessione.
  static const Duration connect = Duration(seconds: 10);

  /// Tempo massimo per ricevere la risposta di una chiamata normale.
  static const Duration receive = Duration(seconds: 20);

  /// Tempo massimo per ricevere la risposta di un batch di sync.
  static const Duration syncReceive = Duration(seconds: 60);
}

@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient(
    dio: ref.watch(authDioProvider),
    baseUrl: ApiEndpoints.apiBaseUrl,
    logger: ref.watch(appLoggerProvider),
  );
}

/// HTTP Client centralizzato.
///
/// Le GET passano **sempre** dal [RequestCoalescer], in ogni modalità di
/// cache: richieste identiche concorrenti diventano una sola richiesta.
class ApiClient {
  static const Failure _cancelled = CancelledFailure();

  final Dio _dio;
  final AppLogger _logger;
  final RequestCoalescer _coalescer;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required Dio dio,
    required this.baseUrl,
    AppLogger logger = const ConsoleAppLogger(),
    RequestCoalescer? coalescer,
    this.connectTimeout = NetworkTimeouts.connect,
    this.receiveTimeout = NetworkTimeouts.receive,
    Map<String, String>? defaultHeaders,
  }) : _dio = dio,
       _logger = logger,
       _coalescer = coalescer ?? RequestCoalescer(),
       defaultHeaders =
           defaultHeaders ??
           const {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           } {
    _dio.options = _dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      // Gli stati non-2xx tornano come risposta, non come eccezione: la
      // tassonomia degli errori è di `ApiResponse`, non di Dio.
      validateStatus: (_) => true,
    );
  }

  /// `true` se la risposta è l'esito di una cancellazione.
  ///
  /// Chi la riceve non mostra nulla.
  static bool wasCancelled(ApiResponse<Object?> response) =>
      !response.success && response.statusCode == _cancelled.code;

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) async {
    final key = RequestCoalescer.keyFor('GET', endpoint, queryParameters);
    _logger.debug('GET', context: {'path': endpoint});
    try {
      final inFlight = _coalescer.run<Response<dynamic>>(
        key,
        () => _dio.get<dynamic>(
          _path(endpoint),
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: _options(receiveTimeoutOverride),
        ),
      );
      return _handleResponse<T>(await inFlight, fromJson);
    } catch (error) {
      // Un annullamento libera la voce del coalescer: chi arriva dopo deve
      // ripartire pulito, non ereditare una richiesta morta.
      if (_isCancellation(error)) _coalescer.invalidate(key);
      return _handleError<T>(error, endpoint);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) => _write<T>(
    'POST',
    endpoint,
    body: body,
    queryParameters: queryParameters,
    fromJson: fromJson,
    cancelToken: cancelToken,
    receiveTimeoutOverride: receiveTimeoutOverride,
  );

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) => _write<T>(
    'PUT',
    endpoint,
    body: body,
    queryParameters: queryParameters,
    fromJson: fromJson,
    cancelToken: cancelToken,
    receiveTimeoutOverride: receiveTimeoutOverride,
  );

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) => _write<T>(
    'DELETE',
    endpoint,
    queryParameters: queryParameters,
    fromJson: fromJson,
    cancelToken: cancelToken,
    receiveTimeoutOverride: receiveTimeoutOverride,
  );

  /// Nessun coalescing sulle scritture: non sono idempotenti.
  Future<ApiResponse<T>> _write<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) async {
    _logger.debug(method, context: {'path': endpoint});
    try {
      final response = await _dio.request<dynamic>(
        _path(endpoint),
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _options(receiveTimeoutOverride).copyWith(method: method),
      );
      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      return _handleError<T>(error, endpoint);
    }
  }

  Options _options(Duration? receiveTimeoutOverride) => Options(
    headers: Map<String, String>.of(defaultHeaders),
    receiveTimeout: receiveTimeoutOverride ?? receiveTimeout,
  );

  String _path(String endpoint) =>
      endpoint.startsWith('/') ? endpoint : '/$endpoint';

  static bool _isCancellation(Object error) =>
      error is DioException && error.type == DioExceptionType.cancel;

  ApiResponse<T> _handleResponse<T>(
    Response<dynamic> response,
    T Function(dynamic)? fromJson,
  ) {
    final status = response.statusCode ?? 0;

    // Mai il body completo: contiene dati dell'utente e in release sarebbe
    // comunque stampato. Vedi docs/development/18-observability.md.
    _logger.debug('Response', context: {'status': status});

    if (status >= 200 && status < 300) {
      final data = response.data;
      // 204 No Content e simili.
      if (data == null || (data is String && data.isEmpty)) {
        return ApiResponse.success(data: null, statusCode: status);
      }
      return ApiResponse.success(
        data: fromJson != null ? fromJson(data) : data as T?,
        statusCode: status,
      );
    }

    return _parseErrorResponse<T>(response, status);
  }

  ApiResponse<T> _parseErrorResponse<T>(
    Response<dynamic> response,
    int status,
  ) {
    final data = response.data;
    if (data is Map) {
      return ApiResponse.error(
        message: (data['message'] as String?) ?? 'Unknown error',
        statusCode: status,
        errors: data['errors'],
      );
    }
    return ApiResponse.error(
      message: 'Failed to parse error response',
      statusCode: status,
    );
  }

  ApiResponse<T> _handleError<T>(Object error, String endpoint) {
    if (_isCancellation(error)) {
      // Non è un errore: non si logga come warning e non si mostra.
      _logger.debug('Request cancelled', context: {'path': endpoint});
      return ApiResponse.error(
        message: _cancelled.message,
        statusCode: _cancelled.code,
      );
    }

    _logger.warn('Request failed', error: error);

    if (error is! DioException) {
      return ApiResponse.error(message: 'Unexpected error: $error');
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => ApiResponse.error(
        message: 'Request timeout. Please try again.',
        statusCode: 408,
      ),
      DioExceptionType.connectionError => ApiResponse.error(
        message: 'No internet connection',
        statusCode: 0,
      ),
      _ => ApiResponse.error(message: 'Network error occurred', statusCode: 0),
    };
  }
}
