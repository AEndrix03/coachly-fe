---
livello: Costituzione
stato: active
---

# 01 — Principi e dependency rules

Il documento più corto della cartella, e l'unico che va saputo a memoria.

## I cinque principi

### 1. Local-first: la UI non aspetta mai la rete

Ogni lettura che alimenta uno schermo viene servita dal database locale. Il
backend non è la sorgente di ciò che l'utente vede: è la destinazione di ciò che
l'utente produce, e la sorgente del catalogo che viene spedito con la app.

Non esiste uno spinner in attesa di una `GET` per mostrare dati che sono già sul
dispositivo.

### 2. Il client è l'autore, il server è il raccoglitore

I dati di allenamento nascono sul dispositivo, in palestra, spesso offline.
Il server li riceve, non li corregge. Non c'è conflict resolution perché non c'è
conflitto: c'è un **outbox append-only** che sale.

Le entità che in futuro saranno scritte dal server (programmi assegnati da un
coach) sono già separate nello schema, ma oggi sono vuote. Vedi `04-data-layer`.

### 3. Ogni responsabilità ha una tecnologia sola

| Responsabilità | Tecnologia | Alternative vietate |
|---|---|---|
| Stato applicativo e DI | Riverpod 3 | `setState` per dati, hooks, ChangeNotifier |
| Persistenza dati | Drift / SQLite | Hive, file JSON, SharedPreferences |
| Preferenze banali | `SharedPreferencesAsync` | Drift, Hive |
| Segreti e token | `flutter_secure_storage` | qualsiasi altra |
| Navigazione | `go_router` | `Navigator.push` diretto fuori dai flussi modali |
| Modelli | Freezed | `equatable`, classi scritte a mano |
| Testi UI | ARB + `gen_l10n` | stringhe letterali, mappe const |
| Icone | Material Icons | Lucide, Ionicons, Cupertino |
| Colori e misure | token del design system | `Color(0x…)`, numeri magici |

Aggiungere una seconda tecnologia per una responsabilità che ne ha già una
richiede un ADR.

### 4. Il confine dei dati è il repository

Sopra il repository non esistono `http`, `Drift`, DTO, JSON, `StatusCode`.
Sotto il repository non esistono `BuildContext`, widget, `Locale` di
presentazione, stringhe formattate per l'utente.

Un repository che ritorna `"3x10"` sta violando questa regola. Formattare è
compito della presentazione.

### 5. Riverpod non è un layer

Riverpod è il meccanismo che collega e rende reattivi i layer, non uno di essi.
Un `Provider` non è un posto dove mettere logica: è un posto dove esporre
qualcosa che vive altrove.

Se un file `*_provider.dart` contiene una regola di dominio, quella regola è nel
posto sbagliato.

## Dependency rules

Le dipendenze puntano **solo verso il basso**. Nessuna eccezione, nessun
callback all'indietro, nessun import circolare mascherato.

```
      presentation/          widget, pagine
             │
             ▼
      application/           controller Riverpod
             │
             ▼
      domain/                engine, regole    [opzionale per feature]
             │
             ▼
      data/                  repository
             │
      ┌──────┴──────┐
      ▼             ▼
  local/         remote/     Drift          ApiClient
```

Tradotto in regole verificabili:

| # | Regola | Verifica |
|---|---|---|
| D1 | `presentation/` non importa `data/` né `core/network/` né `core/database/` | lint custom |
| D2 | `application/` non importa `flutter/material.dart` | lint custom |
| D3 | `data/` non importa `flutter/widgets.dart` né `presentation/` | lint custom |
| D4 | Nessuna feature importa da `presentation/` di un'altra feature | lint custom |
| D5 | `core/` non importa mai da `features/` | lint custom |
| D6 | Un `*_service.dart` è importabile solo da `data/repositories/` | lint custom |

La D6 è la regola che impedisce il ritorno del problema che questa architettura
nasce per risolvere: due percorsi paralleli verso lo stesso endpoint, uno con
cache e uno senza.

## Cosa entra in `core/`

`core/` non è la cartella delle cose che non sai dove mettere. Un modulo entra in
`core/` solo se soddisfa **tutte e tre** le condizioni:

1. è usato da almeno due feature diverse;
2. non contiene nessuna regola di dominio Coachly;
3. potrebbe essere estratto in un package senza riscritture.

`core/text_filter/` oggi non soddisfa la 2 e va spostato nella feature che lo usa.

## Il domain layer è opzionale, per feature

Non ogni feature ha un `domain/`. Lo introduci quando il controller comincia a
contenere regole che sopravvivrebbero a un cambio di UI.

**Hanno diritto a un domain layer:** progressioni, Plan Guard, motore
dell'allenamento attivo, risoluzione vocale, programmazione.

**Non ce l'hanno:** impostazioni, profilo, liste, form CRUD.

Creare `domain/usecases/change_setting_usecase.dart` per rispettare un diagramma
è un anti-pattern, non un'applicazione di questo documento.

## Antipattern vietati esplicitamente

- `BaseRepository<T>`, `BaseNotifier<T>`, gerarchie generiche create per
  "pulizia". Si preferisce sempre la composizione.
- Side effect nel `build()` di un `Notifier` (`Future.microtask(load)`).
  Esiste `AsyncNotifier`.
- `setState` per dati che arrivano dal repository.
- `try/catch` che riassegna `AsyncError` senza tipizzare il fallimento.
- Un provider per ogni campo di un form. Uno stato coerente, un controller.

## Riferimenti

- [Flutter — Architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Flutter — Offline-first support](https://docs.flutter.dev/app-architecture/design-patterns/offline-first)
- [Flutter — Error handling with Result](https://docs.flutter.dev/app-architecture/design-patterns/result)
