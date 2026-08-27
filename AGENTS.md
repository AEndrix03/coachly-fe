# Repository Guidelines

## ⛔ GATE DI LETTURA — PRIMA AZIONE OBBLIGATORIA

@.claude/rules/development.md

**Se l'`@import` qui sopra non è stato espanso automaticamente nel tuo contesto
(Codex, Cursor e la maggior parte degli agenti NON lo espandono): apri e leggi
`.claude/rules/development.md` ADESSO, con lo strumento di lettura file, prima
di qualsiasi altra azione.** Non è un suggerimento ed è la prima cosa da fare.

Le regole vincolanti stanno lì; l'architettura sta in `docs/development/`.
Entrambe hanno **sempre** precedenza su qualsiasi altra sezione di questo file.

### Il minimo che devi sapere anche se non leggi altro

**Il codice del repository è INDIETRO rispetto ai documenti.** `docs/development/`
descrive l'architettura target; la migrazione è in corso
(`docs/development/26-migration-plan.md`). Non esistono ancora: i token di
design, ARB/`context.l10n`, `Clock`, `core/ids`, `Result<T, Failure>`,
`AppLogger`, Drift, Dio, il coalescer, l'outbox.

Quindi **non affermare che esistano** e **non violare le regole "per ora"**:
segui il protocollo della sezione 3 di `.claude/rules/development.md`.

**Mai, nemmeno temporaneamente:** `Color(0x…)` o `Colors.*` · `TextStyle`/
`fontSize` a mano · numeri magici in `SizedBox`/`EdgeInsets`/`BorderRadius` ·
stringhe utente scritte nel codice · `DateTime.now()` · `print`/`debugPrint` ·
rete chiamata da widget o provider · target sotto 48×48 dp · dipendenze nuove
senza chiedere.

**Sempre:** Coachly è local-first — la UI legge dal database locale e non aspetta
mai una chiamata HTTP.

### Procedura

1. Leggi `.claude/rules/development.md`.
2. Leggi `docs/development/01-principles.md`.
3. Leggi i documenti indicati dalla tabella di instradamento per il tuo task.
4. Solo dopo, scrivi codice.
5. Rispondi nel formato della sezione 4 della rule: riga `Docs consultati:`,
   sezione `Attriti:`, checklist `Autocontrollo:`.

Se non riesci a leggere i documenti, **fermati e dichiaralo**. Non procedere a
intuito.

> Le sezioni seguenti descrivono lo stato **storico** del repository. Restano
> valide solo dove non contraddicono `.claude/rules/development.md` e
> `docs/development/`.

## Project Structure & Module Organization
This is a Flutter app with feature-first organization under `lib/features/`. Main areas are `auth`, `exercise`, `workout`, `user_settings`, `common`, and `home`. App bootstrap is in `lib/main.dart`, routing in `lib/routes/app_router.dart`, shared utilities in `lib/core/` and `lib/shared/`, and static assets in `assets/images/` and `assets/logos/`. Tests currently live in `test/` with a minimal `widget_test.dart`.

## Agent Workflow Rules
Use SerenaMCP as the default tool for repository exploration, symbol lookup, and project context. Prefer SerenaMCP for “every possible task” before falling back to shell-based inspection. Do not run Flutter commands directly as the agent: ask the user to run them manually and provide the exact command to execute.

## Build, Test, and Development Commands
These commands are reference commands for the user to run manually:
- `flutter pub get`: install dependencies.
- `flutter pub run build_runner build --delete-conflicting-outputs`: regenerate `freezed`, `json_serializable`, and Riverpod generated files after model/provider changes.
- `flutter analyze`: run static analysis with project lints.
- `flutter test`: run the test suite.
- `flutter run`: launch the app locally.
- `flutter build apk`: produce an Android build for validation/distribution.

## Coding Style & Naming Conventions
Use standard Flutter/Dart conventions with 2-space indentation. Prefer `PascalCase` for classes and widgets, `camelCase` for methods, variables, and providers, and `snake_case.dart` for file names. Keep widgets small and feature-local when possible. The project uses `flutter_lints`; fix analyzer issues before opening a PR.

## UI Theme Rule (superata)
Questa sezione è sostituita da `docs/development/09-design-tokens.md` e da
[ADR-001](docs/development/adr/001-design-tokens-da-zero.md), che decide di
costruire un layer di token nuovo e di rimuovere `AppThemeScheme`,
`CoachlyAthleteTheme` ed `exercise_theme`. Il divieto sui colori letterali resta
valido e vale **senza eccezioni**; i target (`context.colors`, ecc.) non
esistono ancora, quindi si applica il protocollo della sezione 3 di
`.claude/rules/development.md`.

## Testing Guidelines
Use `flutter_test` for widget and unit tests. Name test files `*_test.dart` and keep them near the behavior they validate in `test/`. Add or update tests for non-trivial business logic, provider behavior, and UI states that can regress. Ask the user to run `flutter test` and `flutter analyze` before submitting changes.

## Commit & Pull Request Guidelines
Always use Conventional Commit style with a short scope-free summary, for example: `fix null safety in exercise muscles tab`, `feat add workout filter chips`, `chore regenerate freezed files`, `test add workout provider coverage`, `docs update contributor guide`. Preferred prefixes include `feat`, `fix`, `chore`, `test`, `docs`, and `refactor`. Keep commits focused. PRs should include a clear summary, affected screens/modules, manual verification steps, linked issues when relevant, and screenshots for UI changes.

## Generated Code & Config
Do not hand-edit `*.g.dart`, `*.freezed.dart`, or other generated files unless debugging generation output. When changing models using Freezed/JSON annotations or Riverpod generators, regenerate code before building. Avoid committing secrets; app configuration should stay out of source where possible.
