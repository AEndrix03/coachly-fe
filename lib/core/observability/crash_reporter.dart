import 'package:coachly/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Il canale degli errori non gestiti (`docs/development/18-observability.md`).
///
/// L'interfaccia esiste prima del servizio che la consumerà: quando arriverà
/// Crashlytics o Sentry si sostituisce un'implementazione, non si va a cercare
/// i `try/catch` sparsi.
abstract interface class CrashReporter {
  void reportError(Object error, StackTrace? stackTrace, {String? context});
}

class LoggingCrashReporter implements CrashReporter {
  const LoggingCrashReporter(this._logger);

  final AppLogger _logger;

  @override
  void reportError(Object error, StackTrace? stackTrace, {String? context}) {
    _logger.error(
      context ?? 'Errore non gestito',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => LoggingCrashReporter(ref.watch(appLoggerProvider)),
);

/// Installa le tre trappole che coprono tutto ciò che può fallire.
///
/// Senza questa funzione un errore fuori dal frame di build finisce nella
/// console del dispositivo e da nessun'altra parte. Va chiamata da
/// `main()` prima di `runApp`.
void installErrorHandlers(CrashReporter reporter) {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    reporter.reportError(
      details.exception,
      details.stack,
      context: details.context?.toString() ?? 'FlutterError',
    );
    previous?.call(details);
  };

  // Errori asincroni che non attraversano il framework (isolate, callback di
  // plugin): senza questo restano invisibili.
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.reportError(error, stack, context: 'PlatformDispatcher');
    return true;
  };
}
