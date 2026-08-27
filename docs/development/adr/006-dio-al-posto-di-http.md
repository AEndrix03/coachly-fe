# ADR-006 — Dio al posto di package:http

Stato: accettato
Data: 2026-08-28

## Contesto

Il client HTTP attuale è `package:http` con un `AuthHttpClient` custom che
estende `BaseClient`. La gestione del refresh token è scritta bene: refresh
preventivo, refresh su 401 con un solo replay, e deduplica delle richieste di
refresh concorrenti.

Due limiti strutturali:

1. **Nessuna cancellazione.** `package:http` non la supporta. Un provider
   `autoDispose` distrutto lascia la richiesta in volo: traffico sprecato e
   risposta tardiva che arriva su uno stato che non esiste più. È una delle cause
   delle race osservate quando la latenza aumenta.

2. **Gli interceptor sono una sottoclasse.** Aggiungere request-id, idempotency
   key, metriche e logging significa accumulare responsabilità dentro
   `AuthHttpClient`, che già fa auth e replay.

## Decisione

Si adotta **Dio**, confinato in `core/network/`. Non esce mai da lì: sopra c'è
`ApiClient`, che ritorna `Result<T, Failure>`.

Il comportamento del refresh coalescente viene portato invariato su un
interceptor: è logica corretta e testata, cambia il meccanismo non la semantica.

Il momento è **adesso**, durante la Fase 2 della migrazione: il data layer viene
riscritto comunque e ADR-005 dice che non c'è retrocompatibilità da proteggere.
Farlo dopo costerebbe di più a parità di beneficio.

## Conseguenze

- Cancellazione disponibile: ogni chiamata da un provider `autoDispose` porta un
  `CancelToken` legato al suo ciclo di vita.
- `CancelledFailure` diventa un esito di primo livello, e non produce mai un
  messaggio all'utente.
- Gli interceptor diventano moduli separati e testabili singolarmente.
- Una dipendenza in più, ma `package:http` esce.
- Rischio: reintrodurre un bug nel refresh token, che è la parte più delicata.
  Mitigazione: test dedicati sul refresh concorrente **prima** della sostituzione.

## Alternative scartate

**Restare su `package:http`.** Non c'è modo di ottenere la cancellazione, che è
la ragione principale del cambio.

**Aggiungere la cancellazione a mano** con un flag che scarta la risposta. Non
risparmia traffico — la richiesta parte e arriva comunque — e risolve solo metà
del problema.

**Rimandare a dopo la migrazione a Drift.** Significherebbe riscrivere i data
source due volte.
