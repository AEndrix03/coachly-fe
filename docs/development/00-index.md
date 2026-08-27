# Coachly — Development Architecture

Indice dei documenti di architettura del client Flutter.

## Come si legge

I documenti sono divisi in tre livelli. Il livello determina quanto sono vincolanti,
non quanto sono importanti.

| Livello | Significato | Modificabile |
|---|---|---|
| **Costituzione** | Regole non negoziabili. Una violazione è un bug. | Solo con ADR |
| **Standard** | Come si fanno le cose. Deviare richiede una motivazione nel PR. | Con PR |
| **Riferimento** | Materiale di consultazione, cresce nel tempo. | Liberamente |

Ogni documento dichiara nel frontmatter il proprio livello e il proprio stato
(`draft` / `active` / `superseded`).

## Principio guida

> Ogni regola in questi documenti deve essere **verificabile automaticamente**
> oppure dichiarata esplicitamente come non verificabile.

Una regola che nessun lint può controllare è una raccomandazione, e va scritta
come tale. Il repository ha già sperimentato il fallimento opposto: `AGENTS.md`
contiene una "UI Theme Rule (mandatory)" che vieta i colori letterali, e il
codice ne contiene 216.

## Indice

### Fondamenta

| # | Documento | Livello | Stato |
|---|---|---|---|
| 01 | `01-principles.md` — regole non negoziabili, dependency rules | Costituzione | da scrivere |
| 02 | `02-project-structure.md` — folder tree, anatomia di una feature | Costituzione | da scrivere |
| 20 | `20-conventions-and-enforcement.md` — lint, CI, definition of done | Costituzione | da scrivere |
| 21 | `21-golden-path.md` — una feature end-to-end, file per file | Riferimento | da scrivere |

### Dati e stato

| # | Documento | Livello | Stato |
|---|---|---|---|
| 03 | `03-state-riverpod.md` — controller, lifecycle, select, mutations | Standard | da scrivere |
| 04 | `04-data-layer.md` — repository, Drift, schema, catalogo pre-seeded | Costituzione | da scrivere |
| 05 | `05-sync-and-offline.md` — local-first, coda append-only, event log | Costituzione | da scrivere |
| 06 | `06-networking.md` — ApiClient, coalescing, idempotenza, cancellazione | Standard | da scrivere |
| 07 | `07-errors-and-feedback.md` — Result, Failure, toast vs inline | Standard | da scrivere |

### Presentazione

| # | Documento | Livello | Stato |
|---|---|---|---|
| 08 | `08-routing-navigation.md` — go_router, shell, navbar dal routing | Standard | da scrivere |
| 09 | `09-design-tokens.md` — colore, tipografia, spazio, raggio, elevazione | Costituzione | da scrivere |
| 10 | `10-components.md` — tassonomia, quando un widget sale a design system | Standard | da scrivere |
| 11 | `11-motion.md` — durate, curve, quando animare, reduce motion | Standard | da scrivere |
| 12 | `12-iconography.md` — un solo pack, dimensioni, semantica | Standard | da scrivere |
| 13 | `13-i18n.md` — ARB per la UI, i18n dei dati, formati e unità | Costituzione | da scrivere |
| 14 | `14-accessibility.md` — target, semantics, contrasto, text scaling | Costituzione | da scrivere |
| 15 | `15-performance.md` — liste, rebuild, blur, budget di avvio | Standard | da scrivere |

### Trasversali

| # | Documento | Livello | Stato |
|---|---|---|---|
| 16 | `16-media.md` — cache, prefetch, budget disco, policy di rete | Standard | da scrivere |
| 17 | `17-config-and-flags.md` — AppConfig, dart-define, stati di cache | Standard | da scrivere |
| 18 | `18-observability.md` — logging, crash, metriche, debug screen | Standard | da scrivere |
| 19 | `19-testing.md` — piramide, fake, DB in-memory, golden, a11y | Standard | da scrivere |
| 22 | `22-analytics-events.md` — tassonomia eventi, privacy, consenso | Standard | da scrivere |
| 23 | `23-voice.md` — pipeline di risoluzione vocale | Riferimento | da scrivere |
| 24 | `24-security-and-privacy.md` — segreti, dati a riposo, GDPR | Standard | da scrivere |
| 25 | `25-release-and-environments.md` — flavor, versioning, min version | Standard | da scrivere |

### Processo

| # | Documento | Livello | Stato |
|---|---|---|---|
| 26 | `26-migration-plan.md` — dallo stato attuale al target, per aree | Riferimento | da scrivere |
| 27 | `adr/` — Architecture Decision Records | Costituzione | da creare |

## Decisioni prese

| Decisione | Esito | ADR |
|---|---|---|
| Design system | **Nuovo layer di token da zero.** `AppThemeScheme`, `CoachlyAthleteTheme` ed `exercise_theme` vengono rimappati sopra e poi rimossi. | ADR-001 |
| Localizzazione | **ARB + `gen_l10n`.** `AppStrings` viene migrato ed eliminato, insieme ai `_t(context, en:, it:)` inline. | ADR-002 |
| Iconografia | **Solo Material Icons.** Si rimuovono `lucide_icons_flutter`, `ionicons`, `cupertino_icons`. | ADR-003 |
| Persistenza | **Drift / SQLite.** Hive rimosso interamente. | ADR-004 |
| Migrazione dati | **Nessuna.** L'app non ha ancora utenti in produzione: schema pulito, nessuna retrocompatibilità, nessun percorso di upgrade dai box Hive. | ADR-005 |

> **Conseguenza importante di ADR-005:** ogni volta che un documento di questa
> cartella si trova davanti alla scelta fra "soluzione corretta" e "soluzione
> compatibile con l'esistente", sceglie la prima. Questa finestra si chiude alla
> prima release pubblica, e da quel momento ADR-005 va sostituito.
