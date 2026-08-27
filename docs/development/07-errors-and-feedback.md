---
livello: Standard
stato: active
---

# 07 — Errori e feedback all'utente

## Il problema che risolve

Oggi coesistono due modelli di errore incompatibili: lo stack Hive ritorna
`ApiResponse.error` e non lancia mai; lo stack view **lancia `StateError`**.
E `AppToastService._show` fa `hideCurrentSnackBar()` seguito da `showSnackBar()`
sul messenger globale: due errori concorrenti producono lo sfarfallio osservato.

Le due cose insieme sono la causa degli overlay sovrapposti.

## Un solo tipo di ritorno

```dart
sealed class Result<T, F> { … }
final class Ok<T, F> extends Result<T, F> { final T value; }
final class Err<T, F> extends Result<T, F> { final F failure; }
```

Ogni metodo pubblico di repository e `ApiClient` ritorna `Result<T, Failure>`.
Nessuna eccezione attraversa il confine del data layer: le eccezioni tecniche si
convertono **lì**, dove si hanno le informazioni per farlo.

## Tassonomia dei Failure

```dart
sealed class Failure {
  const Failure();
}

// rete e trasporto
final class NetworkFailure    extends Failure {}   // irraggiungibile, timeout
final class ServerFailure     extends Failure {}   // 5xx
final class CancelledFailure  extends Failure {}   // richiesta annullata

// semantica
final class UnauthorizedFailure extends Failure {} // 401/403
final class NotFoundFailure     extends Failure {}
final class ValidationFailure   extends Failure {} // 422, con campi
final class ConflictFailure     extends Failure {} // 409

// locale
final class StorageFailure       extends Failure {} // Drift, filesystem
final class NotAvailableOffline  extends Failure {} // serve rete, non c'è

// residuo
final class UnexpectedFailure    extends Failure {} // con causa e stack
```

Regole:

- `CancelledFailure` **non è un errore**: non si mostra, non si logga come tale.
- `UnexpectedFailure` è l'unico che si riporta al crash reporter.
- Un `Failure` non contiene testo per l'utente. Il messaggio si costruisce nella
  presentazione, tradotto (`13-i18n.md`).

## Le letture non fanno toast

La regola che elimina gli overlay:

| Origine dell'errore | Come si mostra |
|---|---|
| **Lettura** (un provider che carica dati) | stato **inline** nella pagina: `ErrorState` con retry |
| **Azione utente** (salva, elimina, vota) | **toast**, perché l'utente ha appena fatto qualcosa e aspetta un esito |
| **Background** (sync, delta catalogo) | **silenzioso**, al massimo un indicatore di stato |

Un errore di lettura non produce mai un toast. Una schermata che non riesce a
caricare mostra sé stessa in stato di errore: è più chiaro, è dove l'utente sta
guardando, e non può sovrapporsi ad altri sei.

Corollario: `AppToastService` non accetta un `Failure`. Accetta l'esito di
un'azione. Se il tipo non lo permette, la regola si autoimpone.

## Mutations come meccanismo

Riverpod 3 espone nativamente il ciclo di vita di un'azione:

```dart
@mutation
Future<void> deleteWorkout(String id) async { … }
```

La UI osserva `Idle / Pending / Success / Error` e ha così l'informazione che
serve per distinguere i due casi: `Error` su una mutation → toast; `AsyncError`
su una lettura → stato inline. La distinzione è nel tipo, non nella disciplina di
chi scrive il codice.

## Coda dei toast

Anche rispettando la regola, due azioni possono fallire vicine.

- I toast si **accodano**, non si sostituiscono.
- Deduplica per chiave: lo stesso errore ripetuto entro 3 s non si ripete.
- Massimo un toast visibile; gli altri aspettano.
- Durata: 3 s informativi, 4 s errori, indefinita se c'è un'azione (Annulla).

## Matrice degli stati

Ogni schermata che carica dati dichiara **cinque** stati. Sono componenti del
design system, non widget locali.

| Stato | Componente | Quando |
|---|---|---|
| Loading | `CoachlySkeleton` | primo caricamento, nessun dato |
| Empty | `CoachlyEmptyState` | caricato, zero elementi |
| Error | `CoachlyErrorState` | fallito, nessun dato in cache |
| Offline | `CoachlyOfflineBanner` | serve rete, non c'è |
| Stale | indicatore discreto | dati locali mostrati, refresh fallito |

Con il local-first, **Loading e Error sono rari**: i dati sono già sul
dispositivo. Se compaiono spesso, è il sintomo che qualcosa legge dalla rete
quando non dovrebbe.

Lo stato `Stale` non è un errore: mostrare dati leggermente vecchi è il
comportamento corretto, e l'utente va informato senza essere interrotto.

## Azioni distruttive

Eliminare un workout o una sessione: **undo, non conferma**.

L'operazione si esegue subito (soft delete con `deleted_at`), il toast offre
"Annulla" per 5 secondi, la riga di outbox parte alla scadenza. È più veloce, più
rispettoso e reversibile davvero.

I dialog di conferma si riservano a ciò che non è annullabile: logout con outbox
non vuota, cancellazione account.

## Crash e errori non gestiti

```dart
runZonedGuarded(() {
  FlutterError.onError = reporter.recordFlutterError;
  PlatformDispatcher.instance.onError = reporter.recordError;
  runApp(...);
}, reporter.recordError);
```

Un `UnexpectedFailure` si riporta con: `requestId`, `operationId`, feature,
versione, ambiente. Mai con dati di allenamento o dati personali.
Vedi `18-observability.md` e `24-security-and-privacy.md`.
