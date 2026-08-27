---
livello: Standard
stato: active
---

# 22 — Eventi e analytics

## Perché è un documento di prodotto

Lo scopo dichiarato del backend è **capire come si allenano le persone**. Lo
schema degli eventi non è telemetria tecnica: è il prodotto. Merita lo stesso
rigore di uno schema di database, versionamento incluso.

Distinzione netta rispetto a `18-observability.md`: lì si diagnostica la app,
qui si osserva il comportamento. I due canali non si mescolano.

## Le due sorgenti

| Sorgente | Cosa | Canale |
|---|---|---|
| **Eventi di sessione** | ciò che accade durante un allenamento | tabella `session_events`, outbox |
| **Eventi di prodotto** | come si naviga la app | tracker analytics |

I primi sono **dati dell'utente**: durevoli, insostituibili, sincronizzati con
garanzia. I secondi sono telemetria: se se ne perde qualcuno, non è un problema.
Non vanno confusi né trattati allo stesso modo.

## Eventi di sessione

Il dataset che conta. Append-only, con `seq` per sessione, mai modificati.

| Evento | Payload |
|---|---|
| `session_started` | `workoutId`, `startedAt` |
| `set_completed` | `entryId`, `setIndex`, `reps`, `load`, `loadUnit`, `rir`, `durationMs` |
| `set_skipped` | `entryId`, `setIndex`, `reason?` |
| `load_changed` | `entryId`, `setIndex`, `from`, `to`, `phase` (pre/durante) |
| `reps_changed` | `entryId`, `setIndex`, `from`, `to` |
| `exercise_substituted` | `fromExerciseId`, `toExerciseId`, `reason?` |
| `rest_started` / `rest_ended` | `entryId`, `plannedSec`, `actualSec` |
| `session_paused` / `session_resumed` | `at` |
| `session_completed` | `completedAt`, `totalSets`, `totalVolume` |
| `note_added` | `scope`, `text` |

Il valore sta nel **processo**, non nel risultato: `load_changed`,
`exercise_substituted` e la differenza fra `plannedSec` e `actualSec` dicono come
qualcuno si allena davvero. Lo stato finale non lo direbbe.

Per questo lo stato di una sessione è una proiezione degli eventi e non una
tabella autoritativa (`04-data-layer.md`).

### Motivazioni

`reason` su sostituzione e serie saltata è un enum, non testo libero:
`machine_busy`, `pain`, `too_heavy`, `too_light`, `no_time`, `other`. Un enum si
aggrega; il testo libero no.

## Eventi di prodotto

Naming: `<oggetto>_<verbo al passato>`, snake_case.

```
workout_created        workout_started       workout_completed
exercise_searched      exercise_viewed       exercise_favorited
program_assigned       library_filtered      media_played
onboarding_completed   settings_changed
```

Vietato: `click_button`, `page_view_3`, nomi che descrivono la UI invece
dell'intenzione. La UI cambia, l'intenzione no.

## Registro

Un unico file `core/analytics/events.dart` con enum tipizzata e payload
dichiarato. Nessun evento inviato con una stringa scritta a mano.

```dart
sealed class AnalyticsEvent {
  String get name;
  Map<String, Object?> get parameters;
}
```

Un evento non presente nel registro non è inviabile. È il meccanismo che
impedisce la deriva a cui tutti i sistemi di analytics tendono.

## Versionamento

Ogni evento ha una `schemaVersion`. Cambiare il significato di un campo esistente
è vietato: si aggiunge un campo nuovo o un evento nuovo.

I dati storici non si possono reinterpretare a posteriori — è la ragione per cui
questo vincolo è più stretto di quanto sembri necessario oggi.

## Coda locale e batch

Gli eventi di prodotto seguono lo stesso modello dell'outbox: coda locale, invio
in batch, nessuna richiesta di rete per evento. Su una connessione da palestra
non si manda una richiesta per ogni tap.

Politica di potatura: gli eventi di prodotto più vecchi di 30 giorni e non
inviati si scartano. Gli eventi di sessione **non si scartano mai**.

## Privacy

| Regola | |
|---|---|
| Nessun dato personale nei parametri | né email, né nome, né identificativi in chiaro |
| Nessun testo libero dell'utente | note e nomi di scheda restano locali |
| Identificativo pseudonimo | non l'id account in chiaro |
| Consenso richiesto per gli eventi di prodotto | vedi `24-security-and-privacy.md` |

Gli **eventi di sessione non sono analytics**: sono dati dell'utente, coperti dal
contratto di servizio e dal diritto di export e cancellazione, non dal consenso
alla telemetria. La distinzione è giuridicamente rilevante e va mantenuta anche
nel codice.

## Test

- ogni evento del registro ha un test che ne verifica nome e parametri;
- un test verifica che nessun payload contenga chiavi in una denylist
  (`email`, `name`, `note`, `title`);
- un test verifica che gli eventi di sessione siano contigui in `seq`.
