---
livello: Riferimento
stato: active
---

# 05 — Ingresso e profilo

Rotte: `/loading` (avvio) · `/login` · `/profile` · `/debug`

## Avvio

`/loading` è la `initialLocation` del router. Decide dove mandare l'utente
mentre la sessione viene ricostruita dal `TokenManager`.

Il vincolo è che questa schermata **non deve diventare un'attesa di rete**.
Coachly funziona offline: se l'avvio dipendesse da una chiamata riuscita, un
utente in palestra nel seminterrato non entrerebbe nella app che contiene i
suoi dati, già sul suo telefono. La sessione si valida in locale; il rinnovo
del token, se serve, avviene dopo.

## Login

`/login` è la destinazione del redirect quando la sessione manca. Autenticazione
Keycloak con PKCE sul client pubblico `coachly-mobile`.

## Profilo

Un indice, non una schermata di lavoro: preferenze, sezione app, sezione
allenamento, esercizi personali, versione e build, uscita.

### Il logout è l'unico punto in cui la sync diventa visibile

Uscire con dell'outbox non ancora inviato significa **restare senza quei dati**
su un altro dispositivo. È l'unico momento in cui una operazione dell'utente
può causare una perdita, quindi è l'unico in cui la coda smette di essere un
dettaglio interno: la conferma di uscita cambia testo e dice **quante**
operazioni sono ancora in attesa.

Ovunque altrove nella app lo stato della coda è deliberatamente invisibile.
Qui no, e la ragione è esattamente quella per cui altrove lo è: si mostra
un'informazione tecnica solo quando l'utente ha una decisione da prendere in
base a quella.

## Debug

`/debug` non è raggiungibile da nessun punto dell'interfaccia: si digita a
mano, ed è spenta in release (`docs/development/18-observability.md`). È
elencata come eccezione dichiarata in `test/tooling/route_reachability_test.dart`,
così resta una scelta e non un residuo.

## Cosa non fa, deliberatamente

- **Non ha una schermata di impostazioni separata.** Le preferenze reali sono
  poche; una schermata dedicata le farebbe sembrare più importanti di quanto
  siano.
- **Non mostra statistiche nel profilo.** Il profilo è chi sei, non come stai
  andando.
