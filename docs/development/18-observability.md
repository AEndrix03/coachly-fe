---
livello: Standard
stato: active
---

# 18 — Osservabilità

In un'app local-first i bug vivono nel database e nella coda di sync **sul
telefono dell'utente**, dove nessun servizio di crash reporting arriva.
L'osservabilità ha quindi due metà, e quella locale è la più trascurata.

## Logging

Un solo `AppLogger`. Nessun `print`, nessun `debugPrint`, nessun logger di
feature.

```dart
abstract interface class AppLogger {
  void debug(String message, {Map<String, Object?>? context});
  void info(String message, {Map<String, Object?>? context});
  void warn(String message, {Map<String, Object?>? context, Object? error});
  void error(String message, {Object? error, StackTrace? stackTrace,
                              Map<String, Object?>? context});
}
```

| Livello | Uso | In release |
|---|---|---|
| `debug` | diagnostica di sviluppo | rimosso |
| `info` | eventi di ciclo di vita | sì |
| `warn` | anomalie recuperate | sì |
| `error` | fallimenti inattesi | sì, al crash reporter |

Contesto standard su ogni riga: `requestId`, `operationId`, `feature`,
`appVersion`, `environment`, `schemaVersion`.

### Cosa non si logga, mai

- token, refresh token, header di autorizzazione;
- email, nome, identificativi utente in chiaro;
- **contenuto degli allenamenti**: carichi, ripetizioni, note personali.

I dati di allenamento sono health-adjacent. Nel log ci va che una sessione è
stata sincronizzata, non cosa contiene.

Oggi `api_client.dart` stampa il body completo di ogni risposta con un
`debugPrint` non guardato, attivo anche in profile e release. È la prima cosa da
rimuovere.

## Crash reporting

```dart
abstract interface class CrashReporter {
  void recordError(Object error, StackTrace? stack, {bool fatal});
  void recordFlutterError(FlutterErrorDetails details);
  void setContext(String key, Object value);
}
```

Dietro l'interfaccia: Crashlytics o Sentry, deciso quando serve. La scelta è
rimandabile; l'astrazione no, perché il codice che la usa è sparso ovunque.

Cattura, in `bootstrap.dart`:

```dart
runZonedGuarded(() {
  FlutterError.onError = reporter.recordFlutterError;
  PlatformDispatcher.instance.onError = reporter.recordError;
  runApp(...);
}, reporter.recordError);
```

Si riportano solo gli `UnexpectedFailure` (`07-errors-and-feedback.md`). Un
timeout di rete non è un crash: è una condizione prevista.

## Tracce di performance

Le tracce corrispondono ai budget di `15-performance.md`:

| Traccia | Attributi |
|---|---|
| `app_start` | cold/warm, `schemaVersion`, seed applicato |
| `first_useful_paint` | tab iniziale |
| `catalog_seed` | numero di righe, durata |
| `catalog_delta` | versione da/a, righe cambiate |
| `exercise_detail_open` | cache hit/miss |
| `exercise_search` | numero di risultati, filtri attivi |
| `workout_start` | numero di esercizi |
| `set_completed` | — |
| `sync_batch` | eventi, byte, esito |
| `media_download` | tipo, byte, rete |

Le tracce di rete automatiche non bastano: i percorsi che contano sono locali,
e vanno strumentati esplicitamente.

## Debug screen locale

La parte che manca oggi e che serve di più. Vedi `17-config-and-flags.md` per il
contenuto, con in più:

- **ispettore dell'outbox**: righe per stato, payload, ultimo errore, con la
  possibilità di forzare un reinvio;
- **statistiche del database**: righe per tabella, dimensione del file;
- **ultimi 200 log** in memoria, esportabili;
- pulsanti distruttivi (svuota cache media, resetta catalogo) chiaramente
  separati e disponibili solo in build non-release.

Con questa schermata il debug di un problema di sync smette di richiedere un
flag globale che altera il comportamento della app.

## Metriche di prodotto

Distinte dall'osservabilità tecnica: vedi `22-analytics-events.md`. La regola di
separazione è netta — il logger tecnico non manda eventi di prodotto, e il
tracker di prodotto non manda diagnostica.

## Regole

1. Un solo `AppLogger`, un solo `CrashReporter`, un solo `PerformanceTracer`.
2. Tutti e tre dietro interfaccia: nessun SDK di terze parti importato in una
   feature.
3. Nessun dato personale o di allenamento nei log.
4. Ogni log a livello `error` deve essere azionabile. Se non lo è, è un `warn`.
5. In test, le implementazioni sono no-op iniettate da `ProviderContainer`.
