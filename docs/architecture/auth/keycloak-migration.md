# Migrazione a Keycloak

## Obiettivo
Sostituire il login proprietario e la gestione manuale dei token con un'integrazione Keycloak/OIDC, riducendo l'accoppiamento attuale tra UI, router e networking.

## Direzione architetturale consigliata
Separare il dominio auth in quattro responsabilità:

1. `IdentityProviderClient`
   Incapsula login OIDC, logout, refresh token, discovery document e gestione sessione Keycloak.

2. `SessionStore`
   Persiste solo ciò che serve localmente: token set, expiry, subject, eventuale profilo minimo.

3. `AuthController`
   Espone allo UI layer uno stato semplice:
   `unknown`, `anonymous`, `authenticated`, `refreshing`, `error`.

4. `AuthenticatedHttpClient`
   Aggiunge bearer token alle chiamate applicative, ma senza decidere redirect o navigazione.

## Flusso target
1. Avvio app.
2. `AuthController` carica eventuale sessione persistita.
3. Se esiste una sessione valida, entra in `authenticated`.
4. Se il token è vicino alla scadenza, prova refresh tramite Keycloak.
5. Se non c'è sessione valida, entra in `anonymous`.
6. Il router usa solo lo stato alto livello del controller per decidere eventuali pagine pubbliche/protette.

## Integrazione Keycloak

### 1. Scegliere il tipo di flusso
Per mobile Flutter la strada standard è OIDC Authorization Code Flow con PKCE.

Da evitare:
- password grant diretto dal client mobile
- parsing manuale di JWT come fonte primaria di stato UI

### 2. Incapsulare Keycloak dietro un adapter
Creare un layer dedicato, per esempio:
- `lib/features/auth/data/services/keycloak_auth_service.dart`
- `lib/features/auth/data/models/auth_session.dart`
- `lib/features/auth/providers/auth_controller.dart`

Il resto dell'app non dovrebbe conoscere endpoint Keycloak, realm, client id o dettagli OIDC.

### 3. Rivedere il router
Il router deve dipendere da uno stato compatto e stabile, per esempio:
- `unknown`: splash/loading
- `anonymous`: eventuale schermata login
- `authenticated`: area app

Da evitare:
- redirect basati su dettagli di refresh token
- logica offline dentro il router

### 4. Rivedere il client HTTP
Oggi `AuthHttpClient` fa sia injection header sia refresh automatico. Con Keycloak è meglio:
- leggere l'access token corrente da `AuthController` o `SessionStore`
- aggiungere l'header bearer alle sole API che lo richiedono
- delegare il refresh a un unico punto applicativo
- su failure irreversibile, invalidare la sessione e lasciare al router/UI la reazione

### 5. Profilo utente
`userProvider` oggi decodifica il JWT. Con Keycloak è preferibile:
- usare claims standard solo per dati minimi (`sub`, `preferred_username`, `email`)
- caricare il profilo applicativo da backend se servono ruoli o dati business

## Piano di migrazione consigliato

### Fase 1. Stabilizzazione del bypass
- Lasciare app senza auth obbligatoria durante il refactor backend.
- Evitare che API client, router e widget dipendano da token locali.

### Fase 2. Introdurre i contratti nuovi
- Definire un modello `AuthSession`.
- Definire un controller auth indipendente da Keycloak e backend legacy.
- Definire interfaccia per session storage.

### Fase 3. Implementare adapter Keycloak
- Configurazione realm/client id/redirect URI.
- Login browser-based con PKCE.
- Exchange code -> token set.
- Refresh token.
- Logout federato o locale.

### Fase 4. Reintegrare le guard applicative
- Ripristinare splash iniziale.
- Proteggere le route che richiedono sessione.
- Mostrare schermata login solo quando `anonymous`.

### Fase 5. Ricollegare l'HTTP auth
- Reintrodurre bearer token sulle API che lo richiedono.
- Gestire refresh centralizzato senza duplicazioni.
- Rimuovere completamente la vecchia pipeline login/refresh proprietaria.

## Refactor concreti consigliati nel repository
- Sostituire l'attuale `authProvider` con un controller più piccolo e senza logica networking interna.
- Ridurre `AuthState` a uno stato di sessione e non di trasporto.
- Eliminare la dipendenza di `userProvider` dal JWT raw.
- Tenere `TokenManager` dietro un'astrazione, così in futuro può essere sostituito senza toccare UI/router.
- Limitare `ApiClient` a responsabilità di trasporto; auth injection in un layer dedicato.

## Decisioni aperte da chiarire prima dell'implementazione
- Login interattivo solo mobile o anche web?
- Il backend applicativo accetterà i token Keycloak direttamente o servirà token exchange?
- I ruoli applicativi arriveranno da claims Keycloak, da backend o da entrambi?
- Serve supporto offline reale anche con sessione Keycloak scaduta?

## Esito atteso
Una volta completata la migrazione, l'app dovrebbe conoscere solo il concetto di sessione utente. Tutto il resto, inclusi token, refresh, realm ed endpoint Keycloak, deve rimanere confinato nell'infrastruttura auth.
