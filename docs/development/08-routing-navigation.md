---
livello: Standard
stato: active
---

# 08 — Routing e navigazione

## Cosa non va oggi

Tre problemi concreti nella navbar attuale, in ordine di gravità.

**1. `context.go` invece di `goBranch` — perdita di stato.**

```dart
// AppNavigationBar._onTap, oggi
void _onTap(int index, int currentIndex) {
  if (index == currentIndex) return;
  context.go(_tabs[index].location);   // ← azzera lo stack del branch
}
```

`StatefulShellRoute` esiste per dare a ogni tab un `Navigator` indipendente con
il proprio stack. `context.go` naviga come un link esterno e quello stack lo
distrugge: entri in un workout, cambi tab, torni e hai perso la posizione. È la
ragione per cui "funziona maluccio".

**2. Le tab sono una lista hardcoded che duplica il router.**

`_tabs` contiene `location` come stringa (`'/community'`, `'/workouts'`,
`'/profile'`). Il router dichiara gli stessi percorsi in `StatefulShellBranch`.
Due fonti di verità che possono divergere senza che niente se ne accorga.

**3. Tap sul tab attivo non fa nulla.** `if (index == currentIndex) return;`
elimina il gesto standard "torna alla root di questa sezione".

## Come si fa

```dart
void _onTap(int index) {
  navigationShell.goBranch(
    index,
    // tap sul tab già attivo → torna alla root del branch
    initialLocation: index == navigationShell.currentIndex,
  );
}
```

E le tab si derivano dal router, non si riscrivono:

```dart
// app/router/routes.dart
enum AppTab {
  community(path: '/community', icon: Icons.people,          labelKey: 'nav.community'),
  workouts (path: '/workouts',  icon: Icons.fitness_center,  labelKey: 'nav.workouts'),
  profile  (path: '/profile',   icon: Icons.person,          labelKey: 'nav.profile');

  const AppTab({required this.path, required this.icon, required this.labelKey});
  final String path;
  final IconData icon;
  final String labelKey;
}
```

I `StatefulShellBranch` si generano da `AppTab.values`, e la navbar itera sullo
stesso enum. Aggiungere una sezione è una riga sola, e non è possibile che le due
liste divergano.

## Regole

| # | Regola |
|---|---|
| R1 | Le destinazioni sono un enum tipizzato in `app/router/routes.dart`. Nessuna stringa di percorso nel codice di prodotto. |
| R2 | Il cambio tab usa `goBranch`, mai `context.go`. |
| R3 | Il tap sul tab attivo torna alla root del branch. |
| R4 | Le rotte di dettaglio sono figlie del branch, così la navbar non scompare. |
| R5 | Il `redirect` decide **se** puoi entrare, non carica dati. |
| R6 | Nessuna pagina attende una `Future` di rete per essere costruita. |
| R7 | I parametri di rotta sono id, non oggetti. La pagina risolve l'id dal repository locale. |

R7 è già violata: `WorkoutDetailPage(workout: workout)` e
`WorkoutCheckPage(draft: draft)` ricevono oggetti via `state.extra`, il che rompe
il deep link e il ripristino di stato. La pagina deve ricevere `workoutId` e
leggere dal DB, che è locale e istantaneo.

## Guard

Il `redirect` è responsabile solo di:

```
non autenticato        → /login
in caricamento auth    → /loading
onboarding incompleto  → /onboarding
versione minima        → /update-required
```

Nessuna chiamata di rete dentro `redirect`. Nessun `await`. Il redirect legge
stato già disponibile.

Il redirect attuale è corretto nella forma e va mantenuto così.

## Struttura delle rotte

```
/loading
/login
/onboarding

StatefulShellRoute.indexedStack
├── /community
├── /workouts
│   ├── /workouts/organize
│   ├── /workouts/:id
│   │   ├── /workouts/:id/edit
│   │   ├── /workouts/:id/check
│   │   └── /workouts/:id/active
│   └── /workouts/create
└── /profile
    └── /profile/exercises

/exercises/:id                    ← fuori dallo shell: full screen
├── /exercises/:id/muscles
├── /exercises/:id/biomechanics
└── /exercises/:id/variants
/exercises/create
```

Le pagine esercizio stanno **fuori** dallo shell perché sono viste immersive che
possono essere aperte da qualsiasi tab. È la scelta attuale ed è corretta.

## Deep link

Oggi zero supporto. Diventa obbligatorio con la parte community e con la
condivisione di schede.

Prerequisito: R7. Una rotta che riceve un oggetto in `extra` non è raggiungibile
da un link, punto.

Da predisporre: schema `coachly://`, App Links Android, Universal Links iOS,
e una rotta di fallback per link non risolvibili.

## La navbar, in concreto

Da rifare rispettando `09-design-tokens.md` e `14-accessibility.md`:

| Aspetto | Oggi | Target |
|---|---|---|
| Navigazione | `context.go` | `goBranch` |
| Sorgente tab | lista hardcoded | enum `AppTab` |
| Tap su tab attivo | ignorato | torna alla root |
| Blur | `BackdropFilter(22)` permanente | superficie `overlay` opaca, o blur dentro `RepaintBoundary` |
| Animazioni | 3 `AnimationController` sempre vivi | `AnimatedScale` sul solo indicatore |
| Icone | Material + Ionicons misti | solo Material |
| Semantica | `semanticLabel` su `Icon` | `Semantics(button: true, selected: …)` |
| Target | area di 64px di altezza | ≥ 48×48 dp verificato in test |

## Riferimenti

- [go_router — StatefulShellRoute](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html)
- [Bottom navigation con rotte annidate](https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter/)
- [Flutter — Architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
