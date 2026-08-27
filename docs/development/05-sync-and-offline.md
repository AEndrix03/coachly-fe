---
livello: Costituzione
stato: active
---

# 05 — Sync e offline

## Cosa fa il backend, davvero

È controintuitivo e va scritto, perché tutta l'architettura discende da qui.

| Dominio | Ruolo del BE oggi | Ruolo domani |
|---|---|---|
| Catalogo esercizi | genera il bundle e i delta | uguale |
| Esercizi custom | backup, non condivisione | condivisione |
| Workout e sessioni | **raccolta dati** | base per la vista Coach |
| Utente | anagrafica minima | community, coach |

Il backend **non serve a far funzionare la app**. Serve a non perdere i dati e a
capire come si allenano le persone. Coachly funziona interamente offline, e
questo non è un fallback: è la modalità normale.

Conseguenza operativa: la sync non ha requisiti di latenza. Può ritardare di
giorni senza che l'esperienza peggiori.

## Il modello: outbox append-only

```
azione utente
     │
     ▼
┌──────────────────── una transazione ────────────────────┐
│  UPDATE/INSERT sui dati                                  │
│  INSERT in outbox(entity, operation, payload, id)        │
└──────────────────────────────────────────────────────────┘
     │
     ▼
UI aggiornata (stream Drift)          ← finisce qui, per l'utente
     │
     ▼
SyncUploader, quando gli pare
     │
     ▼
POST /sync  con Idempotency-Key
     │
     ▼
outbox.status = sent
```

L'utente non aspetta mai il secondo blocco. Non c'è spinner, non c'è "salvataggio
in corso", non c'è errore di rete durante un allenamento.

## Il client vince sempre

Non c'è conflict resolution perché non c'è conflitto: il server riceve solo ciò
che il client produce e non lo modifica.

Questo elimina dall'architettura:

- `ConflictResolver`
- stati `CONFLICT` e `REJECTED`
- merge a tre vie, vector clock, last-write-wins
- la lettura di ritorno dopo una scrittura

Gli stati reali dell'outbox sono quattro:

| Stato | Significato |
|---|---|
| `pending` | in attesa di essere inviato |
| `sending` | invio in corso |
| `sent` | confermato dal server, la riga può essere potata |
| `failed_permanent` | 4xx non recuperabile: si logga, non si ritenta, **non si perde il dato locale** |

Un `failed_permanent` non cancella mai nulla: il dato dell'utente resta sul
dispositivo ed è visibile nella app. Il fallimento riguarda la telemetria, non
l'utente.

> **Quando questo cambierà.** Nel momento in cui un coach assegna una scheda,
> quelle righe (`workouts.origin = 'assigned'`) sono scritte dal server e il
> client non può vincerci sopra. Il confine è già nello schema; quando arriverà,
> questo documento va esteso con una sezione sul percorso discendente, non
> riscritto.

## Idempotenza

Ogni riga di outbox ha un `id` UUID v4 generato dal client, che viaggia come
`Idempotency-Key`. Un reinvio dopo un timeout ambiguo è sicuro per costruzione.

Gli id si generano **solo** tramite `core/ids`. Oggi il codice ha un
`_generateUuidV4()` scritto a mano con `Random.secure()` dentro un repository,
mentre il pacchetto `uuid` è già una dipendenza: è esattamente il tipo di
duplicazione che questa architettura elimina.

## Quando parte la sync

| Trigger | Condizione |
|---|---|
| App va in foreground | autenticato, outbox non vuota |
| Sessione completata | sempre, opportunisticamente |
| Connettività ripristinata | outbox non vuota |
| Retry programmato | backoff esponenziale con jitter, 5s → 15min |

**Non serve background sync a livello di sistema operativo.** Niente WorkManager,
niente BGTaskScheduler. La sync avviene quando la app è in esecuzione, e questo è
sufficiente perché non c'è urgenza.

`connectivity_plus` è un **segnale per tentare**, mai un'autorità su cosa sia
possibile: Wi-Fi connesso non implica Internet raggiungibile. L'autorità sono
timeout ed esiti HTTP.

## Batching

Gli eventi salgono in batch, non uno per uno. Un allenamento da 40 serie produce
una richiesta, non quaranta.

- dimensione massima batch: 500 eventi o 1 MB, quale viene prima;
- ordine FIFO per sessione, garantito da `seq`;
- un batch fallito si ritenta interamente: essendo idempotente, non c'è rischio
  di duplicazione.

## Cosa non fa la sync

- **Non scarica dati utente.** Il dispositivo è l'autore; non esiste "scarica i
  miei workout dal server" nella v1. Quando servirà (nuovo dispositivo), sarà un
  percorso di restore esplicito, non un sync continuo.
- **Non rinfresca il catalogo.** Quello è il canale delta di `04-data-layer`,
  separato e con regole diverse.
- **Non blocca mai la UI.**

## Modalità di cache per il debug

Il flag attuale disattiva globalmente il layer locale, mettendo la app in uno
stato che in produzione non esiste mai: ogni lettura va in rete, per sempre.
Quello stato **genera** i sintomi che dovrebbe diagnosticare — richieste
concorrenti duplicate, errori sovrapposti.

Sostituito da un controllo dello **stato** della cache, non della sua esistenza:

| `--dart-define=CACHE_MODE=` | Comportamento | Serve a |
|---|---|---|
| `warm` (default) | normale | produzione |
| `cold` | svuota il DB locale all'avvio, poi normale | simulare la prima installazione |
| `no-seed` | ignora l'asset del catalogo, forza il download | verificare il fallback |

In tutte e tre le modalità il layer locale resta attivo, il coalescing resta
attivo, e le transizioni sono transitorie come in produzione.

## Osservabilità

Serve una debug screen interna (`18-observability.md`) che mostri:

- righe in outbox per stato, con l'ultimo errore;
- `catalog_version` e data dell'ultimo delta;
- `schemaVersion` del DB;
- `CACHE_MODE` e l'intera `AppConfig` attiva.

In un'app local-first i bug vivono nel database e nella coda sul telefono
dell'utente, dove Crashlytics non arriva.

## Riferimenti

- [Flutter — Offline-first support](https://docs.flutter.dev/app-architecture/design-patterns/offline-first)
- [connectivity_plus — la connettività non implica raggiungibilità](https://pub.dev/documentation/connectivity_plus/latest/)
