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
  `context.l10n`. **Non** esistono ancora: `context.colors`, il catalogo
  pre-seeded, l'event log delle sessioni.
- Il debito di lint residuo è `no_literal_text_style`, 188 occorrenze, e si
  assorbe schermata per schermata.
- `docs/` è escluso dal `.gitignore` globale dell'utente e ri-abilitato dal
  `.gitignore` di questo repository.
