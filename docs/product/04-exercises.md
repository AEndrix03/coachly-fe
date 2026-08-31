---
livello: Riferimento
stato: active
---

# 04 — Esercizi

Rotte: `/exercises/:exerciseId` (+ `biomechanics`, `muscles`, `variants`) ·
`/exercises/create` · `/profile/personal-exercises`

## A cosa serve

Sapere **cos'è** un esercizio e **come si fa**, e poter aggiungere i propri
quando il catalogo non basta.

## Il vincolo dominante

Questa parte della app si consulta in due momenti opposti: in palestra, con
trenta secondi e una domanda precisa («da che parte si spinge?»), e a casa, con
calma e curiosità. La stessa pagina deve funzionare per entrambi, e il modo per
riuscirci non è un compromesso a metà: è **stratificare**.

La risposta breve sta in cima e si legge senza scorrere. Tutto il resto —
biomeccanica, muscoli coinvolti, varianti — sta sotto o dietro una rotta
dedicata, e chi ha trenta secondi non lo incontra mai.

## Struttura del dettaglio

| Livello | Contenuto | Chi lo legge |
|---|---|---|
| Testata | nome, identità dell'esercizio | tutti |
| Descrizione ed esecuzione | i passi, gli errori comuni | chi ha una domanda |
| Navigazione rapida | ancore alle sezioni | chi sa cosa cerca |
| Rotte figlie | biomeccanica · muscoli · varianti | chi sta studiando |

Le tre rotte figlie sono rotte vere, non pannelli: sono indirizzabili,
condivisibili, e il tasto indietro del sistema fa la cosa giusta
(`docs/development/08-routing-navigation.md`).

## Esercizi personali

Il catalogo è grande ma finito, e le palestre hanno macchine che non esistono
in nessun catalogo. Un esercizio personale si crea:

- dalla pagina dedicata (`/exercises/create`),
- **oppure senza uscire dal picker**, mentre si sta componendo una scheda.

La seconda è quella che conta. Interrompere la composizione di una scheda per
andare a creare un esercizio e poi tornare indietro è il tipo di deviazione
dopo la quale si perde il filo.

L'esercizio personale nasce **locale**: viene scritto su Drift e messo in
outbox, e non attende nessuna risposta del server per essere usabile. Sul
backend è un backup, non una pubblicazione (`docs/development/05-sync-and-offline.md`).

## Stati

| Stato | Cosa vede l'utente |
|---|---|
| Caricamento | scheletro della pagina |
| Errore | testo tradotto e azione di ripetizione |
| Offline | il catalogo già scaricato resta consultabile |

Il messaggio del `Failure` non arriva mai all'utente: è diagnostico, e serve al
log. All'utente va un testo tradotto (`docs/development/07-errors-and-feedback.md`).

## Cosa non fa, deliberatamente

- **Non mostra video pesanti in cima.** La domanda urgente è testuale e deve
  arrivare prima di qualsiasi cosa debba essere scaricata.
- **Non fa scegliere fra "esercizi del catalogo" e "i miei".** Nel picker
  convivono: chi cerca un nome non vuole prima ricordare chi lo ha creato.
