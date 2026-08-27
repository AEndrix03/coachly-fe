# ADR-002 — ARB + gen_l10n per la localizzazione

Stato: accettato
Data: 2026-08-28

## Contesto

Coesistono due sistemi di traduzione:

1. `app_strings.dart`, mappa `const` di 2080 righe con ~700 chiavi;
2. un helper `_t(context, en:, it:)` scritto inline nei widget, con 85 occorrenze
   nel solo `workout_builder_widgets.dart` e 71 in `create_workout_flow.dart`.

Il secondo è invisibile a qualsiasi strumento: non è possibile sapere quante
stringhe esistano, né estrarle per la traduzione.

Nessuno dei due supporta plurali ICU o interpolazione tipizzata, e non esiste
modo di rilevare una chiave mancante in una lingua.

## Decisione

Si adotta **ARB + `gen_l10n`**, lo standard ufficiale Flutter.

`app_strings.dart` viene convertito e rimosso. I `_t(…)` inline vengono estratti
feature per feature. Un lint (`no_hardcoded_strings`) e due test (parità delle
chiavi, chiavi orfane) rendono la regola verificabile.

Resta **fuori** dallo scope di questo ADR la localizzazione dei *dati* (nomi e
descrizioni degli esercizi), che è un problema di modellazione dati e vive nella
tabella `i18n` del database. Vedi `13-i18n.md`.

## Conseguenze

- Migrazione di ~700 chiavi, automatizzabile, più l'estrazione manuale degli
  inline, che non lo è.
- L'estrazione degli inline coincide con i file più grandi del progetto: si fa
  insieme alla loro scomposizione, non come passaggio separato.
- Si ottengono plurali ICU, interpolazione tipizzata, e la possibilità di dare i
  file a un traduttore.
- La CI può verificare la completezza delle traduzioni.

## Alternative scartate

**Irrigidire `AppStrings`.** Zero migrazione, ma nessun plurale ICU, nessun
tooling di traduzione, e un formato che nessun servizio esterno conosce. Rimanda
il problema senza ridurlo.
