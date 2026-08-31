---
livello: Riferimento
stato: active
---

# 01 — Allenamento attivo

Rotta: `/workouts/workout/:id/active` · `WorkoutActivePage` ·
`AdaptiveWorkoutWorkspace`

## A cosa serve

Registrare quello che è appena successo — questo peso, queste ripetizioni,
questa fatica — **senza interrompere l'allenamento**.

## Il vincolo dominante

L'utente è in piedi, ha appena finito una serie, respira ancora forte, ha una
mano sola libera e probabilmente sudata, e il recupero è già cominciato. Ha
**dieci-quindici secondi** prima che compilare diventi un fastidio, e se lo
diventa smette di farlo — e una app di allenamento che non viene compilata non
ha altri motivi di esistere.

Ogni scelta di questa schermata si spiega con questa frase. Quando due opzioni
sembrano equivalenti, vince quella che costa meno attenzione, anche se costa
più codice.

## Struttura

Non è una procedura guidata, è un **piano di lavoro**. La distinzione è la
decisione di design centrale, ed è dichiarata nel codice stesso:

> *«The active-workout presentation is deliberately a workspace: the full
> session stays visible while only the active exercise and set expand.»*

Una procedura guidata mostra un passo per volta e nasconde il resto. Sarebbe
più pulita e sarebbe sbagliata: chi si allena **salta**, torna indietro,
aggiunge una serie non prevista, scambia l'ordine di due esercizi perché il
rack è occupato. Nascondere la sessione lo costringe a navigare per fare cose
che nella realtà della palestra sono normali.

Dall'alto verso il basso:

| Zona | Contenuto | Perché lì |
|---|---|---|
| Testata | titolo, tempo trascorso, uscita | il tempo trascorso è l'unica informazione che serve sempre |
| Navigatore di sessione | tutti gli esercizi, quello corrente evidenziato | orientamento senza navigazione |
| Esercizio attivo | tabella serie + editor della serie corrente | l'unico blocco espanso |
| Barra di recupero | quando il timer è in corso | compare da sola, non si va a cercarla |
| Dock azioni | Struttura · **Aggiungi** · Nota rapida | in fondo, dove arriva il pollice |

L'azione centrale del dock è quella primaria: il pollice di una mano sola
raggiunge il centro-basso meglio di qualsiasi altro punto dello schermo.

## L'inserimento della serie

### I campi cambiano con l'esercizio

`SetInputConfiguration.forExercise` decide i campi, e non è una preferenza:
chiedere il peso in un piegamento è una domanda senza risposta, e un campo
senza risposta è un campo che l'utente deve imparare a saltare.

| Esercizio | Campi |
|---|---|
| Unilaterale | peso · sinistra · destra · RIR |
| A corpo libero | ripetizioni · RIR |
| Standard | peso · ripetizioni · RIR |

### Tre modi di inserire un numero, in ordine di costo

1. **`−` / `+`** — un tap, incremento di 2.5 kg o 1 ripetizione. È il caso
   normale: da un allenamento all'altro il peso cambia di uno scatto.
2. **Tap sul valore** — apre un foglio numerico con tastiera numerica e campo
   già a fuoco. È il caso del salto grosso, e costa un tap più la digitazione.
3. **`−` / `+` dentro il foglio** — il fuoco resta sul campo dopo lo scatto,
   così correggere non richiede di riaprire la tastiera.

I bersagli `−` e `+` sono **larghi 56 px in una riga alta 68**, non 48: la
regola di accessibilità è il minimo per un dito asciutto e fermo, non per un
dito sudato dopo uno stacco. Il valore usa **cifre tabulari**, così passare da
`95` a `100` non fa saltare il resto della riga — un movimento che l'occhio
legge come "è cambiato qualcos'altro".

### Completare la serie

Un bottone a tutta larghezza, alto quanto l'azione primaria del design system.
È il gesto più ripetuto della schermata — decine di volte per allenamento — e
non deve mai richiedere mira.

## Ruolo e tecnica sono due cose diverse

Il codice le tiene separate di proposito:

> *«The purpose of a set is independent from the technique applied to it.»*

- **Ruolo** — a cosa serve la serie: `working`, `warmup`, `topSet`, `backoff`.
- **Tecnica** — come viene eseguita: `dropSet`, `restPause`, `myoReps`,
  `amrap`, `failure`, `cluster`.

Confonderle sembra un risparmio finché non serve un riscaldamento a cedimento
o una back-off in myo-reps, che sono combinazioni normali. Tenerle separate
costa un enum in più e rende rappresentabile tutto quello che le persone
fanno davvero.

Lo stesso vale per i **blocchi**: superset, triset, giant set, circuito,
preparazione, mobilità, ciascuno con il proprio recupero fra esercizi e fra
giri.

## Il recupero

Il timer non è una notifica, è un elemento di primo livello: parte da solo al
completamento della serie e si può mettere in pausa, allungare, accorciare,
saltare, e silenziare la campanella.

Nessuna di queste è un'opzione di configurazione. Sono tutte azioni immediate
sulla barra, perché la decisione «mi serve un altro minuto» si prende mentre
il timer sta già scorrendo, non nelle impostazioni.

## Chiudere l'allenamento

L'unica azione della schermata che **non** si attiva con un tap:
`HoldToCompleteWorkoutButton` richiede una pressione continua di **2 secondi**
(`confirmHold`), con l'anello di progresso che si riempie.

Il motivo è asimmetrico. Un tap accidentale su "completa serie" costa un tocco
per annullarlo. Un tap accidentale su "termina allenamento" chiude la sessione
in mezzo a un allenamento, ed è il tipo di errore che fa disinstallare una app.
Una finestra di conferma risolverebbe lo stesso problema con due tap e una
lettura; la pressione prolungata lo risolve con **un gesto solo, senza
leggere** — e in questo contesto leggere è la parte cara.

Con "riduci animazioni" attivo lo scintillio si ferma ma la pressione resta:
il feedback si adatta, il meccanismo di sicurezza no.

## Stati

| Stato | Cosa vede l'utente |
|---|---|
| `loading` | scheletro; non blocca l'ingresso |
| `active` | il piano di lavoro |
| `saving` | nessuno spinner bloccante: il salvataggio è locale e istantaneo |
| `saved` | passaggio alla schermata di riepilogo |
| `error` | messaggio tradotto, i dati restano sul dispositivo |

**Offline non è uno stato di questa schermata**, ed è il punto. La sessione si
scrive su Drift dentro una transazione insieme alla riga di outbox: quando
l'utente vede "salvato" il dato è già al sicuro sul telefono. La rete arriva
dopo, quando capita, e non ha modo di far fallire un allenamento
(`docs/development/05-sync-and-offline.md`).

Il draft viene persistito mentre l'allenamento è in corso: chiudere la app,
ricevere una chiamata o essere uccisi dal sistema non perde le serie già
inserite.

## Cosa non fa, deliberatamente

- **Non chiede conferma per completare una serie.** L'errore è a costo quasi
  zero e la conferma raddoppierebbe il gesto più frequente della app.
- **Non mostra un indicatore di sincronizzazione durante l'allenamento.** È
  un'informazione che non serve a chi si sta allenando, e uno stato di rete
  visibile è un invito a preoccuparsene.
- **Non nasconde gli esercizi non attivi.** Vedi sopra: è un piano di lavoro,
  non una procedura guidata.
- **Non impone l'ordine.** Si può saltare avanti e tornare indietro; il rack
  occupato è un fatto, non un'eccezione.

## Debito noto

`adaptive_workout_workspace.dart` è un file solo da ~3900 righe con 46 classi,
e `AdaptiveWorkoutWorkspace` riceve **33 parametri**. Supera di molto il limite
delle 800 righe di `docs/development/02-project-structure.md`, ed è la
schermata dove la separazione in componenti serve di più, perché è quella che
cambia più spesso. Vedi `docs/development/26-migration-plan.md`.
