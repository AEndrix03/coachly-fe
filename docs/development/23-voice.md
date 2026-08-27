---
livello: Riferimento
stato: active
---

# 23 — Sottosistema vocale

1248 righe fra servizi, repository e modelli. È una pipeline di dominio vera, e
finora non aveva una collocazione architetturale: sta sotto
`workout_active_page/voice/` come se fosse un dettaglio di una schermata.

Non lo è. È il caso da manuale di feature che **merita un domain layer**
(`01-principles.md`).

## Cosa fa

Trasforma un enunciato parlato in palestra — *"ottanta per otto, RIR due"* — in
una serie registrata sull'esercizio corretto.

```
audio
  ↓  workout_speech_to_text_service     platform speech-to-text
testo grezzo
  ↓  voice_text_normalization_service   numeri, unità, sinonimi, rumore
testo normalizzato
  ↓  voice_entry_parser_service         → carico, reps, RIR, comandi
intento strutturato
  ↓  voice_resolution_context_builder   esercizio corrente, scheda, storico
contesto
  ↓  exercise_candidate_retriever       candidati dal catalogo + alias utente
candidati
  ↓  exercise_reranker_service          riordino per contesto
candidati ordinati
  ↓  match_confidence_decider           accetta / chiedi conferma / rifiuta
esito
  ↓  voice_resolution_log_repository    log per il tuning
```

Ogni stadio è una funzione pura testabile a parte, e questa è la proprietà da
non perdere nel riordino.

## Collocazione target

```
features/active_workout/
├── domain/voice/
│   ├── models/                  intento, candidato, esito, confidenza
│   ├── normalization.dart       puro
│   ├── entry_parser.dart        puro
│   ├── candidate_retriever.dart puro (riceve il catalogo, non lo interroga)
│   ├── reranker.dart            puro
│   └── confidence_decider.dart  puro, soglie configurabili
├── data/
│   ├── local/voice_alias_dao.dart
│   ├── local/voice_log_dao.dart
│   └── repositories/voice_repository.dart
└── application/
    └── voice_logging_controller.dart
```

La regola che tiene: **gli stadi puri non accedono al database**. Il contesto e i
candidati arrivano come parametri. Il repository li fornisce, il controller
orchestra.

Oggi i servizi sono chiamati "service" ma sono logica di dominio pura: il nome
va corretto, altrimenti il lint D6 li tratta come data source.

## Le tre uscite

| Esito | Comportamento |
|---|---|
| `accepted` | registra e conferma con un feedback breve |
| `needsConfirmation` | mostra il candidato migliore, un tap conferma |
| `rejected` | chiede di ripetere, senza fare nulla |

La soglia fra le tre è **configurabile** e va calibrata sui log reali. Un falso
positivo — registrare 80 kg sull'esercizio sbagliato — è molto più costoso di un
falso negativo, quindi le soglie partono conservative.

## Alias utente

Ogni conferma manuale dopo un `needsConfirmation` produce un alias
(`utente + testo pronunciato → esercizio`), che alza la confidenza per quella
persona. È l'apprendimento più economico disponibile e non richiede nessun
modello.

Gli alias sono **dati utente**: locali, in Drift, sincronizzati via outbox.

## Log di risoluzione

`voice_resolution_log` registra: testo normalizzato, candidati, punteggi, esito,
correzione dell'utente.

Sono il dataset per il tuning delle soglie. Regole:

- restano **locali** e si sincronizzano solo con consenso esplicito, perché
  contengono trascrizioni di parlato (`24-security-and-privacy.md`);
- si potano dopo 90 giorni;
- il testo grezzo pre-normalizzazione **non si conserva**: potrebbe contenere
  conversazioni di sfondo.

L'ultimo punto è importante: un microfono aperto in palestra sente altre persone.

## Offline

Il riconoscimento è **on-device**. Nessun audio lascia mai il dispositivo, e la
funzione va usata dove non c'è connessione — cioè in gran parte delle palestre.

Se il riconoscimento on-device non è disponibile, la funzione si disabilita: non
esiste un fallback che manda l'audio a un servizio remoto.

## Localizzazione

La normalizzazione è **specifica per lingua**: numeri parlati, unità, sinonimi e
nomi degli esercizi cambiano completamente fra italiano e inglese. Non è una
tabella di traduzione: è una implementazione per locale.

Oggi esiste solo l'italiano. Va reso esplicito nel codice, non implicito.

## Test

Il sottosistema è testabile al 100% senza microfono, ed è il motivo per tenere
gli stadi puri:

| Test | Cosa |
|---|---|
| Corpus di enunciati | testo → intento atteso, decine di casi reali |
| Normalizzazione | numeri, unità, rumore, esitazioni |
| Reranking | che il contesto della scheda vinca sull'ordine alfabetico |
| Soglie | che un falso positivo noto resti sotto la soglia di accettazione |

Il corpus va versionato e cresciuto con i casi reali raccolti dai log: è
l'artefatto più prezioso del sottosistema.

## Feature flag

`Feature.voiceLogging`, con default locale disattivato finché le soglie non sono
calibrate su dati reali.
