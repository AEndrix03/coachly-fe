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

**Stato attuale — 0 violazioni** (erano 170 alla prima esecuzione):

| Regola | Residue | Iniziali | Doc |
|---|---|---|---|
| `no_literal_colors` | 0 | 142 | 09 |
| `no_features_in_core` | 0 | 15 | 01 D5 |
| `no_cross_feature_presentation` | 0 | 10 | 01 D4 |
| `no_data_layer_in_presentation` | 0 | 3 | 01 D1 |
| `no_side_effects_in_build` | 0 | 0 | 03 |
| `no_raw_datetime_now` | 0 | — | 19 |
| `no_material_in_application` | 0 | — | 01 D2 |
| `no_data_source_outside_repository` | 0 | — | 01 D6 |
| `no_non_material_icons` | 0 | 2 | 12, ADR-003 |
| `no_manual_uuid` | 0 | 3 | 05 |
| `no_literal_text_style` | 0 (4 con `ignore` motivato) | 188 | 09 |

Come ci si è arrivati, in ordine di resa:

- **27 violazioni cancellate**, non migrate: erano in widget orfani
  (`workout_card`, `stat_card`, `sparkle_tap_animation`, `offline_mode_banner`).
- **`app_data_sync_service` e `local_database_service` fuori da `core/`**: 15
  violazioni. Conoscevano le feature, quindi appartenevano ad `app/`.
- **`exercise_theme` spostato nel design system**: 9 violazioni in un colpo,
  tutte la stessa causa.
- **`MuscleAnatomyView` promosso a componente di prodotto**: era usato da due
  feature, che è esattamente il criterio di `10-components.md`.
- **`today_home_provider` spostato in `application/`**: era un controller che
  viveva in `presentation/`.
- **Dipendenza auth invertita**: `core/network` dichiara `SessionGateway`, la
  feature auth la implementa, `app/bootstrap` le collega.

`no_raw_datetime_now` e `no_data_source_outside_repository` sono attive in
anticipo sulle cartelle che non esistono ancora, così la prima feature scritta
secondo la nuova struttura è già coperta.

**Da qui il gate può diventare bloccante su tutto il repository**, non solo sui
file toccati: il debito è a zero e ogni nuova violazione è una regressione.

`no_non_material_icons` non vieta `package:flutter/cupertino.dart`: da lì
arriva anche `CupertinoPage`, che è una transizione e non un'icona. Vieta i
pacchetti di glifi e `CupertinoIcons`.

`no_manual_uuid` ha eliminato tre generatori scritti a mano — una UUID v4
compilata a mano con `Random.secure()` e un `'${micros}_${random}'` — mentre
`core/ids` esisteva già.

`no_literal_text_style` era il debito residuo, 188 occorrenze, e sembrava non
chiudibile meccanicamente: i token portano `height` e `fontWeight`, i letterali
quasi mai. Si è chiuso separando il problema in due — nominare le dimensioni
esistenti (costo visivo zero, misurato sui golden) e stringere la scala
(deliberato, un ruolo per volta). Vedi `09-design-tokens.md`.

Restano quattro occorrenze con un `// ignore:` e la ragione scritta accanto.
Un `ignore` motivato non è debito: è la regola che dichiara i propri limiti.

Regole ancora da implementare, in ordine di valore:

| Regola | Cosa vieta | Doc | Prerequisito |
|---|---|---|---|
| `no_hardcoded_strings` | stringhe letterali in `Text()` e proprietà user-facing | 13 | ARB (fase 5.2) |
| `no_magic_spacing` | `SizedBox`/`EdgeInsets`/`BorderRadius` con letterali non-token | 09 | token di spazio realmente in uso |

`no_magic_spacing` è la più delicata: deve distinguere un numero magico da un
token, quindi va scritta solo dopo che i token di spazio sono realmente in uso,
altrimenti segnala tutto e viene disattivata.

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

| Test | Verifica | Doc | Stato |
|---|---|---|---|
| `l10n_parity_test` | ogni chiave ARB esiste in tutte le lingue | 13 | ✅ `test/l10n/` |
| `l10n_unused_test` | nessuna chiave ARB orfana | 13 | ✅ `test/l10n/` |
| `tap_target_test` | `androidTapTargetGuideline` sulle schermate principali | 14 | ✅ `test/a11y/` |
| `contrast_test` | `textContrastGuideline` | 14 | ✅ `test/a11y/` |
| `text_scaling_test` | nessun overflow a `textScaler` 2.0 | 14 | ✅ `test/a11y/` |
| `migration_test` | ogni schema Drift migra dallo snapshot precedente | 04 | ✅ `test/core/database/` |
| `golden_test` | i componenti del design system non cambiano per caso | 10 | ✅ locale, tag `golden` |
| `dependency_test` | nessuna dipendenza dichiarata e non usata | 02 | ✅ `test/tooling/` |

Il `text_scaling_test` era il più rilevante proprio perché `textScaler` aveva
**zero occorrenze**: la app a text scaling alto non era mai stata eseguita da
nessuno. Alla prima esecuzione ha trovato due difetti reali, entrambi corretti
senza toccare il layout a scala 1:

- il segnaposto media dell'esercizio sfondava di 27px il riquadro 16:9 a
  `textScaler` 2.0 — le due righe di testo ora sono `Flexible` con ellissi;
- il titolo dell'app bar della pagina esercizio è trasparente finché non si
  scrolla, ma era comunque annunciato come header: contrasto 1.00, misurato
  correttamente. Ora è escluso dalla semantica finché è invisibile.

Nessuno dei due si vede guardando lo schermo di un telefono nuovo al chiuso, che
è il motivo per cui erano lì.

## Pipeline CI

`.github/workflows/ci.yml`:

```
codice generato allineato    → arb + gen_l10n + build_runner, poi git diff
dart format --set-exit-if-changed
flutter analyze                → zero issue
tool/check_changed.sh          → zero violazioni sui file del PR
tool/check_tests.sh            → zero regressioni rispetto alla baseline
```

Un secondo job non bloccante misura il debito con `custom_lint` su tutto il
repository. La distinzione è deliberata: il gate riguarda ciò che tocchi, la
misura riguarda ciò che resta.

I golden sono esclusi dalla CI (`dart_test.yaml`, tag `golden`): confrontano
pixel, e le immagini di riferimento generate su Windows divergono su un runner
Linux per il font rendering, non per il codice. Valgono in locale. Per
riattivarli in CI vanno rigenerati sulla stessa immagine che li esegue.

`dart run custom_lint` da solo riporta tutte le violazioni esistenti: serve per
misurare il debito, non come gate.

`tool/check_tests.sh` confronta i test rossi con `tool/test_baseline.txt` e
fallisce sia su una regressione sia su un test in baseline tornato verde. La
seconda condizione è quella che impedisce alla baseline di diventare una
discarica: un test riparato deve uscirne nello stesso PR. Oggi la baseline è
**vuota** — il residuo della Fase 0 è stato riassorbito.

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

- [ ] `flutter analyze` pulito e `tool/check_changed.sh` verde
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
discussione fra sei mesi senza memoria del perché. Gli ADR-001…006 sono scritti
in `adr/`.
