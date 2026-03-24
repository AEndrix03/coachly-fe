# Voice Pipeline (Workout Active Page)

Questa cartella contiene la pipeline completa per l'inserimento vocale massivo durante la sessione attiva (`workout_active_page`).

Obiettivo pratico:
- input vocale naturale (es. `lat machine presa larga 3 da 10 45 chili`)
- estrazione dati allenamento (`exerciseId`, `sets`, `reps`, `weightKg`)
- applicazione immediata sui set dell'esercizio in sessione
- funzionamento offline-first

## Entry Point UI

L'entrypoint utente e' il bottone microfono nella bottom bar:
- file: `widgets/active_bottom_bar.dart`

Flusso UI:
1. tap sul microfono
2. apertura modal centrale di acquisizione vocale (`_VoiceCaptureDialog`)
3. ascolto live con trascrizione in tempo reale
4. utente preme `Stop` manualmente
5. la pipeline risolve esercizio + valori
6. auto-apply oppure scelta top-3
7. salvataggio feedback alias/log

## Architettura ad alto livello

Pipeline runtime:
1. STT locale
2. text normalization
3. parser numerico
4. candidate retrieval (fuzzy/token/trigram/edit)
5. reranking contestuale
6. confidence decision
7. apply su stato workout
8. feedback loop (alias + log)

Servizi principali:
- `services/workout_speech_to_text_service.dart`
- `services/voice_text_normalization_service.dart`
- `services/voice_entry_parser_service.dart`
- `services/exercise_candidate_retriever_service.dart`
- `services/exercise_reranker_service.dart`
- `services/match_confidence_decider_service.dart`
- `services/voice_resolution_service.dart`
- `services/voice_resolution_context_builder.dart`

Repository principali:
- `repositories/voice_exercise_catalog_repository.dart`
- `repositories/user_voice_alias_repository.dart`
- `repositories/voice_resolution_log_repository.dart`

Modelli pipeline:
- `models/voice_resolution_models.dart`

## Step 1: STT locale

File: `services/workout_speech_to_text_service.dart`

Responsabilita':
- inizializzazione `speech_to_text`
- gestione locale (`it_IT` / `en_US` con fallback)
- callback live:
  - `onPartialResult(String)`
  - `onSoundLevelChange(double)`
- stop esplicito su azione utente
- ritorno transcript finale al click `Stop`

Nota UX:
- la chiusura e' manuale (no auto-stop per timeout breve)
- la modal mostra anche un VU meter animato in tempo reale

## Step 2: Normalizzazione testo

File: `services/voice_text_normalization_service.dart`

Regole principali:
- lowercase
- pulizia caratteri non utili
- normalizzazione decimali (`45,5` -> `45.5`)
- mapping unita' (`chili`, `kilos`, ...) -> `kg`
- mapping semantico (`serie` -> `sets`, `rip` -> `reps`)
- mapping numeri parlati base (IT/EN) in cifre

Esempio:
- input: `Lat machine presa larga, tre da dieci, 45 chili`
- output: `lat machine presa larga 3 da 10 45 kg`

## Step 3: Parsing numerico

File: `services/voice_entry_parser_service.dart`

Estrazioni:
- `sets`
- `reps`
- `weightKg`
- `exercisePhrase` (testo residuo)

Pattern supportati (ordine di priorita'):
- `4x8`
- `3 sets of 10`
- `3 da 10`
- `45 kg`
- `10 reps`
- `3 sets`

Output modello:
- `ParsedVoiceEntry`

## Step 4: Catalog retrieval

File: `repositories/voice_exercise_catalog_repository.dart`

Fonte catalogo:
- esercizi locali da `ExerciseHiveService`
- merge con esercizi presenti nel workout attivo (contesto runtime)

Per ogni entry vengono esposti:
- `exerciseId`
- `canonicalName`
- `aliases` (nome base + i18n + varianti)
- metadati opzionali (`equipment`, `muscleGroups`)

## Step 5: Candidate retrieval (base score)

File: `services/exercise_candidate_retriever_service.dart`

Scoring base (best alias per esercizio):
- `0.50 * exactOrPrefixScore`
- `0.25 * tokenOverlapScore`
- `0.15 * trigramScore`
- `0.10 * editSimilarityScore`

Dettagli:
- filtro minimo: `baseScore >= 0.15`
- output: top 10 candidati ordinati per `baseScore`

## Step 6: Context reranking

File: `services/exercise_reranker_service.dart`

Boost principali:
- +0.25 se esercizio e' nella scheda attiva
- +0.10 max per prossimita' all'ordine corrente
- +0.08 se gia' lavorato nella sessione
- +0.30 alias utente forte (>=2 conferme), altrimenti +0.15

Penalita' principali:
- -0.08 se fuori scheda
- -0.10 se overlap token debole e match lessicale debole

Output:
- candidati ordinati per `finalScore` (clamp 0..1)

## Step 7: Confidence decision

File: `services/match_confidence_decider_service.dart`

Soglie correnti:
- `autoMatchThreshold = 0.82`
- `topSuggestionsThreshold = 0.68`
- `minDeltaForAutoMatch = 0.06`

Decisioni:
- `autoMatch`
- `topSuggestions`
- `manualSelection`

## Step 8: Applicazione su workout state

File: `providers/active_workout_provider.dart`

Metodo: `applyVoiceEntry(...)`

Comportamento:
- trova esercizio in sessione per `exerciseId`
- aggiorna numero set alla cardinalita' richiesta
- applica `reps` e `weightKg` in modo consistente su tutti i set target
- preserva metadata set dove possibile (`setType`, `completed`)

Return:
- `VoiceApplyOutcome` per toast/UI

## Step 9: Feedback loop (offline)

Alias utente:
- file: `repositories/user_voice_alias_repository.dart`
- box: `voice_aliases_v1`
- chiave: `userId::normalizedSpokenForm`
- incremento `confirmations` quando la stessa mappatura viene confermata

Log risoluzioni:
- file: `repositories/voice_resolution_log_repository.dart`
- box: `voice_resolution_logs_v1`
- salva input, parse, candidati top, decisione, confidence, selezione finale

Apertura box Hive:
- file: `core/sync/local_database_service.dart`
- aggiunte:
  - `voiceAliasesBox`
  - `voiceResolutionLogsBox`

## Orchestrazione end-to-end

File: `services/voice_resolution_service.dart`

`resolve(rawText, context)` esegue:
1. normalize
2. parse
3. load/merge catalog
4. retrieve
5. alias lookup
6. rerank
7. confidence decision
8. log creazione

`registerFeedback(...)` esegue:
1. save alias utente (se disponibile userId)
2. update log con `selectedExerciseId`

## Context builder

File: `services/voice_resolution_context_builder.dart`

Costruisce `VoiceResolutionContext` da `ActiveWorkoutState`:
- esercizi attivi con alias runtime
- ordine corrente dell'esercizio in progresso
- userId (se autenticato)

## Modal di acquisizione vocale

File: `widgets/active_bottom_bar.dart`

Componenti principali:
- `_VoiceCaptureDialog`
- `_VoiceVuMeter`

Caratteristiche:
- modal bloccante centrata
- trascrizione live
- VU meter animato live
- bottone `Stop` obbligatorio
- hint di errore/riattivazione in caso di stop inatteso

## Test esistenti

- `test/features/workout/workout_active_page/voice_text_normalization_service_test.dart`
- `test/features/workout/workout_active_page/voice_entry_parser_service_test.dart`
- `test/features/workout/workout_active_page/match_confidence_decider_service_test.dart`

Coprono:
- normalizzazione base
- parsing set/reps/peso
- decisione confidence auto-match

## Tuning consigliato

Punti di tuning piu' importanti:
- pesi in `exercise_candidate_retriever_service.dart`
- boost/penalty in `exercise_reranker_service.dart`
- soglie in `match_confidence_decider_service.dart`

Metrica prioritaria:
- `false auto-match rate`

## Limitazioni attuali

- parser numerico volutamente leggero (regex), non NLP completo
- nessun embedding locale
- matching ottimizzato per cataloghi piccoli/medi e dominio workout
- nessun supporto multi-comando in una singola frase lunga (es. due esercizi in un colpo)

## Estensioni future

- dataset interno di valutazione (top1/top3/false auto-match)
- alias seed statici per gergo palestra locale
- parser multi-entry (piu' esercizi in una frase)
- retrieval ibrido con semantic fallback (solo se serve)
