---
livello: Costituzione
stato: active
---

# 14 — Accessibilità

L'accessibilità sta nel design system, non in una pulizia finale. Se un
componente garantisce il target minimo e la semantica corretta, non è possibile
sbagliare usandolo.

## Il contesto d'uso conta

Coachly si usa in piedi, con le mani occupate o sudate, con il telefono a mezzo
metro, con poca attenzione residua fra una serie e l'altra, a volte con le
cuffie e senza guardare.

Questo rende l'accessibilità un requisito di **usabilità generale**, non una
funzione per una minoranza. Le stesse scelte che aiutano chi usa uno screen
reader aiutano chi ha appena finito una serie di squat.

## Target

| Piattaforma | Minimo |
|---|---|
| Android | 48×48 dp |
| iOS | 44×44 pt |

Coachly adotta **48×48 dp ovunque**, e **56×56 dp** per i controlli usati durante
l'allenamento attivo (completa serie, +/- carico, timer).

L'area tappabile può essere più grande dell'elemento visibile: un'icona da 24 px
sta dentro un target da 48. Verificato in test con
`androidTapTargetGuideline`.

## Semantica

| Elemento | Requisito |
|---|---|
| Azione | `Semantics(button: true, label: …)`, label tradotta |
| Elemento selezionato | `selected: true` — vale per le tab della navbar |
| Icona decorativa | `ExcludeSemantics` |
| Gruppo che si legge come una cosa sola | `MergeSemantics` |
| Valore modificabile | `Semantics(value: …, increasedValue: …, decreasedValue: …)` |
| Stato live (timer) | `liveRegion: true`, con parsimonia |

Oggi: 38 `Semantics`, 22 `semanticLabel`, **0 `MergeSemantics`**. Una card di
esercizio con nome, muscolo, serie e peso si legge oggi come quattro nodi
separati; dovrebbe leggersi come uno.

## Contrasto

| Contenuto | Minimo |
|---|---|
| Testo normale | 4.5:1 |
| Testo grande (≥ 18 pt o 14 pt bold) | 3:1 |
| Elementi grafici e bordi | 3:1 |

I token semantici dichiarano le coppie superficie/contenuto già in contrasto
(`09-design-tokens.md`), quindi non è una verifica lasciata a chi scrive la UI.
Un test con `textContrastGuideline` la conferma.

Il colore non è mai l'unico veicolo di informazione: lo stato di una serie ha
icona e testo oltre al colore.

## Text scaling

**`textScaler` ha zero occorrenze nel codice.** La app a text scaling alto non è
mai stata verificata.

Regole:

1. Nessun `MediaQuery` che sovrascrive `textScaler`.
2. Nessuna altezza fissa su un contenitore di testo. `SizedBox(height: 48)` con
   dentro del testo è un overflow che aspetta.
3. Layout basati su `Wrap`, `Flexible`, `IntrinsicHeight` dove il testo può
   crescere.
4. Verifica obbligatoria a **2.0×** su tutte le schermate principali.

Il limite superiore ragionevole è 2.0: oltre, si accetta che alcune schermate
diventino scorrevoli, mai troncate.

## Focus e tastiera

Meno critico su mobile, ma i form del builder ne beneficiano: ordine di focus
logico, `TextInputAction` corretta per passare al campo successivo, e nessuna
trappola di focus nei bottom sheet.

## Movimento

`MediaQuery.disableAnimationsOf(context)` va rispettato ovunque.
Vedi `11-motion.md`.

## Comportamenti specifici dell'allenamento

| Requisito | Motivo |
|---|---|
| Schermo sempre acceso durante una sessione attiva | non si sblocca il telefono con le mani occupate |
| Il timer di recupero suona anche a schermo spento | l'utente non guarda |
| Controlli principali nella metà inferiore | uso a una mano |
| Carico e timer in `displayL` | leggibili a un metro |
| Nessuna azione distruttiva senza undo | tocchi accidentali sono la norma |

Lo schermo sempre acceso va disattivato al termine della sessione: è una
promessa sulla batteria.

## Test in CI

```dart
testWidgets('workout page rispetta le linee guida', (tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(...);
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  handle.dispose();
});
```

Più un test di overflow a `textScaler` 2.0 per ogni schermata principale.

Questi test sono **bloccanti**: una schermata nuova senza di essi non passa la
definition of done (`20-conventions-and-enforcement.md`).

## Riferimenti

- [Flutter — Accessibility](https://docs.flutter.dev/ui/accessibility)
- [Flutter — Accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing)
- [MinimumTapTargetGuideline](https://api.flutter.dev/flutter/flutter_test/MinimumTapTargetGuideline-class.html)
