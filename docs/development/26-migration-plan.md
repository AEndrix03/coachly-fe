---
livello: Riferimento
stato: active
---

# 26 — Piano di migrazione

ADR-005 semplifica enormemente questo documento: **nessun utente in produzione,
quindi nessuna migrazione di dati**. Hive si rimuove, il database si ricrea. Ciò
che resta è una migrazione di *codice*, che può essere fatta per aree.

Regola generale: **ogni fase lascia la app funzionante**. Nessun branch lungo,
nessuno stato in cui il progetto non compila.

## Fase 0 — Precondizioni

Nulla di architetturale. Senza queste, tutto il resto non è verificabile.

| # | Azione | Stato |
|---|---|---|
| 0.1 | Riparare la suite di test (non compilava) | ✅ compila e gira |
| 0.2 | Escludere `qual/` dall'analyzer | ✅ 308 → 104 issue |
| 0.3 | Rimuovere le dipendenze a zero utilizzi + `equatable` | ✅ 7 rimosse |
| 0.4 | Guardare i `debugPrint`, togliere i body dalle risposte | ✅ `AppLogger` |
| 0.5 | Rimuovere `syncEnabled` (codice morto) e i mock rimasti | ✅ |
| 0.6 | **Guardia sul logout con outbox non vuota** | ✅ con test e dialog collegato |
| 0.7 | Correggere il default di `KEYCLOAK_CLIENT_ID` | ✅ verificato sul realm: era giusto il codice |
| 0.8 | Passata di dead code | ✅ |

**Fase 0 chiusa.**

I 12 test rossi sono stati esaminati uno per uno, come il documento chiedeva.
In tutti i casi aveva ragione la UI: le asserzioni descrivevano interazioni
sostituite dal redesign — il nome dell'esercizio che espandeva la scheda invece
di aprire il dettaglio, il foglio sezioni senza il passaggio "Personalizza",
liste diventate pigre che il test contava senza scrollare, un harness in
inglese contro asserzioni in italiano. I quattro golden sono stati rigenerati:
uno di essi registrava lo stato collassato ed era **byte per byte identico** a
un altro golden, cioè non verificava niente da quando la scheda era cambiata.

La suite è verde: 209 test, zero rossi, `tool/test_baseline.txt` vuota.

`logout()` rifiuta se la coda non è vuota, e `profile_page.dart` ora mostra il
rifiuto: un secondo dialog dice quante modifiche andrebbero perse e solo dopo
conferma esplicita chiama `logout(force: true)`.

`KEYCLOAK_CLIENT_ID` è stato risolto interrogando il realm invece di
assumere: `coachly-app` è il nome del realm e come client non esiste,
`coachly-mobile` esiste ed è pubblico con PKCE obbligatorio. Il default del
codice era corretto, `AUTHENTICATION.md` no.

## Fase 1 — Fondamenta invisibili

Nessun cambiamento visibile all'utente. Sbloccano tutto il resto.

| # | Azione | Doc |
|---|---|---|
| 1.1 | `AppConfig` + debug screen | 17 |
| 1.2 | `core/time/Clock` iniettabile, lint su `DateTime.now()` | 19 |
| 1.3 | `core/ids`, rimozione dell'UUID scritto a mano | 05 |
| 1.4 | `Result<T, Failure>` e tassonomia | 07 |
| 1.5 | `AppLogger`, `CrashReporter`, `PerformanceTracer` | 18 |
| 1.6 | Lint custom in `warning`, CI attiva | 20 |

## Fase 2 — Rete

| # | Azione | Doc |
|---|---|---|
| 2.1 | Migrazione a Dio, conservando il refresh coalescente | 06 |
| 2.2 | Request coalescing centralizzato | 06 |
| 2.3 | `CancelToken` legato ai provider autoDispose | 06 |
| 2.4 | Interceptor: auth, request-id, idempotency, log, metriche | 06 |
| 2.5 | Repository che ritornano `Result` | 07 |

Da qui in poi le chiamate multiple e gli overlay sovrapposti non sono più
possibili, **anche prima** di toccare il database.

## Fase 3 — Database

Il cuore. Fatta per aggregati, non in blocco.

| # | Azione | Rischio |
|---|---|---|
| 3.1 | Schema Drift completo, `schemaVersion` 1, snapshot esportato | — |
| 3.2 | Pipeline di generazione di `catalog.sqlite` in CI | — |
| 3.3 | Migrazione del **catalogo**: DAO, repository, seed da asset, delta | basso, rigenerabile |
| 3.4 | Migrazione di **workout e blocchi** | medio |
| 3.5 | Migrazione di **sessioni** verso l'event log append-only | alto, ridisegno |
| 3.6 | Migrazione di **outbox** | alto |
| 3.7 | Migrazione di **alias e log vocali** | basso |
| 3.8 | Rimozione di Hive e `LocalDatabaseService` | — |
| 3.9 | SQLCipher | 24 |

Ordine deliberato: si parte da ciò che è rigenerabile e si finisce con ciò che è
insostituibile, così i primi errori si pagano poco.

Il 3.5 non è un porting: le sessioni oggi salvano lo stato finale mergiato,
mentre l'event log registra il processo. È il punto in cui si guadagna il dataset
che giustifica il backend.

## Fase 4 — Stato

| # | Azione | Doc |
|---|---|---|
| 4.1 | Stream Drift al posto delle 12 `ref.invalidate` | 03 |
| 4.2 | `keepAlive` esplicito su repository e stream globali | 03 |
| 4.3 | Rimozione dei side effect nel `build()` dei Notifier | 03 |
| 4.4 | `select` nelle foglie delle schermate ad alta frequenza | 03, 15 |
| 4.5 | Mutations per le azioni utente | 07 |

## Fase 5 — Presentazione

Da qui in avanti si procede **opportunisticamente**, feature per feature, mentre
si lavora ad altro. Il lint impedisce le regressioni.

| # | Azione | Doc |
|---|---|---|
| 5.1 | Token e `ThemeExtension`; i vecchi sistemi diventano alias | 09 |
| 5.2 | Setup ARB + conversione automatica di `app_strings` | 13 |
| 5.3 | Estrazione dei `_t(…)` inline, feature per feature | 13 |
| 5.4 | Navbar: `goBranch`, enum `AppTab` | 08 |
| 5.5 | Rotte per id, niente oggetti in `extra` | 08 |
| 5.6 | Scomposizione dei file oltre 800 righe, estraendo componenti | 10 |
| 5.7 | Solo Material Icons | 12 |
| 5.8 | Liste virtualizzate, filtri in SQL | 15 |
| 5.9 | Test a11y sulle schermate principali | 14 |
| 5.10 | Rimozione degli alias e dei tre sistemi di tema | 09 |

## Fase 6 — Chiusura

| # | Azione |
|---|---|
| 6.1 | Lint in `error` su tutto il repository |
| 6.2 | Flavor e configurazione per ambiente |
| 6.3 | Versione minima supportata |
| 6.4 | Consensi, export, cancellazione |
| 6.5 | Rimozione di ADR-005 e sostituzione con la politica di compatibilità |

Il 6.5 è la fine del periodo di grazia: da lì in poi ogni cambio di schema è una
migrazione vera.

## Cosa non si fa

- **Nessun branch di rewrite.** Ogni fase è una serie di PR su `master`.
- **Nessuna riscrittura della UI durante la migrazione dei dati.** Sono due
  lavori diversi; farli insieme rende impossibile capire cosa ha rotto cosa.
- **Nessun rinvio della Fase 0.** È la meno gratificante ed è quella senza cui
  non si misura niente.

## Ordine di valore

Se si dovesse fermare tutto dopo tre interventi, i tre con il rapporto
valore/costo più alto sono:

1. **0.6** — la guardia sul logout, perché è una perdita di dati attiva;
2. **2.2** — il coalescing, che elimina chiamate multiple e overlay;
3. **3.3** — il catalogo pre-seeded, che azzera la voce di traffico principale.
