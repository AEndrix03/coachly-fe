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

- La suite di test **non compila** (`workout_builder_widgets_test.dart`,
  `workout_detail_golden_test.dart`). È la Fase 0 del piano di migrazione.
- `qual/` è una copia di lavoro non tracciata: **ignorala**, produce 211 dei 308
  issue dell'analyzer.
- `docs/` è escluso dal `.gitignore` globale dell'utente e ri-abilitato dal
  `.gitignore` di questo repository.
