# ADR-001 — Layer di design token nuovo

Stato: accettato
Data: 2026-08-28

## Contesto

Nel progetto convivono tre sistemi di stile sovrapposti e nessuno autoritativo:

- `AppThemeScheme` (FlexColorScheme, 43 righe);
- `CoachlyAthleteTheme`, riferimento citato in `AGENTS.md`, usato in 18 file;
- `exercise_theme`, usato in 21 file.

In parallelo esistono **216 colori letterali** `Color(0x…)` nel codice di
prodotto, nonostante `AGENTS.md` contenga una regola dichiarata *mandatory* che
li vieta.

Nessuno dei tre sistemi copre i concetti di prodotto Coachly (tipi di serie,
ruolo muscolare, scale di intensità, stato di sincronizzazione), che vengono
quindi espressi con colori scelti caso per caso.

## Decisione

Si costruisce un **layer di token nuovo** in `design_system/tokens/`, con
separazione fra primitivi (privati al modulo) e ruoli semantici, esposto tramite
`ThemeExtension` e un'unica extension su `BuildContext`.

I tre sistemi esistenti vengono **rimappati** sui nuovi token e mantenuti come
alias deprecati durante la transizione, poi rimossi.

Coachly parte **solo dark**, dichiarato. Il tema chiaro si aggiunge quando i
token semantici sono completi.

## Conseguenze

- Costo iniziale più alto delle altre due opzioni: i token vanno progettati
  prima di poter migrare qualsiasi cosa.
- I token di dominio (`setWorking`, `musclePrimary`, `intensityHigh`,
  `syncPending`) diventano vocabolario condiviso fra design e codice.
- `flex_color_scheme` verrà rimosso a transizione completata.
- Il lint `no_literal_colors` diventa applicabile: senza un layer completo,
  vietare i letterali bloccherebbe il lavoro.
- `lightTheme` oggi è codice morto dietro `ThemeMode.dark` hardcoded: la
  decisione lo rende esplicito invece che accidentale.

## Alternative scartate

**Tenere `CoachlyAthleteTheme` come unico.** Era l'opzione consigliata: meno
lavoro, già citata in `AGENTS.md`. Scartata perché avrebbe ereditato una
struttura nata per una schermata, senza separazione primitivi/semantici e senza
i token di dominio — cioè avrebbe richiesto comunque un ridisegno, partendo però
da un vincolo.

**Tenere FlexColorScheme come base.** Vincola la palette al modello Flex e
continua a non coprire i concetti di prodotto.
