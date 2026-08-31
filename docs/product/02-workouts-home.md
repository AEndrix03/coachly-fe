---
livello: Riferimento
stato: active
---

# 02 — Home schede

Rotta: `/workouts` · `WorkoutPage` · `todayHomeViewDataProvider`

## A cosa serve

Rispondere a una domanda sola: **cosa alleno adesso**, e farlo partire.

## Il vincolo dominante

È la schermata che si apre entrando in palestra, spesso con lo zaino ancora in
spalla. Se dopo l'apertura serve più di **un tap** per essere dentro
l'allenamento giusto, la schermata ha fallito, per quanto sia informativa.

Da qui discende l'unica gerarchia che conta: c'è una cosa grande in alto e
tutto il resto è secondario. Non è una dashboard.

## Struttura

| Blocco | Contenuto |
|---|---|
| Testata | saluto, stato di sincronizzazione |
| **Oggi** | il blocco grande: cosa allenare, con l'azione di avvio |
| Contesto programma | dove si è nel programma, se ce n'è uno |
| Calendario (anteprima) | la settimana corrente, il prossimo allenamento |
| Obiettivo | l'obiettivo attivo, o l'invito a fissarne uno |
| Rail | approfondimenti, azioni rapide, guide, routine |

## Il blocco "Oggi" ha quattro forme

Non è un widget con dei campi opzionali: sono quattro stati distinti, perché
sono quattro situazioni umane diverse e meritano parole diverse.

| Situazione | Cosa mostra | Azione |
|---|---|---|
| **Allenamento in corso** | l'occhiello dice *in corso*, con minuti ed esercizi completati | riprendi |
| **Allenamento pronto** | titolo della scheda, focus, durata e serie previste | inizia |
| **Nessun allenamento oggi** | quando è il prossimo | nessuna |
| **Nessuna scheda** | invito a crearne una | crea |

Il primo caso è quello che sembra raro e non lo è: la app viene chiusa a metà
allenamento continuamente — una chiamata, la batteria, il sistema che uccide
il processo in background. Trovare "riprendi" al posto di "inizia" è la
differenza fra riprendere e ricominciare da capo.

## Lo stato di sincronizzazione

Tre valori — `synced`, `syncing`, `offline` — mostrati **solo qui**, in un
punto piccolo della testata.

Sta qui e non nell'allenamento attivo di proposito. Prima di cominciare, sapere
che qualcosa non è ancora salito è un'informazione utile e innocua. Durante
l'allenamento la stessa informazione è solo rumore ansiogeno su un'operazione
che l'utente non può né deve controllare. `offline` non è un errore e non usa
il colore dell'errore: è una modalità di funzionamento normale
(`docs/development/05-sync-and-offline.md`).

## Stati

| Stato | Cosa vede l'utente |
|---|---|
| Caricamento | `TodayHomeSkeleton`, la forma della pagina che si sta riempiendo |
| Errore | messaggio con azione di ripetizione |
| Vuoto | il quarto caso del blocco Oggi, che è un invito, non un vuoto |

Lo scheletro invece di uno spinner è una scelta: la pagina ha una forma stabile
e mostrarla mentre si popola evita il salto di layout che un'attesa indistinta
produce alla comparsa dei dati.

## Cosa non fa, deliberatamente

- **Non mostra statistiche di progresso in cima.** Sono la cosa che si guarda
  a divano, non in palestra, e occuperebbero il posto dell'unica azione.
- **Non aspetta la rete.** La lista arriva da uno stream su Drift; il server,
  se e quando risponde, aggiorna il database e la pagina si ridisegna da sola.
- **Non mostra le schede disattivate insieme alle attive.** Restano
  raggiungibili, ma fuori dalla lista principale: la domanda della schermata è
  «cosa alleno oggi», e una scheda archiviata non è mai la risposta.
