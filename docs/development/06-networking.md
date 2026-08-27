---
livello: Standard
stato: active
---

# 06 — Networking

## Quanta rete serve davvero

Con il catalogo spedito nel bundle e i dati che nascono locali, la superficie di
rete a regime è minima:

| Chiamata | Frequenza |
|---|---|
| `POST {keycloak}/token` (refresh) | alla scadenza del token |
| `GET /catalog/delta?since=N` | una volta per sessione, spesso vuota |
| `POST /sync` (batch outbox) | quando c'è qualcosa da caricare |
| `GET /exercises/{id}/media` | on demand, solo per media non in cache |
| CRUD esercizi custom | su azione utente |

Quattro famiglie. Se il numero cresce, è un segnale che qualcosa sta tornando a
leggere dalla rete ciò che dovrebbe leggere dal database.

## ADR-006 — Si adotta Dio

Oggi: `package:http` con un `AuthHttpClient` custom. Il refresh token con
deduplica è scritto bene e va conservato come comportamento.

Si passa a **Dio** per due ragioni:

1. **Cancellazione.** `package:http` non la supporta. Oggi un provider
   `autoDispose` distrutto lascia la richiesta in volo: traffico sprecato e
   risposte tardive che arrivano su uno stato che non esiste più. È una delle
   cause delle race osservate.
2. **Interceptor** come meccanismo di primo livello, invece di una sottoclasse
   di `BaseClient`.

Il momento è adesso: il data layer viene riscritto comunque, e ADR-005 dice che
non c'è retrocompatibilità da proteggere. Farlo dopo costerebbe di più.

## `ApiClient`

Dio non esce mai da `core/network/`. Sopra c'è `ApiClient`, e sopra ancora solo
data source.

```
Dio  →  ApiClient  →  <Feature>RemoteDataSource  →  <Feature>Repository
```

Contratto:

```dart
Future<Result<T, Failure>> get<T>(
  String path, {
  Map<String, dynamic>? query,
  required T Function(dynamic) decode,
  CancelToken? cancelToken,
});
```

`ApiClient` ritorna sempre `Result`. Non lancia, non espone `Response`, non
espone codici di stato: quelli diventano `Failure` tipizzati al confine.
Vedi `07-errors-and-feedback.md`.

## Coalescing

**Sempre attivo, in ogni modalità di cache.** È il pezzo mancante che il flag di
debug ha reso visibile.

```dart
// core/network/request_coalescer.dart
final _inFlight = <String, Future<Result<dynamic, Failure>>>{};
```

- chiave: `method + path + query ordinata`;
- solo su richieste **idempotenti** (GET);
- la voce si rimuove al completamento, con controllo di identità;
- vale per tutta la app, non per repository.

Questo sostituisce le mappe di deduplica ad-hoc oggi presenti in
`ExerciseInfoPageRepositoryImpl` e `WorkoutPageRepositoryImpl`, che funzionano
solo finché quei repository restano vivi.

Effetto: le quattro pagine di dettaglio esercizio che chiedono lo stesso id
producono una richiesta, non quattro.

## Cancellazione

Ogni chiamata originata da un provider `autoDispose` porta un `CancelToken`
legato al ciclo di vita del provider:

```dart
final token = CancelToken();
ref.onDispose(token.cancel);
```

Una cancellazione **non è un errore**: si mappa su `Failure.cancelled` e non
produce mai un messaggio all'utente.

## Retry

| Metodo | Retry | Condizione |
|---|---|---|
| `GET` | sì | timeout, 5xx, errore di rete. Max 2 tentativi, backoff esponenziale con jitter |
| `POST /sync` | sì | è idempotente per `Idempotency-Key` |
| `POST`/`PUT`/`DELETE` di dominio | **no** | a meno di idempotency key esplicita |

Nessun retry automatico generico sugli interceptor: il retry è una decisione per
endpoint, non una policy globale.

## Interceptor

Solo problemi trasversali, in quest'ordine:

1. **Auth** — inietta il bearer, rinnova preventivamente se in scadenza,
   rinnova su 401 e ritenta una volta. Il refresh è **coalescente**: N richieste
   concorrenti che trovano il token scaduto producono un solo refresh. Il
   comportamento attuale è corretto e va portato invariato su Dio.
2. **Request id** — `X-Request-Id` per correlare client e backend.
3. **Idempotency** — `Idempotency-Key` sulle scritture che lo prevedono.
4. **Logging** — via `AppLogger`, mai `debugPrint`.
5. **Metriche** — durata, esito, dimensione per endpoint.

Nessun interceptor contiene logica di dominio.

## Logging

Oggi `api_client.dart` ha 7 `debugPrint` non guardati che stampano **il body
completo di ogni risposta**. `debugPrint` è attivo anche in profile e release.

Regole:

- si logga solo tramite `AppLogger`;
- mai il body completo: metodo, path, stato, durata, dimensione;
- mai token, header di autorizzazione, dati personali;
- il body si logga solo in debug e solo troncato.

## Timeout

| Tipo | Valore |
|---|---|
| connect | 10 s |
| receive, chiamate normali | 20 s |
| receive, batch di sync | 60 s |
| download media | nessuno, ma cancellabile |

I 30 s uniformi attuali sono troppi per una chiamata interattiva e troppo pochi
per un batch.

## Connettività

`connectivity_plus` è un **segnale per tentare**, non un'autorità: Wi-Fi
connesso non implica Internet raggiungibile. Nessuna decisione applicativa
dipende solo da lui; l'autorità sono timeout ed esiti.

## Base URL

Da `AppConfig` (`17-config-and-flags.md`), mai da una costante letta direttamente
in una feature.
