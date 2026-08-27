---
livello: Standard
stato: active
---

# 12 — Iconografia

ADR-003: **solo Material Icons.**

## Perché

| Pack | Utilizzi oggi | Esito |
|---|---|---|
| Material `Icons.*` | 269 | **unico pack** |
| `ionicons` | 10 | rimosso |
| `lucide_icons_flutter` | 0 | rimosso |
| `cupertino_icons` | 0 | rimosso |

Material è già di fatto lo standard del progetto, non aggiunge dipendenze, è
coerente con Material 3, e supporta nativamente semantica e scaling. Convertire
269 punti verso un altro pack sarebbe costo puro.

I 10 usi di Ionicons (fra cui l'icona profilo della navbar) si mappano su
equivalenti Material.

## Dimensioni

Le icone hanno una scala, non numeri arbitrari:

```dart
class CoachlyIconSize {
  static const xs = 16.0;   // inline nel testo
  static const sm = 20.0;   // dentro chip e bottoni compatti
  static const md = 24.0;   // default, navigazione, azioni
  static const lg = 32.0;   // stati vuoti, intestazioni
  static const xl = 48.0;   // illustrazioni
}
```

`md` è il default. Un'icona a 21 px perché "stava meglio" non esiste: la navbar
attuale usa `size: isSelected ? 24 : 21`, che va sostituito da uno scale
animato su una dimensione sola.

## Colore

Un'icona usa **lo stesso ruolo di colore del testo che accompagna**. Un'icona
`iconMuted` accanto a un testo `textPrimary` è un errore di gerarchia, non una
scelta.

Nessun colore letterale: valgono le regole di `09-design-tokens.md`.

## Semantica

| Caso | Regola |
|---|---|
| Icona decorativa accanto a testo | `ExcludeSemantics` — lo screen reader legge già il testo |
| Icona che è l'unico contenuto di un'azione | **obbligatorio** un `Semantics` con label tradotta |
| Icona che comunica stato | la label descrive lo stato, non l'icona |

L'ultima riga è la più sbagliata di frequente: la label di un badge di sync dice
"Non sincronizzato", non "icona nuvola".

Un `semanticLabel` su `Icon` non è sufficiente per un elemento interattivo:
serve un `Semantics(button: true, …)` sul nodo tappabile, con lo stato
`selected` dove applicabile.

## Scaling con il testo

Le icone inline nel testo scalano con `textScaler`; le icone di navigazione e
azione no, ma il loro **target** resta ≥ 48×48 dp indipendentemente dalla
dimensione dell'icona. Vedi `14-accessibility.md`.

## Icone di dominio

Alcuni concetti Coachly non hanno un'icona Material adeguata: tipi di serie,
attrezzi, pattern di movimento, gruppi muscolari.

Regole: SVG in `assets/icons/`, disegnate sulla stessa griglia di Material (24
px, tratto 2), esposte tramite una mappa tipizzata — mai un percorso di file
scritto a mano in una feature.

```dart
enum CoachlyIcon {
  barbell, dumbbell, machine, cable, bodyweight,
  superset, dropSet, amrap, restTimer;
}
```

## Vietato

- Emoji come icone nella UI di prodotto.
- `IconData` costruiti a mano da un code point.
- Due icone diverse per lo stesso concetto in schermate diverse.
