import 'dart:async';

/// Deduplica delle richieste in volo.
///
/// Vedi `docs/development/06-networking.md`, sezione "Coalescing".
///
/// Il problema che risolve: le quattro pagine di dettaglio esercizio chiedono
/// lo stesso id nello stesso istante e oggi producono quattro richieste. Le
/// mappe di deduplica ad-hoc presenti nei repository funzionano solo finché
/// quei repository restano vivi: la deduplica appartiene alla app, non a un
/// repository.
///
/// Regole:
/// - chiave: `method + path + query ordinata`;
/// - **solo richieste idempotenti** (GET). Chi coalescerebbe una POST
///   perderebbe una scrittura;
/// - la voce si rimuove al completamento, con controllo di identità: una voce
///   sostituita nel frattempo non viene mai rimossa da un completamento vecchio;
/// - è **sempre attivo**, in ogni modalità di cache.
///
/// La coalescenza avviene a livello di trasporto (la risposta grezza), non
/// sull'oggetto decodificato: due chiamanti che chiedono lo stesso path con
/// due decodifiche diverse condividono la richiesta e decodificano ciascuno
/// per conto proprio.
class RequestCoalescer {
  final Map<String, Future<Object?>> _inFlight = <String, Future<Object?>>{};

  /// Chiave canonica: metodo, path e query **ordinata per nome**, così che
  /// `?a=1&b=2` e `?b=2&a=1` siano la stessa richiesta.
  static String keyFor(
    String method,
    String path, [
    Map<String, String>? query,
  ]) {
    final buffer = StringBuffer('${method.toUpperCase()} $path');
    if (query != null && query.isNotEmpty) {
      final names = query.keys.toList()..sort();
      buffer.write('?');
      buffer.write(names.map((name) => '$name=${query[name]}').join('&'));
    }
    return buffer.toString();
  }

  /// Numero di richieste attualmente in volo. Solo per test e diagnostica.
  int get inFlightCount => _inFlight.length;

  /// Esegue [action] a meno che una richiesta con la stessa [key] non sia già
  /// in volo: in quel caso ne restituisce il risultato condiviso.
  Future<T> run<T>(String key, Future<T> Function() action) {
    final existing = _inFlight[key];
    if (existing != null) {
      return existing.then((value) => value as T);
    }

    final future = Future<T>(action);
    _inFlight[key] = future;

    // L'errore viene assorbito qui solo per non generare un unhandled error
    // sul ramo di pulizia: chi ha chiamato `run` riceve comunque il fallimento
    // dal future restituito.
    unawaited(
      future
          .then<void>((_) {}, onError: (Object _, StackTrace __) {})
          .whenComplete(() => _release(key, future)),
    );

    return future;
  }

  /// Rimuove la voce [key] senza attenderne il completamento.
  ///
  /// Serve alla cancellazione: chi ha annullato scarta la risposta, e la voce
  /// non deve restare a beneficio di chi arriva dopo. Chi sta già aspettando
  /// quella stessa voce continua a riceverne il risultato: la rimozione
  /// riguarda solo i chiamanti futuri.
  void invalidate(String key) => _inFlight.remove(key);

  void _release(String key, Object? owner) {
    final current = _inFlight[key];
    if (current != null && identical(current, owner)) {
      _inFlight.remove(key);
    }
  }
}
