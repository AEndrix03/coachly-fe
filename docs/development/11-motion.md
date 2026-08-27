---
livello: Standard
stato: active
---

# 11 — Movimento e animazioni

## Contesto d'uso

Coachly si usa in palestra, fra una serie e l'altra, spesso con poco tempo e
poca attenzione. Un'animazione che ritarda un'informazione non è raffinatezza:
è attrito.

Principio: **il movimento spiega, non decora.** Se non chiarisce una relazione
spaziale, una continuità o un cambio di stato, non serve.

## Token

```dart
class CoachlyMotion {
  // durate
  static const instant  = Duration(milliseconds:  90);   // feedback tap
  static const quick    = Duration(milliseconds: 160);   // stato, hover
  static const standard = Duration(milliseconds: 240);   // transizioni comuni
  static const slow     = Duration(milliseconds: 360);   // entrate, sheet
  static const deliberate = Duration(milliseconds: 500); // celebrazioni

  // curve
  static const enter    = Curves.easeOutCubic;
  static const exit     = Curves.easeInCubic;
  static const standardCurve = Curves.easeInOutCubic;
  static const emphasized    = Curves.easeOutBack;
}
```

Nessuna `Duration` letterale nel codice di prodotto. Oggi ne esistono almeno
sette diverse fra 90 e 500 ms scelte caso per caso.

## Quando animare

| Situazione | Movimento |
|---|---|
| Cambio di stato di un controllo | `instant` / `quick` |
| Comparsa o scomparsa di contenuto | `standard`, enter/exit |
| Navigazione fra pagine | `standard`, transizione condivisa |
| Bottom sheet, dialog | `slow` in entrata, `quick` in uscita |
| Serie completata | `deliberate`, una volta |
| Timer di recupero | nessuna animazione continua: aggiornamento al secondo |

L'uscita è sempre più rapida dell'entrata: chiudere deve sembrare immediato.

## Quando non animare

- Su liste lunghe durante lo scroll.
- Su elementi che cambiano ad alta frequenza (timer, contatori).
- Su contenuto che l'utente sta già leggendo.
- Su più di **due** elementi contemporaneamente nella stessa area.
- Mai un'animazione che ritarda un input. L'input risponde subito, l'animazione
  accompagna.

## Reduce motion

Obbligatorio, non opzionale:

```dart
final reduce = MediaQuery.disableAnimationsOf(context);
final duration = reduce ? Duration.zero : CoachlyMotion.standard;
```

Con reduce motion attivo: nessuna animazione di posizione o scala, i cambi di
stato restano istantanei, le opacità possono restare ma brevi. Va verificato in
un test.

## Costo

Le animazioni costose vanno isolate:

- ogni elemento animato indipendentemente sta dentro un **`RepaintBoundary`**;
- `AnimatedBuilder` avvolge **solo** la parte che cambia, non l'intero sottoalbero;
- `Opacity` animata → `FadeTransition` o `AnimatedOpacity`, mai `Opacity` con un
  valore che cambia a ogni frame;
- `Transform.scale` è preferibile a un cambio di layout.

Oggi: 19 `AnimationController` contro 7 `RepaintBoundary`, e la navbar anima uno
`Stack` sopra un `BackdropFilter` senza isolamento — il caso peggiore.

### Blur

`BackdropFilter` forza un layer di composizione e ridisegna l'area sottostante a
ogni frame. **Mai su un widget animato.** Consentito solo su superfici `overlay`
e `modal`, statiche, dentro un `RepaintBoundary`.

## Liste

Niente animazioni a cascata su liste con più di ~20 elementi: costano quanto
rendono, e su una libreria di migliaia di esercizi sono inaccettabili.

Per inserimenti e rimozioni: `AnimatedList` con `quick`, o nessuna animazione.
Per il feedback di scorrimento: si anima l'indicatore, non le celle.

## Hero

14 usi oggi. Va bene per una continuità reale (card → dettaglio dello stesso
oggetto). Regole: tag univoco e stabile, mai su elementi con dimensioni
imprevedibili, mai fra pagine che non condividono davvero l'elemento.

## Librerie

`flutter_animate` (2 file) è ammesso per composizioni dichiarative complesse, ma
le durate e le curve vengono dai token.

Rimossi perché **con zero utilizzi**: `flutter_staggered_animations`, `lottie`,
`glass_kit`.

Se in futuro servirà Lottie per una celebrazione, si rivaluta con un ADR — non
si tiene una dipendenza in attesa che serva.

## Test

- un golden con reduce motion attivo per i componenti animati;
- nessun test dipende dal completamento di un'animazione:
  `tester.pumpAndSettle()` con timeout esplicito.
