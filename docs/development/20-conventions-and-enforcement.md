---
livello: Costituzione
stato: active
---

# 20 — Convenzioni ed enforcement

## Perché questo documento esiste

`AGENTS.md` contiene già una regola dichiarata **mandatory** che vieta i colori
letterali. Il codice ne contiene 216.

Non è mancata disciplina: è mancato un meccanismo. Una regola che nessuno
verifica non è una regola, è un'opinione scritta bene.

Da qui la regola sulle regole:

> Ogni voce di questi documenti è **bloccante** (un lint la verifica e la CI
> fallisce), **verificata** (un test la copre), oppure **dichiarata come
> raccomandazione**. Non esistono altre categorie.

## Lint bloccanti

### Dal pacchetto standard

`analysis_options.yaml` parte da `flutter_lints` e aggiunge:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "qual/**"            # copia di lavoro, 211 dei 308 issue attuali
  errors:
    invalid_annotation_target: ignore
    missing_required_param: error
    missing_return: error

linter:
  rules:
    - always_use_package_imports      # niente import relativi
    - avoid_print
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - unawaited_futures
    - use_build_context_synchronously
    - sort_pub_dependencies
    - avoid_slow_async_io
```

`always_use_package_imports` non è cosmesi: `app_router.dart` oggi mescola
`package:coachly/...` e `../features/...`, il che rende invisibili le violazioni
delle dependency rules a qualsiasi analisi statica.

### Custom lint

Implementati in `tool/coachly_lints/`, agganciati via
`analyzer: plugins: [custom_lint]`. Ogni regola implementa una riga di
`01-principles.md`.

**Stato attuale — 170 violazioni rilevate su 5 regole attive:**

| Regola | Violazioni | Doc |
|---|---|---|
| `no_literal_colors` | 142 | 09 |
| `no_features_in_core` | 15 | 01 D5 |
| `no_cross_feature_presentation` | 10 | 01 D4 |
| `no_data_layer_in_presentation` | 3 | 01 D1 |
| `no_side_effects_in_build` | 0 | 03 |
| `no_raw_datetime_now` | 0 (attende `core/time`) | 19 |
| `no_material_in_application` | 0 (attende `application/`) | 01 D2 |
| `no_data_source_outside_repository` | 0 (attende `data/remote`) | 01 D6 |

Le ultime tre non trovano nulla perché le cartelle target non esistono ancora:
sono attive in anticipo, così la prima feature scritta secondo la nuova
struttura è già coperta.

Regole ancora da implementare:

| Regola | Cosa vieta | Doc |
|---|---|---|
| `no_literal_colors` | `Color(0x…)` e `Colors.*` fuori da `design_system/tokens/` | 09 |
| `no_literal_text_style` | `TextStyle(...)` costruito fuori dai token | 09 |
| `no_magic_spacing` | `SizedBox`/`EdgeInsets`/`BorderRadius` con letterali non-token | 09 |
| `no_hardcoded_strings` | stringhe letterali in `Text()` e proprietà user-facing | 13 |
| `no_service_outside_repository` | import di `*_data_source.dart` fuori da `data/repositories/` | 01 D6 |
| `no_data_layer_in_presentation` | import di `core/network`, `core/database`, `data/` da `presentation/` | 01 D1 |
| `no_material_in_application` | import di `flutter/material.dart` da `application/` | 01 D2 |
| `no_cross_feature_presentation` | import di `features/x/presentation` da `features/y` | 01 D4 |
| `no_features_in_core` | import di `features/` da `core/` | 01 D5 |
| `no_side_effects_in_build` | `Future.microtask` / chiamate async nel `build()` di un Notifier | 01 |
| `no_non_material_icons` | import di `ionicons`, `lucide_icons_flutter`, `cupertino_icons` | 12 |
| `no_raw_datetime_now` | `DateTime.now()` fuori da `core/time/` | 01 |
| `no_manual_uuid` | generazione id fuori da `core/ids/` | 05 |

### Regola di adozione

I lint restano `warning` su tutto il repository e sono **bloccanti solo sui file
toccati dal PR**. Attivarli come errore ovunque il primo giorno bloccherebbe
qualsiasi lavoro e finirebbe con un `// ignore_for_file` generalizzato — cioè
esattamente il fallimento di `AGENTS.md`, ripetuto.

Il meccanismo è `tool/check_changed.sh`:

```bash
tool/check_changed.sh              # confronto con origin/master
tool/check_changed.sh develop      # confronto con un'altra base
```

Esce con codice 1 se un file che hai modificato viola una regola, e ignora tutto
il resto. È lo script che la CI esegue sui PR.

Il debito si assorbe file per file, mentre il lint impedisce che ne nasca di
nuovo.

## Test che valgono come regole

Alcune cose non si esprimono in un lint. Diventano test in CI:

| Test | Verifica | Doc |
|---|---|---|
| `l10n_parity_test` | ogni chiave ARB esiste in tutte le lingue | 13 |
| `l10n_unused_test` | nessuna chiave ARB orfana | 13 |
| `tap_target_test` | `androidTapTargetGuideline` sulle schermate principali | 14 |
| `contrast_test` | `textContrastGuideline` | 14 |
| `text_scaling_test` | nessun overflow a `textScaler` 2.0 | 14 |
| `migration_test` | ogni schema Drift migra dallo snapshot precedente | 04 |
| `golden_test` | i componenti del design system non cambiano per caso | 10 |
| `dependency_test` | nessuna dipendenza dichiarata e non usata | 02 |

Il `text_scaling_test` è particolarmente rilevante: `textScaler` oggi ha **zero
occorrenze** nel codice, quindi la app a text scaling alto non è mai stata
verificata da nessuno.

## Pipeline CI

```
flutter analyze                → zero errori
tool/check_changed.sh          → zero violazioni sui file del PR
flutter test                   → tutto verde
dart format --set-exit-if-changed
```

`dart run custom_lint` da solo riporta tutte le 170 violazioni esistenti: serve
per misurare il debito, non come gate.

La suite oggi **non compila** (`workout_builder_widgets_test.dart` e
`workout_detail_golden_test.dart` hanno argomenti mancanti). Ripararla è il
prerequisito zero: una CI che non gira non impone niente.

## Convenzioni di codice

**Import** — sempre `package:`, ordinati: Dart, Flutter, pacchetti esterni,
`package:coachly`. Nessun import relativo.

**Async** — `unawaited()` esplicito quando si ignora una Future di proposito.
Mai una Future ignorata in silenzio.

**Context** — mai attraverso un `await` senza `mounted`. Il lint
`use_build_context_synchronously` lo verifica.

**Costruttori** — `const` ovunque possibile. È la singola ottimizzazione con il
miglior rapporto costo/beneficio in Flutter.

**Dispose** — ogni `AnimationController`, `TextEditingController`,
`ScrollController`, `StreamSubscription` ha il suo `dispose`. Nel codice
attuale ci sono 19 `AnimationController` e 46 `StatefulWidget`.

**Commenti** — si commenta il *perché*, mai il *cosa*. Un commento che descrive
il codice sottostante è rumore.

## Definition of done

Una PR è completa quando:

- [ ] `flutter analyze` e `custom_lint` puliti sui file toccati
- [ ] test verdi, e nuovi test per la logica non banale introdotta
- [ ] nessuna stringa letterale user-facing, nessun colore o misura letterale
- [ ] le dependency rules di `01-principles.md` sono rispettate
- [ ] i target interattivi introdotti sono ≥ 48×48 dp
- [ ] gli stati loading / empty / error sono gestiti, non dimenticati
- [ ] se la PR cambia una decisione architetturale, c'è un ADR

## ADR

Le decisioni vivono in `docs/development/adr/`, numerate, in questo formato:

```markdown
# ADR-00N — Titolo

Stato: proposto | accettato | sostituito da ADR-00M
Data: YYYY-MM-DD

## Contesto
## Decisione
## Conseguenze
## Alternative scartate
```

Una decisione presa e non registrata è una decisione che verrà rimessa in
discussione fra sei mesi senza memoria del perché. Gli ADR-001…005 già presi
vanno scritti come primo atto.
