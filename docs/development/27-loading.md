---
livello: Standard
stato: active
---

# 27 — Attesa

Complementare a `07-errors-and-feedback.md`, che copre gli altri quattro stati
di una schermata. Questo copre il primo, ed è quello su cui è più facile
sbagliare in una app local-first.

## Il problema, che non è estetico

Prima di `CoachlyLoading` il repository conteneva **tredici**
`CircularProgressIndicator` scritti a mano, in tredici schermate, ognuno con la
sua dimensione, il suo colore e la sua idea di quando comparire.

Il difetto non era la disomogeneità. Era che nessuno dei tredici sapeva di
essere in una app che legge da Drift: la lettura normale finisce in pochi
millisecondi, e un indicatore che compare appena parte un `Future` **lampeggia**
— appare e sparisce prima che l'occhio lo metta a fuoco. Un lampo non si legge
come «sto caricando». Si legge come «è successo qualcosa».

Il caricamento vero esiste — la prima idratazione, un catalogo non ancora
scaricato — ma è l'eccezione. Ed è l'eccezione a meritare un'immagine.

## Le due soglie

| Token | Valore | Cosa impedisce |
|---|---|---|
| `motion.loadingDelay` | 300 ms | che l'indicatore compaia per attese che finiscono da sole |
| `motion.loadingMinimum` | 450 ms | che, una volta comparso, sparisca dopo 10 ms |

La seconda esiste per una ragione che si vede solo scrivendola: senza,
un'attesa di 310 ms mostrerebbe l'immagine per dieci millisecondi. È lo stesso
lampo che la prima soglia doveva evitare, spostato più in là.

Vivono in `CoachlyLoadingGate`, una volta sola. Le stesse due soglie replicate
in tredici schermate divergono al primo che ha fretta — ed è esattamente come
sono nati i tredici indicatori.

## I pezzi

| Componente | Quando |
|---|---|
| `CoachlyLoadingScreen` | l'intera schermata non ha ancora niente da mostrare (avvio) |
| `CoachlyLoadingSection` | una porzione, mentre il resto della pagina è già utile |
| `CoachlyLoadingGate` | avvolge il contenuto e decide **se** l'attesa si vede |
| `CoachlyLoadingScenes` | il repertorio di illustrazioni condivise |

Uno spinner **dentro un bottone** non è un'attesa in questo senso: è lo stato
di un controllo, resta com'è. La regola riguarda le aree che sostituiscono
contenuto.

## Le immagini

Stanno in un elenco solo, `CoachlyLoadingScenes.all`. Aggiungerne è aggiungere
righe lì, e **nient'altro**: nessuna schermata nomina un asset, quindi nessuna
schermata va toccata quando l'insieme cresce.

Due proprietà non ovvie, entrambe con una ragione:

- **La scelta è deterministica, non casuale.** Un widget si ricostruisce molte
  volte durante la stessa attesa; con una scelta casuale l'immagine cambierebbe
  sotto gli occhi di chi guarda. La stessa `sceneKey` dà sempre la stessa scena,
  chiavi diverse distribuiscono le scene sul repertorio.
- **Le scene si precaricano all'avvio** (`CoachlyLoadingScenes.precache`, nel
  `builder` di `MaterialApp`). Un'immagine decodificata nel momento in cui
  serve arriva *dopo* l'attesa che doveva coprire — il caso in cui il rimedio
  ha lo stesso difetto della malattia.

Oggi il repertorio ha una voce sola: il marchio, che è già quello che l'avvio
mostrava.

## Movimento e accessibilità

L'illustrazione **respira** — un'opacità che pulsa — invece di ruotare. Una
rotazione afferma «sto lavorando su qualcosa di lungo», che qui è quasi sempre
falso.

Con «riduci animazioni» attivo l'immagine sta ferma e piena, e resta leggibile:
l'animazione è l'ornamento, l'informazione è l'immagine (`11-motion.md`).

Il blocco è una `liveRegion` con il messaggio come etichetta, così il lettore
di schermo annuncia l'attesa quando compare invece di lasciarla trovare
(`14-accessibility.md`). La scena e il testo sono esclusi dalla semantica
perché ripeterebbero la stessa cosa tre volte.

## Test

`test/design_system/coachly_loading_test.dart` prova le soglie a 299 e 301 ms e
la permanenza minima a 10 e 460 ms, cioè il comportamento e non il disegno.
Prova anche che la scena sia stabile per la stessa chiave e che l'attesa sia
annunciata.
