---
livello: Costituzione
stato: active
---

# 09 — Design tokens

ADR-001: si costruisce un layer di token nuovo. `AppThemeScheme`,
`CoachlyAthleteTheme` ed `exercise_theme` vengono rimappati sopra e poi rimossi.

## I due livelli

La distinzione che rende un design system utilizzabile:

```
PRIMITIVI                        SEMANTICI
valori grezzi                    ruoli di prodotto
─────────────                    ─────────────────
teal500 = #14B8A6      ────►     surfaceAccent
neutral900 = #0B1223   ────►     surfaceElevated
red500 = #FF6B6B       ────►     feedbackDanger
```

**I primitivi non escono mai da `design_system/tokens/`.** Una feature che scrive
`CoachlyPalette.teal500` sta violando questo documento tanto quanto una che
scrive `Color(0xFF14B8A6)`.

Nel codice di prodotto esistono solo i semantici.

## Struttura

```
design_system/
├── tokens/
│   ├── coachly_palette.dart      primitivi colore — privato al modulo
│   ├── coachly_colors.dart       ruoli semantici
│   ├── coachly_spacing.dart      scala di spazio
│   ├── coachly_radius.dart       raggi
│   ├── coachly_typography.dart   scala tipografica
│   ├── coachly_elevation.dart    ombre e livelli
│   └── coachly_motion.dart       durate e curve  → 11-motion.md
├── theme/
│   ├── coachly_theme.dart        ThemeData + ThemeExtension
│   └── coachly_theme_data.dart   l'extension
└── components/                   → 10-components.md
```

## Colore

I ruoli semantici. Chi non è coperto da `ColorScheme` di Material 3 vive
nell'extension.

**Superfici**

| Token | Uso |
|---|---|
| `surface` | sfondo pagina |
| `surfaceElevated` | card, pannelli |
| `surfaceSunken` | input, aree incassate |
| `surfaceOverlay` | bottom sheet, dialog |
| `surfaceAccent` | superfici che portano l'accento di brand |

**Contenuto**

| Token | Uso |
|---|---|
| `textPrimary` | testo principale |
| `textSecondary` | testo di supporto |
| `textDisabled` | stati disattivati |
| `textOnAccent` | testo sopra `surfaceAccent` |
| `icon` / `iconMuted` | icone, allineate al testo che accompagnano |

**Feedback**

| Token | Uso |
|---|---|
| `feedbackSuccess` | serie completata, sync riuscita |
| `feedbackWarning` | attenzione, dati incompleti |
| `feedbackDanger` | errore, azione distruttiva |
| `feedbackInfo` | informativo, suggerimenti |

**Dominio Coachly** — qui sta il valore vero, perché sono concetti di prodotto:

| Token | Uso |
|---|---|
| `setWorking` / `setWarmup` / `setDrop` / `setFailure` | tipi di serie |
| `musclePrimary` / `muscleSecondary` / `muscleStabilizer` | ruolo muscolare |
| `intensityLow` / `intensityMid` / `intensityHigh` | scale di intensità e tensione |
| `syncPending` / `syncSynced` / `syncOffline` | stato di sincronizzazione |

Le visualizzazioni dati (profili di resistenza, mappe muscolari, grafici) usano
questi token, non colori inventati sul posto.

### Regole

1. Nessun `Color(0x…)` fuori da `design_system/tokens/`. Verificato da lint.
2. Nessun `Colors.*` di Material nel codice di prodotto.
3. Nessun gradiente definito inline: i gradienti sono token.
4. Ogni token di superficie ha un token di contenuto garantito in contrasto.
   La coppia è dichiarata insieme, non scelta da chi la usa.

## Spazio

Scala a base 4, con nomi e non numeri.

```
xxs   4      xs    8      sm   12      md   16
lg    24     xl    32     xxl  48      xxxl 64
```

`SizedBox(height: 17)` non esiste. `Gap(CoachlySpacing.sm)` sì.

Le 511 occorrenze attuali di `const SizedBox` con valori arbitrari sono il debito
da assorbire progressivamente.

## Raggi

```
sm    8      md   12      lg   16
xl    24     pill 999
```

`BorderRadius.circular(17)` e `circular(32)` sparsi nel codice diventano token.

## Tipografia

Scala per **ruolo semantico**, non per dimensione:

| Token | Uso tipico |
|---|---|
| `displayL` / `displayM` | numeri grandi: carico, timer |
| `titleL` / `titleM` / `titleS` | intestazioni di pagina e sezione |
| `bodyL` / `bodyM` / `bodyS` | testo corrente |
| `label` / `labelStrong` | etichette, chip, bottoni |
| `mono` | valori numerici allineati in tabella |

Nessun `fontSize` letterale: il lint `no_literal_text_style` lo verifica.
`TextStyle(...)` in sé è ammesso — `copyWith` su un token è legittimo e
frequente — ma la **dimensione** appartiene al design system.

`displayL` e `displayM` esistono perché durante un allenamento il carico e il
timer devono essere leggibili a un metro di distanza: è un requisito di prodotto,
non una scelta estetica.

### Lo stato di partenza, misurato

**194 `fontSize` letterali su 14 dimensioni diverse.** Non è una scala, è un
continuo in cui ogni schermata sceglie da sé:

| px | occorrenze | token proposto |
|---|---|---|
| 9, 10, 11 | 35 | `label` (12) |
| 12 | 46 | `label` |
| 13 | 28 | `bodyS` |
| 14 | 17 | `bodyM` |
| 15, 16 | 31 | `bodyL` (16) |
| 17, 18 | 13 | `titleM` (18) |
| 19, 20, 22 | 17 | `titleL` (22) |
| 24 e oltre | 7 | `displayM` / `displayL` |

**Questa migrazione non è meccanica.** Portare un 15 a 16 o un 11 a 12 cambia
l'aspetto, e su 194 occorrenze significa ridisegnare mezza interfaccia. Va fatta
schermata per schermata, con una decisione visiva, e con i golden test verdi a
fare da rete — che oggi non lo sono.

Il lint resta quindi in `warning` e blocca solo i file toccati: impedisce che il
continuo cresca, senza forzare un ridisegno non pianificato.

## Elevazione

Cinque livelli, ognuno con ombra e superficie coordinate:

```
flat  →  raised  →  floating  →  overlay  →  modal
```

Le ombre sono token. Oggi il codice contiene `BoxShadow` con `blurRadius` fra 12
e 28 e `spreadRadius` negativi scelti caso per caso.

### Sul blur

`BackdropFilter` è costoso: forza un layer di composizione e ridisegna l'area
sottostante a ogni frame. È consentito **solo** per superfici `overlay` e `modal`,
sempre dentro un `RepaintBoundary`, e mai su un widget che si anima.

La navbar attuale usa `BackdropFilter(sigma: 22)` permanente sotto uno `Stack`
animato: è il caso peggiore possibile e va rifatto. Vedi `08-routing-navigation.md`.

## Accesso

Un solo punto di ingresso, tramite extension su `BuildContext`:

```dart
context.colors.textPrimary
context.spacing.md
context.radii.lg
context.text.titleM
context.motion.standard
```

Non `Theme.of(context).extension<CoachlyThemeData>()!` sparso in 111 punti.

## Tema chiaro e scuro

Coachly è dark-first. Il tema chiaro **o esiste completo o non esiste**: oggi
`lightTheme` è definito e passato a `MaterialApp` mentre `themeMode` è
`ThemeMode.dark` hardcoded, quindi è codice morto che dà l'illusione del
supporto.

Decisione: si parte **solo dark**, dichiarato. `themeMode` esce da `main.dart` e
diventa una preferenza. Il tema chiaro si aggiunge quando i token semantici sono
completi, e a quel punto è una sola mappatura da rifare.

## Percorso di adozione

| Fase | Cosa |
|---|---|
| 1 | Definire i token e l'extension. Nessuna migrazione. |
| 2 | Rimappare `CoachlyAthleteTheme` ed `exercise_theme` sui nuovi token, mantenendo le vecchie API come alias deprecati. |
| 3 | Attivare il lint sui colori letterali **solo per i file nuovi e modificati**. |
| 4 | Migrare i 216 colori inline opportunisticamente, file per file. |
| 5 | Rimuovere gli alias, `flex_color_scheme` e i tre sistemi vecchi. |

La fase 3 è quella che conta: da lì in poi il debito smette di crescere anche
mentre lo si ripaga.

## Riferimenti

- [Flutter — ThemeExtension](https://api.flutter.dev/flutter/material/ThemeData/extensions.html)
- [Flutter — Material Design](https://docs.flutter.dev/ui/design/material)
