---
livello: Riferimento
stato: active
---

# Documentazione di prodotto

`docs/development/` dice **come** è fatta la app. Questa cartella dice **cosa
fa e perché è fatta così**: schermata per schermata, l'intento prima
dell'implementazione.

Serve a una domanda che l'architettura non risponde: davanti a una scelta di
interfaccia — questo bottone dove va, questo campo quanti tap costa, questo
errore lo mostro o lo inghiotto — qual è il criterio? Senza una risposta
scritta, ogni schermata sviluppa il suo, e la app diventa la somma di scelte
locali ragionevoli e globalmente incoerenti.

## Il contesto d'uso, che decide quasi tutto

Coachly si usa **in palestra, in piedi, fra una serie e l'altra**, con il
telefono in una mano sola e l'altra occupata o sudata, con trenta secondi di
attenzione residua e un timer che scorre. Non si usa seduti alla scrivania.

Da questo discendono conseguenze che nessun documento di stile potrebbe
dedurre da solo, e che ricorrono in tutte le schermate:

| Vincolo del contesto | Conseguenza di prodotto |
|---|---|
| Dita sudate, presa imprecisa | i controlli d'allenamento sono **56 px**, non 48 (`touchTargetWorkout`) |
| Una mano sola | le azioni frequenti stanno in basso, dove arriva il pollice |
| Attenzione a scatti | lo stato dell'allenamento è **sempre visibile**, non dietro un tab |
| Rete assente o pessima | nessuna schermata aspetta il server per mostrare un dato |
| Errore di tap costoso | le azioni distruttive chiedono conferma; il completamento chiede una **pressione prolungata** |
| Il tempo scorre davvero | il timer di recupero è un elemento di primo livello, non una notifica |

L'ultima riga della tabella è la più sottile: durante un allenamento
l'utente non "usa una app", **fa un'altra cosa** e la app lo assiste. Ogni
interazione che richiede di fermarsi a leggere è un costo pagato in mezzo a
uno sforzo fisico.

## Le schermate

| Documento | Copre |
|---|---|
| [01 — Allenamento attivo](01-active-workout.md) | la schermata su cui è tarata tutta la app |
| [02 — Home schede](02-workouts-home.md) | il punto di partenza: cosa alleno oggi |
| [03 — Scheda: dettaglio, modifica, creazione](03-workout-authoring.md) | dove la scheda si costruisce |
| [04 — Esercizi](04-exercises.md) | catalogo, dettaglio, esercizi personali |
| [05 — Ingresso e profilo](05-entry-and-profile.md) | avvio, login, profilo, impostazioni |

## Come si legge una scheda schermata

Ogni documento ha la stessa struttura, e le prime due voci sono quelle che
contano:

1. **A cosa serve** — in una frase, dal punto di vista di chi la usa.
2. **Il vincolo dominante** — la cosa che, se ignorata, rende la schermata
   inutile anche se tutto il resto funziona.
3. **Struttura** — cosa c'è sullo schermo e perché in quell'ordine.
4. **Interazioni** — cosa succede a ogni tap, con il costo in tap.
5. **Stati** — vuoto, caricamento, errore, offline.
6. **Cosa non fa, deliberatamente** — le assenze volute, così che nessuno le
   "ripari".
