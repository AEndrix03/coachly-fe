---
livello: Standard
stato: active
---

# 17 — Configurazione e feature flag

## Il problema

Oggi la configurazione vive in cinque meccaniche diverse: `dart-define` in una
classe dedicata (`AppCachePolicy`), `dart-define` in una costante inline
(`WORKOUT_DETAIL_MOCK_STRUCTURE`), un parametro di costruttore fissato nel
provider (`useMockData`, ora rimosso), stringhe magiche in una box
(`workoutBuilderTourAutoShow`), e valori hardcoded (TTL, `ThemeMode.dark`).

Non esiste un posto dove leggere quali flag esistono, né un modo di sapere in
quale configurazione gira una build.

## Quattro categorie, non una

| Categoria | Cambia | Chi decide | Dove |
|---|---|---|---|
| **Build config** | a compile time | chi builda | `dart-define` → `AppConfig` |
| **Debug switch** | a compile time | sviluppatore | `dart-define` → `AppConfig`, solo non-release |
| **Preferenza utente** | a runtime | utente | `SharedPreferencesAsync` |
| **Feature flag** | a runtime | prodotto | `FeatureFlags` |

Confonderle è la ragione per cui oggi un flag di debug della cache ha effetti
architetturali permanenti.

## `AppConfig`

Unico punto di verità, in `core/config/`:

```dart
final class AppConfig {
  static const environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const apiBaseUrl  = String.fromEnvironment('API_BASE_URL', defaultValue: …);
  static const keycloakIssuer   = String.fromEnvironment('KEYCLOAK_ISSUER', …);
  static const keycloakClientId = String.fromEnvironment('KEYCLOAK_CLIENT_ID', …);
  static const cacheMode = String.fromEnvironment('CACHE_MODE', defaultValue: 'warm');
  static const logLevel  = String.fromEnvironment('LOG_LEVEL', defaultValue: 'info');

  static Map<String, Object> get debugSnapshot => { … };
}
```

Nessuna feature legge `String.fromEnvironment` direttamente.

> **Risolto.** Il disallineamento fra `coachly-mobile` (codice) e `coachly-app`
> (`AUTHENTICATION.md`) e' stato sciolto interrogando il realm: `coachly-app` e'
> il nome del realm e come client **non esiste**, `coachly-mobile` esiste ed e'
> un client pubblico con PKCE obbligatorio. Il default del codice era quello
> giusto; la documentazione e' stata corretta.

## `CACHE_MODE`

Sostituisce `ENABLE_LOCAL_CACHE`. La differenza è sostanziale: si controlla lo
**stato** della cache, non la sua esistenza.

| Valore | Comportamento | Serve a |
|---|---|---|
| `warm` (default) | normale | produzione |
| `cold` | svuota il DB locale all'avvio, poi normale | simulare la prima installazione |
| `no-seed` | ignora l'asset del catalogo, forza il download | verificare il fallback |

In tutte le modalità il data layer resta attivo e il coalescing resta attivo.
La modalità precedente disattivava il layer locale in modo permanente, mettendo
la app in uno stato che in produzione non esiste — e generando essa stessa i
sintomi che doveva diagnosticare. Vedi `05-sync-and-offline.md`.

`cold` e `no-seed` sono ignorati nelle build release.

## Feature flag

```dart
enum Feature {
  workoutLoggerV2,
  voiceLogging,
  coachMode,
  programBuilder,
}

abstract interface class FeatureFlags {
  bool isEnabled(Feature feature);
}
```

Risoluzione a tre livelli, in ordine:

```
default locale (compilato)  →  override remoto (cache)  →  override di debug
```

Regole:

1. Nessuna feature interroga un SDK remoto direttamente. Solo `FeatureFlags`.
2. Ogni flag ha un **default locale sicuro**: senza rete la app funziona.
3. Un flag ha una data di scadenza. Un flag permanente non è un flag: è
   configurazione, e va promosso o rimosso.
4. **Un flag non abilita mai una capability che il backend non supporta.** Se una
   funzione richiede un endpoint, la disponibilità la dichiara il backend, non un
   flag di prodotto.

Il provider remoto (Remote Config o altro) è una decisione **rimandata**:
introduce una dipendenza infrastrutturale e un processore di dati, cosa che tocca
`24-security-and-privacy.md`. L'astrazione serve ora; l'implementazione remota
quando servirà davvero.

## Preferenze utente

`SharedPreferencesAsync`, mai Drift, mai `dart-define`:

```
locale            themeMode              weightUnit
intensityScale    downloadOnWifiOnly     keepScreenOn
mediaBudgetMb     builderTourSeen        lastTab
```

Chiavi tipizzate in un unico posto, mai stringhe magiche sparse.

Perderle deve essere irrilevante: se un dato non può essere perso, non è una
preferenza e va in Drift.

## Debug screen

Raggiungibile in build non-release. Mostra:

- l'intero `AppConfig.debugSnapshot`;
- `CACHE_MODE` attivo;
- `catalog_version` e data dell'ultimo delta;
- `schemaVersion` del database;
- righe di outbox per stato, con l'ultimo errore;
- statistiche della cache media;
- i feature flag risolti, con il livello che ha vinto.

Con quattro `dart-define` in gioco è facile lanciare una build e non sapere in
che configurazione si sta. Questa schermata elimina l'ambiguità che rende
difficili proprio i bug che si cercano.

## Ambienti

`ENV` ∈ `dev` | `stage` | `prod`. Vedi `25-release-and-environments.md`.
