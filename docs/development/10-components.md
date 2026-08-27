---
livello: Standard
stato: active
---

# 10 — Componenti

## Tre categorie

| Categoria | Cosa | Dove | Esempi |
|---|---|---|---|
| **Primitivi** | mattoni senza semantica di prodotto | `design_system/components/primitives/` | `CoachlyButton`, `CoachlyCard`, `CoachlyChip`, `CoachlyTextField`, `CoachlyBottomSheet` |
| **Stati** | le cinque situazioni di caricamento | `design_system/states/` | `CoachlySkeleton`, `CoachlyEmptyState`, `CoachlyErrorState` |
| **Di prodotto** | incarnano un concetto Coachly | `design_system/components/product/` | `SetInput`, `RestTimer`, `ExerciseTile`, `MetricChip`, `MuscleMap`, `SyncBadge` |

Tutto il resto vive in `features/<x>/presentation/widgets/` e **non esce di lì**.

## Quando un widget sale nel design system

Serve **almeno una** di queste condizioni:

1. è usato da due feature diverse;
2. incarna un concetto di prodotto che deve apparire identico ovunque (una serie,
   un carico, un muscolo, uno stato di sync);
3. definisce un comportamento di accessibilità che non vogliamo veder
   reimplementato (target, semantica, focus).

Non è sufficiente che sia "bello" o "riutilizzabile in teoria".

Fino ad allora resta nella feature. **Duplicare una volta è meno costoso che
astrarre troppo presto**: la seconda occorrenza insegna quale sia davvero la
variabilità.

## Cosa non si wrappa

Niente `CoachlyText`, `CoachlyRow`, `CoachlyContainer`, `CoachlyPadding`.
Avvolgere widget Material che non aggiungono semantica produce solo un livello di
indirection e un secondo vocabolario da imparare.

Un componente esiste se **decide qualcosa**: token, stato, accessibilità,
comportamento. Se si limita a inoltrare parametri, non esiste.

## Anatomia

```dart
class CoachlyButton extends StatelessWidget {
  const CoachlyButton({
    super.key,
    required this.label,        // già tradotto: il componente non traduce
    required this.onPressed,    // null ⇒ disabilitato
    this.variant = CoachlyButtonVariant.primary,
    this.size = CoachlyButtonSize.medium,
    this.icon,
    this.isLoading = false,
  });
  …
}
```

Regole:

1. **`const` obbligatorio** dove possibile.
2. **Le varianti sono enum**, non booleani. `isPrimary` + `isDanger` + `isGhost`
   produce stati impossibili; un enum no.
3. **Niente `Color`, `TextStyle`, `EdgeInsets` nei parametri.** Chi usa il
   componente sceglie una variante, non una palette. È così che il design system
   resta coerente.
4. **Il componente non traduce.** Riceve testo già localizzato: dipendere da
   `context.l10n` lo rende impossibile da testare con golden.
5. **Il componente non legge provider.** Riceve dati e callback. Un componente
   che fa `ref.watch` è accoppiato a una feature e non è un componente.
6. **Ogni componente interattivo dichiara la propria semantica** e garantisce il
   target minimo. Vedi `14-accessibility.md`.

## Stati obbligatori

Ogni componente interattivo gestisce esplicitamente: `default`, `hover` (dove
applicabile), `pressed`, `disabled`, `loading`, `error`, `focused`.

`disabled` non è "opacità 0.5": è un token di colore e un cambio di semantica
(`Semantics(enabled: false)`).

## Composizione, non configurazione

Un componente con più di **6 parametri** o con parametri che si escludono a
vicenda va scomposto.

```dart
// NO
CoachlyCard(title:…, subtitle:…, leading:…, trailing:…, badge:…,
            footer:…, onTap:…, isSelected:…, isCompact:…, showDivider:…)

// SÌ
CoachlyCard(
  child: Column(children: [
    CoachlyCardHeader(title: …, trailing: …),
    …
  ]),
)
```

## Componenti di prodotto: perché sono la parte che conta

`SetInput` non è un `TextField` con un bordo. Incapsula: input numerico con
tastiera corretta, incremento rapido, unità (kg/lb da preferenza), validazione
del range, stato completato/saltato, target ≥ 48 dp, semantica leggibile da uno
screen reader, e comportamento con le mani sudate durante una serie.

Se questa conoscenza vive in una pagina, verrà riscritta in modo diverso nella
pagina successiva. È lì che un design system paga.

Catalogo iniziale:

| Componente | Incapsula |
|---|---|
| `SetInput` | inserimento di una serie |
| `RestTimer` | conto alla rovescia, suono, comportamento in background |
| `ExerciseTile` | esercizio in lista: nome, muscolo, media, origine |
| `MetricChip` | valore + unità + trend |
| `MuscleMap` | mappa muscolare con token di intensità |
| `SyncBadge` | stato di sincronizzazione |
| `WorkoutBlockCard` | blocco: straight, superset, circuito |

## File di grandi dimensioni

I file che oggi violano più gravemente questo documento:

| File | Righe |
|---|---|
| `workout_builder_widgets.dart` | 2495 |
| `exercise_info_page.dart` | 1530 |
| `exercise_picker_sheet.dart` | 1443 |
| `adaptive_workout_workspace.dart` | 1431 |
| `today_home_widgets.dart` | 1185 |

Non vanno divisi per raggiungere un numero: vanno divisi estraendo i componenti
di prodotto che contengono, che è il modo in cui il catalogo qui sopra si
popolerà davvero.

## Golden test

Ogni componente del design system ha un golden test per ciascuna variante
rilevante, più uno a `textScaler` 2.0. È il meccanismo che impedisce alle
modifiche ai token di cambiare silenziosamente l'interfaccia.
