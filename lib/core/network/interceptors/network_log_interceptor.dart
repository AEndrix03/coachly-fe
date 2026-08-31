import 'package:coachly/core/logging/app_logger.dart';
import 'package:dio/dio.dart';

/// Rende visibile ogni chiamata HTTP: metodo, indirizzo, esito, durata.
///
/// Prima di questo file la app non ne registrava **nessuna**. Non è un difetto
/// di comodità: è la ragione per cui una diagnosi diventa una discussione di
/// opinioni. «Gli esercizi non si caricano e non vedo chiamate al backend» ha
/// tre cause possibili — la chiamata non parte, parte e fallisce, parte e
/// risponde vuoto — e senza log sono indistinguibili dall'esterno.
///
/// `docs/development/18-observability.md`: il canale unico è `AppLogger`,
/// `print` e `debugPrint` non si usano.
///
/// **Cosa non finisce nel log.** Gli header non vengono mai scritti: il primo
/// header interessante di questa app è `Authorization`, e un token nei log è
/// un token trapelato (`docs/development/24-security-and-privacy.md`). Il
/// corpo della risposta viene riassunto — tipo e dimensione, o il numero di
/// elementi se è una lista — non riversato: è il dato che serve a capire
/// «zero, uno o duecento esercizi?», che è la domanda vera, senza spedire i
/// dati di allenamento di una persona nella console.
class NetworkLogInterceptor extends Interceptor {
  NetworkLogInterceptor(this._logger, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppLogger _logger;

  /// Iniettabile per i test. Non passa da `Clock` di proposito: qui serve solo
  /// a misurare una durata, non a decidere niente.
  // ignore: no_raw_datetime_now
  final DateTime Function() _now;

  static const _startKey = 'coachly.log.start';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = _now();
    _logger.info('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.info(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}',
      context: {
        'ms': _elapsedMs(response.requestOptions),
        'body': _summarize(response.data),
      },
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    // `warn`, non `error`: una richiesta fallita mentre l'utente e' offline e'
    // il funzionamento normale di una app local-first, non un guasto
    // (`docs/development/05-sync-and-offline.md`).
    _logger.warn(
      '× ${err.response?.statusCode ?? err.type.name} '
      '${options.method} ${options.uri}',
      context: {
        'ms': _elapsedMs(options),
        if (err.response?.data != null) 'body': _summarize(err.response!.data),
      },
      error: err.message,
    );
    handler.next(err);
  }

  int? _elapsedMs(RequestOptions options) {
    final start = options.extra[_startKey];
    if (start is! DateTime) return null;
    return _now().difference(start).inMilliseconds;
  }

  /// Il minimo che risponde alla domanda «quanti ne sono arrivati?».
  static String _summarize(Object? data) => switch (data) {
    null => 'null',
    final List<Object?> list => 'List(${list.length})',
    final Map<Object?, Object?> map => 'Map(${map.length} keys)',
    final String text => 'String(${text.length} chars)',
    _ => data.runtimeType.toString(),
  };
}
