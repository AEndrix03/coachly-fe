---
livello: Standard
stato: active
---

# 24 — Sicurezza e privacy

I dati di allenamento sono **health-adjacent**: carichi, frequenza, note,
progressione, e in prospettiva peso corporeo e misure. Non sono dati sanitari in
senso stretto, ma il trattamento va progettato con quella prudenza.

Il local-first cambia il baricentro: gran parte dei dati vive **sul dispositivo**,
quindi la protezione principale è locale, non lato server.

## Segreti

| Dato | Dove |
|---|---|
| Access token, refresh token | `flutter_secure_storage` |
| Client id Keycloak | `AppConfig`, non è un segreto |
| Chiavi di terze parti | build-time, mai nel repository |

Nessun segreto in `pubspec.yaml`, nel codice o in un file versionato. Nessun
segreto in un `dart-define` committato in uno script.

## Token

Il comportamento attuale è corretto e va conservato nella migrazione a Dio:

- refresh preventivo prima della scadenza;
- refresh su 401 con un solo replay della richiesta;
- refresh **coalescente**: N richieste concorrenti producono un solo refresh;
- fallimento del refresh → pulizia dei token e ritorno al login.

Da aggiungere: nessun token nei log, mai (`18-observability.md`).

## Dati a riposo

**Decisione: SQLCipher dalla prima versione.**

Il costo è una riga di configurazione ora e una migrazione dolorosa dopo. Con
ADR-005 — nessun utente in produzione — questa è esattamente la finestra in cui
la scelta è gratuita.

La chiave sta nel secure storage della piattaforma, generata al primo avvio.
I media sul filesystem non si cifrano: sono contenuti pubblici del catalogo.

## Identità e ciclo di vita del dato locale

Il database è per utente, il file è per dispositivo. I casi da gestire
esplicitamente:

| Caso | Comportamento |
|---|---|
| Logout | wipe completo del DB locale e dei token |
| **Logout con outbox non vuota** | **avviso bloccante**: "N allenamenti non ancora sincronizzati". Si offre di attendere la sync, o di uscire perdendoli, con conferma esplicita |
| Login con utente diverso | wipe prima di aprire il nuovo database |
| Reinstallazione | database nuovo, i dati non sincronizzati sono persi |
| Ripristino da backup del telefono | il DB va escluso dal backup automatico |

Il secondo caso è quello che oggi si comporta male: `logout()` chiama
`clearAll()` senza controllare la coda, quindi può cancellare allenamenti
registrati e mai inviati. È una perdita di dati silenziosa.

L'esclusione dal backup di sistema (`android:allowBackup="false"`, exclusion list
iOS) evita che un database cifrato venga ripristinato su un dispositivo dove la
chiave non esiste.

## GDPR

Il local-first ha una conseguenza che si dimentica facilmente: **i diritti
dell'utente devono coprire anche ciò che sta sul telefono**.

| Diritto | Implementazione |
|---|---|
| Accesso / portabilità | export in JSON di tutto il DB locale, **inclusa la coda non sincronizzata** |
| Cancellazione | wipe locale **e** richiesta al backend, con conferma |
| Rettifica | l'utente modifica i propri dati nella app |
| Opposizione | analytics di prodotto disattivabili senza perdere funzionalità |

L'export deve funzionare **offline**: sono dati che stanno già lì.

## Consenso

Tre livelli distinti, non uno:

| Trattamento | Base | Disattivabile |
|---|---|---|
| Dati di allenamento (sessioni, schede) | contratto: è il servizio | no, ma cancellabile |
| Analytics di prodotto | consenso | **sì** |
| Log di risoluzione vocale | consenso esplicito e separato | sì, default **off** |
| Crash reporting | legittimo interesse, minimizzato | sì |

I log vocali richiedono un consenso a parte perché contengono trascrizioni di
parlato registrato in un luogo pubblico, dove possono comparire terzi.

Rifiutare i consensi opzionali non riduce in nessun modo le funzionalità.

## Minimizzazione

- l'audio non lascia mai il dispositivo (`23-voice.md`);
- il testo grezzo pre-normalizzazione non si conserva;
- gli analytics non contengono testo libero né dati personali
  (`22-analytics-events.md`);
- i log tecnici non contengono contenuto degli allenamenti.

## Rete

- solo HTTPS, nessuna eccezione in cleartext nel manifest;
- **certificate pinning: no per ora.** Il beneficio è marginale rispetto al
  rischio operativo di bloccare tutte le installazioni a un rinnovo di
  certificato. Si rivaluta se e quando ci saranno dati di pagamento;
- nessun dato sensibile in query string: solo header e body.

## Superficie della app

- niente `WebView` con contenuto remoto arbitrario;
- deep link validati: un link non risolvibile porta a una schermata di fallback,
  non a uno stato incoerente;
- `FLAG_SECURE` non necessario: nessuna schermata mostra dati che giustifichino
  il blocco degli screenshot, e gli utenti condividono volentieri i propri
  allenamenti.

## Da fare, in ordine

1. Guardia sul logout con outbox non vuota — **è una perdita di dati attiva**
2. SQLCipher, ora che è gratuito
3. Esclusione dal backup di sistema
4. Redazione dei log (rimozione dei `debugPrint` sui body)
5. Export e cancellazione
6. Schermata dei consensi
