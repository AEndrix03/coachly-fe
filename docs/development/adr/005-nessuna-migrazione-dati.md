# ADR-005 — Nessuna migrazione dati

Stato: accettato
Data: 2026-08-28

## Contesto

ADR-004 sostituisce Hive con Drift. In un'app già distribuita, questo
richiederebbe: leggere 10 box, mapparle su uno schema relazionale, farlo in modo
atomico e resumibile, gestire il fallimento a metà, e soprattutto non perdere la
coda `session_sync_jobs`, che contiene allenamenti registrati e mai inviati al
server — l'unica copia esistente di dati prodotti dall'utente in palestra.

Sarebbe il pezzo di lavoro più rischioso dell'intera riarchitettura.

Coachly però **non ha ancora utenti in produzione**.

## Decisione

**Nessuna migrazione dati, nessuna retrocompatibilità.** Hive viene rimosso, il
database viene creato da zero, non esiste un percorso di upgrade dai box
esistenti.

Da questo discende una regola generale, valida per tutti i documenti della
cartella:

> Ogni volta che una scelta si presenta come "soluzione corretta" contro
> "soluzione compatibile con l'esistente", si sceglie la prima.

La stessa logica autorizza le decisioni che sarebbero costose dopo: SQLCipher
dalla prima versione (`24-security-and-privacy.md`), Dio al posto di `http`
(ADR-006), l'event log append-only al posto dello stato mergiato delle sessioni
(`04-data-layer.md`).

## Conseguenze

- Si elimina la parte più rischiosa della riarchitettura.
- Chi ha una build di sviluppo installata perde i propri dati locali al primo
  avvio della nuova versione. È accettabile e va comunicato al team.
- Le decisioni prese in questa finestra vanno prese **ora**: dopo la prima
  release pubblica costeranno una migrazione ciascuna.
- **Questo ADR ha una scadenza.** Alla prima release sugli store va sostituito
  con una politica di compatibilità e migrazione. Finché resta `accettato` dopo
  quel momento, è una bugia nella documentazione.

## Alternative scartate

**Scrivere comunque la migrazione.** Costo alto, rischio alto, beneficio zero:
non ci sono dati da proteggere.

**Rinviare la migrazione a Drift a dopo il lancio.** Avrebbe reso obbligatorio
esattamente il lavoro che questa decisione evita, oltre a costruire altre
funzionalità sopra una fondazione che si è già deciso di sostituire.
