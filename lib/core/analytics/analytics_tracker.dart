import 'package:coachly/core/analytics/analytics_event.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Il canale degli eventi di prodotto (`docs/development/22-analytics-events.md`).
///
/// L'interfaccia esiste **prima** del backend che la consuma, per la stessa
/// ragione per cui `programs` è nello schema pur essendo vuota: il confine va
/// dichiarato prima che serva, altrimenti quando serve viene attraversato in
/// dieci punti diversi.
abstract interface class AnalyticsTracker {
  void track(AnalyticsEvent event, {Map<String, Object?> properties});
}

/// Implementazione attuale: scrive nel log e non spedisce niente.
///
/// Non è un placeholder da sostituire in fretta. Finché non c'è un consenso
/// esplicito dell'utente (`24-security-and-privacy.md`, punto 6.4 del piano di
/// migrazione), *non spedire* è il comportamento corretto.
class LoggingAnalyticsTracker implements AnalyticsTracker {
  const LoggingAnalyticsTracker(this._logger);

  final AppLogger _logger;

  @override
  void track(
    AnalyticsEvent event, {
    Map<String, Object?> properties = const {},
  }) {
    _logger.debug('analytics ${event.name} $properties');
  }
}

final analyticsTrackerProvider = Provider<AnalyticsTracker>(
  (ref) => LoggingAnalyticsTracker(ref.watch(appLoggerProvider)),
);
