---
livello: Standard
stato: active
---

# 15 — Performance

In un'app local-first la performance percepita non dipende dalla rete: dipende
da quanto velocemente si legge il database e da quanti widget si ricostruiscono.

## Budget

| Metrica | Target | Come si misura |
|---|---|---|
| Cold start → primo frame | < 800 ms | trace `app_start` |
| Cold start → contenuto utile | < 1500 ms | trace `first_useful_paint` |
| Apertura pagina esercizio | < 150 ms | trace `exercise_detail_open` |
| Ricerca nella libreria (migliaia di elementi) | < 100 ms | trace `exercise_search` |
| Frame | 16 ms (60 fps), 8 ms su display 120 Hz | DevTools, profile mode |
| Jank durante lo scroll | 0 frame > 32 ms | timeline |

Un budget senza misura è un desiderio: ogni riga qui ha una traccia associata in
`18-observability.md`.

## Avvio

Oggi `main()` fa `await LocalDatabaseService().initialize()` prima di `runApp`,
aprendo 10 box in sequenza. Il primo frame aspetta tutto.

Regole:

1. `runApp` non aspetta il database. Si apre la connessione in modo lazy.
2. Solo ciò che serve al **primo frame** è bloccante: tema, locale, stato di auth.
3. La copia del catalogo pre-seeded (`04-data-layer.md`) avviene una volta sola,
   con uno stato di avvio dedicato e visibile, non su uno splash muto.
4. Il delta del catalogo non è mai bloccante.

## Liste

**29 `ListView(` non virtualizzate contro 11 `.builder`.** Su una libreria di
migliaia di esercizi è la differenza fra fluido e inutilizzabile.

| Regola | Perché |
|---|---|
| `ListView.builder` sempre, oltre ~10 elementi noti | costruisce solo il visibile |
| `itemExtent` o `prototypeItem` quando l'altezza è costante | evita il calcolo di layout |
| `Key` stabile su ogni elemento | evita ricostruzioni inutili al riordino |
| Mai `Column` dentro `SingleChildScrollView` per liste dati | costruisce tutto |
| `SliverList` quando la lista convive con altro contenuto scorrevole | un solo scroll |

Il filtro e l'ordinamento avvengono **in SQL**, non in Dart su una lista
materializzata. Oggi `getFilteredExerciseSummaries` è una scansione lineare con
nove predicati scritti a mano: in SQL è una `WHERE` con indici.

## Rebuild

`.select()` è lo strumento principale, vedi `03-state-riverpod.md`. Oltre a
quello:

- `const` su ogni widget che lo permette — è l'ottimizzazione con il miglior
  rapporto costo/beneficio in Flutter;
- `Theme.of(context)` una volta per `build`, non undici (oggi 111 occorrenze
  totali, spesso ripetute nello stesso metodo);
- estrarre i sottoalberi che non dipendono dallo stato che cambia;
- `ValueListenableBuilder` per animazioni locali, invece di `setState` sull'intera
  pagina.

## Repaint

`RepaintBoundary` attorno a: elementi animati indipendentemente, grafici,
mappe muscolari, il timer, la navbar.

Oggi: 7 `RepaintBoundary` per 19 `AnimationController` e 5 `BackdropFilter`.

`BackdropFilter` è il costo singolo più alto presente nel codice. Vedi
`09-design-tokens.md` e `11-motion.md`.

## Immagini

- dimensionare sempre con `cacheWidth`/`cacheHeight`: decodificare un'immagine a
  risoluzione piena per mostrarla a 80 px spreca memoria in proporzione al
  quadrato;
- placeholder di dimensioni **identiche** all'immagine finale, per non far
  saltare il layout;
- `precacheImage` solo per ciò che compare subito.

Vedi `16-media.md`.

## Memoria

- niente `.toList()` quando basta un iterabile pigro (215 occorrenze oggi, molte
  su percorsi caldi);
- niente lettura dell'intero catalogo in memoria per filtrarlo: è il pattern che
  Drift elimina;
- i log di risoluzione vocale e gli eventi di sessione si potano: `sent` più
  vecchi di N giorni si eliminano.

## Misurare

Regola: **nessuna ottimizzazione senza misura prima e dopo**, e sempre in
`--profile`, mai in debug.

Strumenti: DevTools Performance per i frame, `flutter build --analyze-size` per
il bundle, i trace custom per i percorsi di prodotto.

Un test di regressione sulla dimensione del bundle in CI evita che le dipendenze
tornino a crescere: le cinque rimosse a zero utilizzi ci sono arrivate senza che
nessuno se ne accorgesse.
