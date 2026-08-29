import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ciò che il resto della app ha bisogno di sapere sulla coda di caricamento,
/// **senza dipendere dalla feature che la implementa**.
///
/// Nasce da un accoppiamento reale: la guardia del logout deve sapere quanti
/// allenamenti non sono ancora saliti, ma `auth` non ha ragione di conoscere
/// `workout`. Farla passare dal repository dei workout trascinava dentro
/// l'intero stack di rete — al punto che il test della guardia non partiva più
/// senza il grafo completo della app.
///
/// L'outbox è comunque un concetto trasversale: ci finiscono sessioni, schede
/// ed esercizi personali (`docs/development/05-sync-and-offline.md`).
abstract interface class SyncQueue {
  /// Quante scritture dell'utente non sono ancora state accettate dal backend.
  ///
  /// Il logout cancella il database locale: con la coda non vuota, quei dati
  /// sono l'unica copia esistente
  /// (`docs/development/24-security-and-privacy.md`).
  Future<int> pendingCount();
}

/// Va sovrascritto in `app/`: `core/` dichiara l'interfaccia, la feature la
/// implementa, il livello `app/` le collega
/// (`docs/development/01-principles.md`).
final syncQueueProvider = Provider<SyncQueue>((ref) {
  throw UnimplementedError(
    'syncQueueProvider va sovrascritto nel ProviderScope della app. '
    'Vedi lib/app/bootstrap/provider_overrides.dart.',
  );
});
