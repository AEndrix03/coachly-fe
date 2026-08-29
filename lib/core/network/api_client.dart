import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/api_endpoints.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/network/interceptors/auth_interceptor_client.dart';
import 'package:coachly/core/network/request_coalescer.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

/// Timeout di rete. Vedi `docs/development/06-networking.md`.
///
/// I 30 s uniformi precedenti erano troppi per una chiamata interattiva e
/// troppo pochi per un batch di sync.
abstract final class NetworkTimeouts {
  /// Tempo massimo per stabilire la connessione.
  static const Duration connect = Duration(seconds: 10);

  /// Tempo massimo per ricevere la risposta di una chiamata normale.
  static const Duration receive = Duration(seconds: 20);

  /// Tempo massimo per ricevere la risposta di un batch di sync.
  static const Duration syncReceive = Duration(seconds: 60);
}

/// Annullamento di una richiesta in volo.
///
/// `package:http` non supporta la cancellazione: finché non si passa a Dio
/// (ADR-006) questo token non interrompe il traffico già partito, ma scarta la
/// risposta e libera la voce del coalescer, così che un provider `autoDispose`
/// distrutto non riceva più nulla e chi arriva dopo riparta pulito.
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
class CancelToken {
  final Completer<void> _completer = Completer<void>();

  bool get isCancelled => _completer.isCompleted;

  /// Si completa quando il token viene annullato. Non fallisce mai.
  Future<void> get whenCancelled => _completer.future;

  void cancel() {
    if (!_completer.isCompleted) _completer.complete();
  }
}

// Provider per ApiClient
@riverpod
ApiClient apiClient(Ref ref) {
  final httpClient = ref.watch(authHttpClientProvider);
  return ApiClient(
    client: httpClient,
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

  final http.Client _client;
  final AppLogger _logger;
  final RequestCoalescer _coalescer;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required http.Client client,
    required this.baseUrl,
    AppLogger logger = const ConsoleAppLogger(),
    RequestCoalescer? coalescer,
    this.connectTimeout = NetworkTimeouts.connect,
    this.receiveTimeout = NetworkTimeouts.receive,
    Map<String, String>? defaultHeaders,
  }) : _client = client,
       _logger = logger,
       _coalescer = coalescer ?? RequestCoalescer(),
       defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'};

  /// `true` se la risposta è l'esito di una cancellazione.
  ///
  /// Chi la riceve non mostra nulla: vedi [CancelToken].
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
    try {
      final uri = _buildUri(endpoint, queryParameters);
      _logger.debug('GET', context: {'path': endpoint});

      final inFlight = _coalescer.run<http.Response>(
        key,
        () => _client
            .get(uri, headers: defaultHeaders)
            .timeout(_deadline(receiveTimeoutOverride)),
      );

      final response = await _awaitCancellable(inFlight, cancelToken, key);
      if (response == null) return _cancelledResponse<T>(endpoint);

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
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      _logger.debug('POST', context: {'path': endpoint});

      // Nessun coalescing sulle scritture: non sono idempotenti.
      final request = _client
          .post(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_deadline(receiveTimeoutOverride));

      final response = await _awaitCancellable(request, cancelToken, null);
      if (response == null) return _cancelledResponse<T>(endpoint);

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
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      _logger.debug('PUT', context: {'path': endpoint});

      final request = _client
          .put(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_deadline(receiveTimeoutOverride));

      final response = await _awaitCancellable(request, cancelToken, null);
      if (response == null) return _cancelledResponse<T>(endpoint);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
    Duration? receiveTimeoutOverride,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      _logger.debug('DELETE', context: {'path': endpoint});

      final request = _client
          .delete(uri, headers: defaultHeaders)
          .timeout(_deadline(receiveTimeoutOverride));

      final response = await _awaitCancellable(request, cancelToken, null);
      if (response == null) return _cancelledResponse<T>(endpoint);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// `package:http` espone un solo timeout complessivo: finché non c'è Dio,
  /// connect e receive si sommano in una scadenza unica.
  Duration _deadline(Duration? receiveTimeoutOverride) =>
      connectTimeout + (receiveTimeoutOverride ?? receiveTimeout);

  /// Attende [request] a meno che [cancelToken] non venga annullato prima.
  ///
  /// Ritorna `null` se la richiesta è stata annullata. Se [coalescerKey] non è
  /// nullo, l'annullamento libera anche la voce del coalescer.
  Future<http.Response?> _awaitCancellable(
    Future<http.Response> request,
    CancelToken? cancelToken,
    String? coalescerKey,
  ) {
    if (cancelToken == null) return request;

    final completer = Completer<http.Response?>();

    void releaseKey() {
      if (coalescerKey != null) _coalescer.invalidate(coalescerKey);
    }

    if (cancelToken.isCancelled) {
      releaseKey();
      // L'esito della richiesta va comunque consumato, o resta un errore
      // asincrono non gestito.
      unawaited(
        request.then<void>((_) {}, onError: (Object _, StackTrace __) {}),
      );
      return Future<http.Response?>.value(null);
    }

    request.then<void>(
      (response) {
        if (!completer.isCompleted) completer.complete(response);
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!completer.isCompleted) completer.completeError(error, stackTrace);
      },
    );

    unawaited(
      cancelToken.whenCancelled.then((_) {
        if (completer.isCompleted) return;
        releaseKey();
        completer.complete(null);
      }),
    );

    return completer.future;
  }

  ApiResponse<T> _cancelledResponse<T>(String endpoint) {
    _logger.debug('Request cancelled', context: {'path': endpoint});
    return ApiResponse.error(
      message: _cancelled.message,
      statusCode: _cancelled.code,
    );
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    // Mai il body completo: contiene dati dell'utente e in release sarebbe
    // comunque stampato. Vedi docs/development/18-observability.md.
    _logger.debug(
      'Response',
      context: {
        'status': response.statusCode,
        'bytes': response.bodyBytes.length,
      },
    );

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
    _logger.warn('Request failed', error: error);

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
