import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sorgente del tempo iniettabile.
///
/// Vedi `docs/development/19-testing.md`: `DateTime.now()` sparso nel codice
/// rende impossibile testare streak, conteggi settimanali e backoff. Ogni
/// lettura del tempo passa da qui, e il lint `no_raw_datetime_now` lo impone.
abstract interface class Clock {
  /// Istante corrente nel fuso orario locale del dispositivo.
  DateTime now();

  /// Istante corrente in UTC: l'unica forma che si persiste o si spedisce.
  DateTime nowUtc();
}

/// Implementazione di produzione: legge l'orologio di sistema.
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

/// Implementazione per i test: il tempo non scorre se non lo si muove.
///
/// Permette di scrivere i casi che oggi non sono testabili: allenamento a
/// cavallo della mezzanotte, cambio di fuso orario, ora legale, streak
/// interrotto.
class FixedClock implements Clock {
  FixedClock(this._instant);

  DateTime _instant;

  /// Istante attualmente restituito, nella forma con cui è stato impostato.
  DateTime get instant => _instant;

  /// Sposta l'orologio a un istante preciso.
  void setTo(DateTime instant) => _instant = instant;

  /// Fa avanzare l'orologio di [duration].
  void advance(Duration duration) => _instant = _instant.add(duration);

  @override
  DateTime now() => _instant.isUtc ? _instant.toLocal() : _instant;

  @override
  DateTime nowUtc() => _instant.toUtc();
}

/// `keepAlive`: l'orologio è un singleton di processo, non ha stato da liberare.
/// In Riverpod 3 un `Provider` non generato è già keepAlive per costruzione.
final clockProvider = Provider<Clock>((ref) => const SystemClock());
