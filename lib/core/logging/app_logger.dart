import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Unico canale di logging della app.
///
/// Vedi `docs/development/18-observability.md`. `print` e `debugPrint` non si
/// usano: `debugPrint` resta attivo anche in profile e release, e il codice
/// precedente lo usava per stampare il body completo di ogni risposta HTTP.
///
/// Non si loggano mai: token, header di autorizzazione, dati personali,
/// contenuto degli allenamenti.
abstract interface class AppLogger {
  void debug(String message, {Map<String, Object?>? context});

  void info(String message, {Map<String, Object?>? context});

  void warn(
    String message, {
    Map<String, Object?>? context,
    Object? error,
  });

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  });
}

final appLoggerProvider = Provider<AppLogger>((ref) => const ConsoleAppLogger());

/// Implementazione di partenza: scrive su console solo in debug.
///
/// In release i livelli `warn` ed `error` andranno inoltrati al crash reporter
/// (`docs/development/18-observability.md`), che non è ancora collegato.
class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger();

  @override
  void debug(String message, {Map<String, Object?>? context}) =>
      _write('DEBUG', message, context);

  @override
  void info(String message, {Map<String, Object?>? context}) =>
      _write('INFO', message, context);

  @override
  void warn(String message, {Map<String, Object?>? context, Object? error}) =>
      _write('WARN', message, context, error);

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    _write('ERROR', message, context, error);
    if (kDebugMode && stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  void _write(
    String level,
    String message,
    Map<String, Object?>? context, [
    Object? error,
  ]) {
    if (!kDebugMode) return;

    final buffer = StringBuffer('[$level] $message');
    if (context != null && context.isNotEmpty) {
      buffer.write(' ');
      buffer.write(
        context.entries.map((entry) => '${entry.key}=${entry.value}').join(' '),
      );
    }
    if (error != null) {
      buffer.write(' error=$error');
    }
    debugPrint(buffer.toString());
  }
}

/// Logger inerte per i test: non produce output.
class SilentAppLogger implements AppLogger {
  const SilentAppLogger();

  @override
  void debug(String message, {Map<String, Object?>? context}) {}

  @override
  void info(String message, {Map<String, Object?>? context}) {}

  @override
  void warn(String message, {Map<String, Object?>? context, Object? error}) {}

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {}
}
