# ADR-004 — Drift/SQLite al posto di Hive

Stato: accettato
Data: 2026-08-28

## Contesto

La persistenza attuale è Hive: 10 box, 5 servizi dedicati, un `TypeAdapter`
custom per `WorkoutModel`.

Tre problemi concreti emersi dall'analisi:

1. **I dati sono relazionali.** Workout → block → entry → set, esercizi ↔
   muscoli ↔ attrezzi, storico sessioni. Con Hive queste relazioni si
   ricostruiscono a mano: `getFilteredExerciseSummaries` è una scansione lineare
   in Dart con nove predicati scritti a mano, che in SQL è una `WHERE` con
   indici.

2. **Un bug funzionale strutturale.** `saveExerciseSummaries` persiste tre campi
   mentre il filtro ne interroga nove: con la cache attiva qualsiasi filtro
   diverso dal testo restituisce zero risultati, mentre disattivandola funziona
   perché va in rete. Uno schema relazionale rende quell'incoerenza non
   compilabile.

3. **Il catalogo pre-installato è impossibile con Hive.** Il piano di prodotto
   prevede di spedire il catalogo esercizi nel bundle per azzerare le chiamate
   di anagrafica. Con SQLite si genera un `.sqlite` a build time e lo si copia:
   una copia di file. Con Hive bisognerebbe spedire un JSON e parsarlo al primo
   avvio sul telefono dell'utente, perché i box sono un formato proprietario
   legato agli adapter e non generabile in CI.

Il terzo punto è il decisivo: rende Hive incompatibile con la direzione di
prodotto, non solo subottimale.

## Decisione

**Drift / SQLite** come unica persistenza dei dati applicativi. Hive viene
rimosso interamente.

Ripartizione delle responsabilità:

| Dato | Dove |
|---|---|
| Catalogo, dati utente, outbox, metadati media | Drift |
| Preferenze banali | `SharedPreferencesAsync` |
| Token e segreti | `flutter_secure_storage` |
| Byte di media | filesystem |

Niente Drift **e** Hive insieme: ogni storage aggiuntivo è un altro ciclo di vita,
altre migrazioni, altro debugging.

## Conseguenze

- Query tipizzate, transazioni, indici, migrazioni versionate.
- **Stream reattivi**: una scrittura locale aggiorna la UI perché il database
  notifica, il che elimina le 12 `ref.invalidate` sparse dopo le mutazioni.
- **Testabilità**: `NativeDatabase.memory()` rende i repository testabili senza
  filesystem né mock. Era impossibile con Hive.
- Il catalogo pre-seeded diventa realizzabile.
- Disciplina di migrazione obbligatoria dal primo giorno: `schemaVersion`,
  snapshot esportati, test di migrazione.
- Costo: riscrittura di tutto il layer di persistenza. Reso accettabile da
  ADR-005.

## Alternative scartate

**Restare su Hive.** Hive CE è mantenuto ed è una buona soluzione key-value, ma
non è un database relazionale e non risolve nessuno dei tre problemi.

**Drift per i nuovi dati, Hive per gli esistenti.** Due storage in parallelo, due
cicli di vita, due strategie di backup e cancellazione. Il costo di
coordinamento supera quello della migrazione, soprattutto senza utenti da
proteggere.
