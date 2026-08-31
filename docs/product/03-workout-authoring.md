---
livello: Riferimento
stato: active
---

# 03 — Costruire una scheda

Rotte: `/workouts/workout/:id` (dettaglio e modifica in posto) ·
`/workouts/workout/new/edit` (creazione) ·
`/workouts/workout/:id/add-exercise` · `/workouts/workout/:id/check`

## A cosa serve

Comporre e correggere una scheda: quali esercizi, in che ordine, con quali
serie, raggruppati come serve.

## Il vincolo dominante

Al contrario dell'allenamento attivo, qui **il tempo non stringe**. Si
costruisce una scheda da seduti, prima o dopo, con calma. Il vincolo qui non è
la velocità ma la **reversibilità**: chi costruisce una scheda prova, cambia
idea, sposta, torna indietro. Un'operazione difficile da annullare vale meno di
un'operazione più lenta ma sicura.

Questa differenza spiega perché le due schermate non si somigliano e non
devono somigliarsi. Sono lo stesso oggetto in due momenti diversi della vita
di chi lo usa.

## Dettaglio e modifica sono la stessa schermata

`WorkoutDetailPage` ha un flag `_editing` e cambia dentro invece di navigare
altrove. Non è una scorciatoia implementativa: modificare una scheda è quasi
sempre una **correzione puntuale** — un peso di partenza sbagliato, una serie
in più — e far navigare l'utente in una seconda schermata gli fa perdere il
posto in cui stava guardando.

Al salvataggio la scheda mostra un bordo animato di conferma
(`_WorkoutSavedBorderPainter`) e torna in sola lettura. Nessun dialogo: il
riscontro è dove l'occhio già si trova.

## La creazione è invece un flusso

`CreateWorkoutFlow` è a passi. Qui la navigazione guidata è giusta: chi crea
una scheda da zero non sa ancora cosa gli verrà chiesto, e mostrargli tutto
insieme è un modo per farlo smettere.

Durante la costruzione si possono creare **blocchi** — superset, triset, giant
set, circuiti, blocchi di preparazione e mobilità — con i rispettivi tempi di
recupero. Sono gli stessi tipi che l'allenamento attivo sa eseguire: la scheda
non può esprimere niente che poi non sia eseguibile.

## Il controllo scheda

Rotta `check`. Legge la bozza e produce un `WorkoutCheckReport`: un elenco di
rilievi, ciascuno con una **severità** e delle **evidenze**.

La severità ha quattro valori, e il quarto è quello che rende onesto lo
strumento:

| Severità | Significato |
|---|---|
| `positive` | va bene così |
| `information` | da sapere, non da correggere |
| `review` | vale la pena guardarci |
| `insufficientData` | **non ho abbastanza dati per dirtelo** |

Un giudizio dato con dati parziali è peggio di nessun giudizio: chi lo riceve
non ha modo di sapere quanto vale, e una volta che ha imparato che a volte
sbaglia smette di leggerlo tutto. Per lo stesso motivo il report porta il
proprio `dataQuality` complessivo — `complete`, `partial`, `insufficient` — e
il `draftRevision` su cui è stato calcolato: un report è un'affermazione su
**una versione specifica** della scheda, non sulla scheda in generale.

Il controllo non blocca niente e non corregge niente. Osserva.

## Aggiungere un esercizio

Due strade, per due modi diversi di sapere cosa si vuole:

- **Il catalogo** (`add-exercise`, `exercise_picker_sheet`) — si cerca per
  nome, si filtra. Il picker mostra anche **da quanto tempo** un esercizio non
  viene eseguito, letto dallo storico delle sessioni locali: è il dato che
  serve davvero quando si compone, e non esiste da nessun'altra parte.
- **Un esercizio personale** — creato al volo dal picker stesso, senza
  uscire dal flusso, se quello che si cerca non è a catalogo.

## Stati

| Stato | Cosa vede l'utente |
|---|---|
| Salvataggio | il bordo di conferma; nessuna attesa bloccante |
| Salvato offline | la scheda è salva sul dispositivo; la sync arriva dopo |
| Errore di rete | non compare: non c'è nessuna scrittura che dipenda dalla rete |

## Cosa non fa, deliberatamente

- **Non chiede conferma per ogni modifica.** La bozza è locale e il salvataggio
  è esplicito.
- **Non valida la scheda in modo bloccante.** Il controllo suggerisce; chi si
  allena decide. Una scheda "irregolare" può essere esattamente quello che
  serve a quella persona in quella settimana.
- **Non richiede la rete per creare un esercizio personale.** Nasce locale e
  sale con l'outbox, come tutto il resto.
