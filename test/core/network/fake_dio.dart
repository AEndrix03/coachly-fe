import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Risposta canned di [FakeDioAdapter].
class FakeResponse {
  const FakeResponse(this.statusCode, this.body, {this.headers = _json});

  /// Senza content-type Dio non decodifica il body e lo consegna come
  /// `String`: il test fallirebbe su un cast, non sul comportamento.
  ///
  /// Il charset e' esplicito perche' il backend risponde in UTF-8: senza, i
  /// payload con `•` o accenti si decodificano in latin1 e arrivano corrotti.
  static const _json = <String, List<String>>{
    Headers.contentTypeHeader: ['application/json; charset=utf-8'],
  };

  const FakeResponse.ok([String body = '']) : this(200, body);

  /// Ordine (body, stato) come `http.Response`, per non riscrivere ogni
  /// responder dei test durante la migrazione ad ADR-006.
  const FakeResponse.body(this.body, this.statusCode, {this.headers = _json});

  final int statusCode;
  final String body;
  final Map<String, List<String>> headers;
}

/// Adapter Dio che registra le richieste e risponde con quello che gli dici.
///
/// Sostituisce i quattro `_RecordingHttpClient`/`_PendingClient` che ogni test
/// di rete si era scritto per conto suo: erano quattro implementazioni della
/// stessa cosa, e quando `ApiClient` è passato a Dio (ADR-006) andavano
/// riscritte tutte e quattro.
///
/// L'adapter sta **sotto** gli interceptor: un test che usa questo verifica
/// `ApiClient`, non la catena di autenticazione.
class FakeDioAdapter implements HttpClientAdapter {
  FakeDioAdapter({FakeResponse Function(RequestOptions request)? responder})
    : _responder = responder ?? ((_) => const FakeResponse.ok());

  final FakeResponse Function(RequestOptions request) _responder;

  /// Ogni richiesta arrivata, in ordine.
  final List<RequestOptions> requests = <RequestOptions>[];

  /// Body serializzato dell'ultima richiesta, se ne aveva uno.
  String? lastBody;

  /// Richieste in sospeso per percorso, per i test sul coalescing.
  final Map<String, Completer<FakeResponse>> _pending = {};

  /// Se `true`, ogni richiesta resta appesa finché non chiami [complete].
  bool holdRequests = false;

  RequestOptions? get lastRequest => requests.isEmpty ? null : requests.last;

  int get callCount => requests.length;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    lastBody = switch (options.data) {
      null => null,
      final String raw => raw,
      final Object data => jsonEncode(data),
    };

    if (cancelFuture != null) {
      // Un adapter vero interrompe il socket quando il token viene annullato.
      // Se il fake ignorasse `cancelFuture`, il test sulla cancellazione
      // verificherebbe soltanto che il fake non la implementa.
      var cancelled = false;
      unawaited(cancelFuture.then((_) => cancelled = true));
      final result = await Future.any<Object?>([
        _resolve(options),
        cancelFuture.then((_) => null),
      ]);
      if (cancelled || result == null) {
        throw DioException.requestCancelled(
          requestOptions: options,
          reason: 'cancelled',
        );
      }
      final response = result as FakeResponse;
      return ResponseBody.fromString(
        response.body,
        response.statusCode,
        headers: response.headers,
      );
    }

    final response = holdRequests
        ? await _pending
              // Chiave sul path completo, baseUrl inclusa: e' quello che il
              // test conosce, `options.path` e' solo il pezzo relativo.
              .putIfAbsent(options.uri.path, Completer<FakeResponse>.new)
              .future
        : _responder(options);

    return ResponseBody.fromString(
      response.body,
      response.statusCode,
      headers: response.headers,
    );
  }

  Future<FakeResponse> _resolve(RequestOptions options) async => holdRequests
      ? _pending
            .putIfAbsent(options.uri.path, Completer<FakeResponse>.new)
            .future
      : _responder(options);

  /// Rilascia una richiesta tenuta in sospeso da [holdRequests].
  ///
  /// Il completer resta nella mappa anche dopo: una richiesta che arriva
  /// **dopo** la `complete` deve trovare la risposta gia' pronta, non
  /// crearne una nuova e restare appesa per sempre. E' il caso normale,
  /// perche' fra la chiamata del test e l'arrivo all'adapter c'e' l'intera
  /// catena asincrona di Dio.
  void complete(String path, String body, {int statusCode = 200}) {
    final completer = _pending.putIfAbsent(path, Completer<FakeResponse>.new);
    if (!completer.isCompleted) {
      completer.complete(FakeResponse(statusCode, body));
    }
  }

  @override
  void close({bool force = false}) {}
}

/// Un [Dio] cablato su [adapter], senza interceptor.
Dio fakeDio(FakeDioAdapter adapter) => Dio()..httpClientAdapter = adapter;
