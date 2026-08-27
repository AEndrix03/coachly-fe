# Coachly — Development Architecture

Indice dei documenti di architettura del client Flutter.

## Come si legge

I documenti sono divisi in tre livelli. Il livello determina quanto sono
vincolanti, non quanto sono importanti.

| Livello | Significato | Modificabile |
|---|---|---|
| **Costituzione** | Regole non negoziabili. Una violazione è un bug. | Solo con ADR |
| **Standard** | Come si fanno le cose. Deviare richiede una motivazione nel PR. | Con PR |
| **Riferimento** | Materiale di consultazione, cresce nel tempo. | Liberamente |

Ogni documento dichiara nel frontmatter il proprio livello e il proprio stato.

## Da dove si comincia

Chi arriva sul progetto legge, in quest'ordine:

1. **`01-principles.md`** — le regole, in due pagine
2. **`21-golden-path.md`** — una feature reale dall'inizio alla fine
3. **`02-project-structure.md`** — dove vanno le cose

Il resto si consulta quando serve.

## Principio guida

> Ogni regola in questi documenti deve essere **verificabile automaticamente**
> oppure dichiarata esplicitamente come non verificabile.

Una regola che nessun lint può controllare è una raccomandazione, e va scritta
come tale. Il repository ha già sperimentato il fallimento opposto: `AGENTS.md`
contiene una "UI Theme Rule (mandatory)" che vieta i colori letterali, e il
codice ne contiene 216.

## Indice

### Fondamenta

| # | Documento | Livello |
|---|---|---|
| 01 | [Principi e dependency rules](01-principles.md) | Costituzione |
| 02 | [Struttura del progetto](02-project-structure.md) | Costituzione |
| 20 | [Convenzioni ed enforcement](20-conventions-and-enforcement.md) | Costituzione |
| 21 | [Golden path: aggiungere una feature](21-golden-path.md) | Riferimento |

### Dati e stato

| # | Documento | Livello |
|---|---|---|
| 03 | [Stato e Riverpod](03-state-riverpod.md) | Standard |
| 04 | [Data layer](04-data-layer.md) | Costituzione |
| 05 | [Sync e offline](05-sync-and-offline.md) | Costituzione |
| 06 | [Networking](06-networking.md) | Standard |
| 07 | [Errori e feedback](07-errors-and-feedback.md) | Standard |

### Presentazione

| # | Documento | Livello |
|---|---|---|
| 08 | [Routing e navigazione](08-routing-navigation.md) | Standard |
| 09 | [Design tokens](09-design-tokens.md) | Costituzione |
| 10 | [Componenti](10-components.md) | Standard |
| 11 | [Movimento e animazioni](11-motion.md) | Standard |
| 12 | [Iconografia](12-iconography.md) | Standard |
| 13 | [Localizzazione, formati e unità](13-i18n.md) | Costituzione |
| 14 | [Accessibilità](14-accessibility.md) | Costituzione |
| 15 | [Performance](15-performance.md) | Standard |

### Trasversali

| # | Documento | Livello |
|---|---|---|
| 16 | [Media](16-media.md) | Standard |
| 17 | [Configurazione e feature flag](17-config-and-flags.md) | Standard |
| 18 | [Osservabilità](18-observability.md) | Standard |
| 19 | [Testing](19-testing.md) | Standard |
| 22 | [Eventi e analytics](22-analytics-events.md) | Standard |
| 23 | [Sottosistema vocale](23-voice.md) | Riferimento |
| 24 | [Sicurezza e privacy](24-security-and-privacy.md) | Standard |
| 25 | [Release e ambienti](25-release-and-environments.md) | Standard |

### Processo

| # | Documento | Livello |
|---|---|---|
| 26 | [Piano di migrazione](26-migration-plan.md) | Riferimento |
| — | [Architecture Decision Records](adr/README.md) | Costituzione |

## Decisioni prese

| ADR | Decisione |
|---|---|
| [001](adr/001-design-tokens-da-zero.md) | Layer di design token nuovo. I tre sistemi esistenti vengono rimappati e rimossi. |
| [002](adr/002-arb-gen-l10n.md) | ARB + `gen_l10n`. `AppStrings` e i `_t(…)` inline vengono eliminati. |
| [003](adr/003-solo-material-icons.md) | Solo Material Icons. Tre pack rimossi. |
| [004](adr/004-drift-al-posto-di-hive.md) | Drift / SQLite. Hive rimosso interamente. |
| [005](adr/005-nessuna-migrazione-dati.md) | Nessuna migrazione dati: l'app non ha utenti in produzione. |
| [006](adr/006-dio-al-posto-di-http.md) | Dio al posto di `package:http`, per la cancellazione delle richieste. |

> **Conseguenza di ADR-005.** Ogni volta che un documento si trova davanti alla
> scelta fra "soluzione corretta" e "soluzione compatibile con l'esistente",
> sceglie la prima. Questa finestra si chiude alla prima release pubblica, e da
> quel momento ADR-005 va sostituito.

## Cosa fare per primo

Da `26-migration-plan.md`, i tre interventi con il rapporto valore/costo più alto:

1. **Guardia sul logout con outbox non vuota** — oggi è una perdita di dati attiva
2. **Request coalescing** — elimina chiamate multiple e overlay sovrapposti
3. **Catalogo pre-seeded** — azzera la voce di traffico principale

Prima di tutto, però, la Fase 0: la suite di test non compila, e senza CI nessuna
di queste regole è verificabile.
