# Coachly — client Flutter

## ⛔ GATE DI LETTURA — PRIMA AZIONE OBBLIGATORIA

@.claude/rules/development.md

Se l'import qui sopra non è stato espanso nel tuo contesto, **leggi
`.claude/rules/development.md` adesso**, prima di qualsiasi altra azione.

Le regole vincolanti stanno lì. L'architettura sta in `docs/development/`, con
indice in `docs/development/00-index.md`. Hanno precedenza su qualsiasi
convenzione generale e su `AGENTS.md`.

**Il codice è indietro rispetto ai documenti**: descrivono l'architettura
target, la migrazione è in corso (`docs/development/26-migration-plan.md`).
Non inventare che i pezzi mancanti esistano e non violare le regole "per ora":
segui il protocollo della sezione 3 della rule.

## Comandi

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed, json, riverpod
flutter analyze
flutter test
flutter run
```

Non eseguire comandi Flutter senza che l'utente lo chieda: proponi il comando
esatto da lanciare.

## Stato noto del repository

- La suite è **verde**: 222 test, `flutter analyze` a zero issue. Il gate è
  `.github/workflows/ci.yml`; `tool/check_tests.sh` fallisce sulle regressioni
  e `tool/test_baseline.txt` è vuota.
- `qual/` è una copia di lavoro non tracciata: **ignorala**, è esclusa
  dall'analyzer.
- Esistono ora, contrariamente a quanto dice la sezione 3 della rule: Drift,
  Dio, `core/time/Clock`, `core/ids`, `Result<T, Failure>`, `AppLogger`, il
  `RequestCoalescer`, l'outbox, `core/flags`, `core/analytics`,
  `core/observability` (con debug screen su `/debug`), i file ARB con
  `context.l10n`, e il componente unico dell'attesa
  (`CoachlyLoading`, `docs/development/27-loading.md`). **Non** esistono ancora:
  `context.colors`, il catalogo pre-seeded, l'event log delle sessioni.
- **`custom_lint` è a 0 su tutto il repository**, e il job di CI che lo
  misurava ora blocca. Attenzione: due regole erano scritte male e non
  scattavano mai — `no_raw_datetime_now` e `no_side_effects_in_build`
  guardavano `MethodInvocation`, ma `DateTime.now()` e `Future.microtask()`
  sono costruttori. Riparate, e le violazioni che nascondevano sono chiuse.
- Le feature seguono i quattro livelli (`application`, `data`, `domain`,
  `presentation`): non esistono più `pages/`, `providers/` o `<schermata>_page/`
  a livello di feature.
- **Debito dichiarato**: tredici file superano le 800 righe di
  `02-project-structure.md`. Sono elencati in `test/tooling/file_size_test.dart`,
  che impedisce che l'elenco cresca ma non lo chiude: si chiude dividendo un
  file per volta, quando lo si tocca.
- La documentazione di prodotto — cosa fa ogni schermata e perché — sta in
  `docs/product/`.
- `docs/` è escluso dal `.gitignore` globale dell'utente e ri-abilitato dal
  `.gitignore` di questo repository.
