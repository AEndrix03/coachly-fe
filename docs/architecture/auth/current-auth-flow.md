# Auth attuale

## Obiettivo del documento
Descrive come funzionava il flusso di autenticazione prima del bypass temporaneo introdotto per il refactor del backend. Serve come riferimento per ricostruire o migrare la soluzione.

## Componenti principali
- `lib/routes/app_router.dart`
  Gestiva il bootstrap applicativo con redirect iniziale su `/loading`, `/login` o area protetta in base a `authProvider`.
- `lib/features/auth/providers/auth_provider.dart`
  Era l'orchestratore principale dello stato auth. Leggeva i token, validava JWT, tentava il refresh, gestiva modalità offline e lifecycle app.
- `lib/features/auth/data/services/token_manager.dart`
  Salvava `accessToken` e `refreshToken` in `FlutterSecureStorage`.
- `lib/core/network/interceptors/auth_interceptor_client.dart`
  Aggiungeva automaticamente l'header `Authorization: Bearer <accessToken>` a tutte le chiamate non-auth e, su `401`, provava un refresh con retry della request originale.
- `lib/features/auth/data/services/auth_service_impl.dart`
  Eseguiva `login` e `refreshToken` verso gli endpoint backend e persisteva i token tramite `TokenManager`.
- `lib/features/auth/providers/user_provider.dart`
  Derivava l'utente decodificando il payload JWT dell'access token.

## Flusso all'avvio
1. Il router partiva da `/loading`.
2. `authProvider.build()` controllava se esistevano access e refresh token nello storage sicuro.
3. Se i token mancavano, lo stato diventava non autenticato e il router redirigeva a `/login`.
4. Se l'access token era ancora valido, l'utente veniva considerato autenticato e il router entrava nell'app.
5. Se l'access token era scaduto ma il refresh token era valido e c'era rete, veniva eseguito il refresh.
6. Se non c'era rete, il provider poteva entrare in modalità offline mantenendo accesso limitato all'app.

## Login
1. `LoginPage` chiamava `authProvider.notifier.login(email, password)`.
2. `Auth.login()` costruiva `LoginRequestDto` e delegava ad `AuthService.login()`.
3. `AuthServiceImpl.login()` chiamava l'endpoint backend di login.
4. In caso di successo, access e refresh token venivano salvati in secure storage.
5. Lo stato passava ad autenticato e il router redirigeva su `/workouts`.

## Refresh e gestione token
- Il provider calcolava la scadenza dell'access token con `JwtValidator`.
- Veniva schedulato un refresh proattivo 5 minuti prima della scadenza.
- Alla ripresa dell'app (`AppLifecycleState.resumed`) veniva rieseguito un controllo auth e, se necessario, un refresh anticipato.
- L'interceptor HTTP faceva un secondo livello di protezione:
  se una request tornava `401`, tentava il refresh e ritentava la chiamata originale.

## Modalità offline
- Se non c'era connettività e i token non risultavano più validi lato tempo, il provider poteva mantenere `isAuthenticated = true` ma con `isOfflineMode = true`.
- `OfflineModeBanner` mostrava il banner di stato e, in alcuni casi, richiedeva re-login.
- `SyncManager` era previsto come hook per sincronizzazione operazioni pendenti quando la connettività tornava disponibile.

## Stato auth esposto alla UI
`AuthState` esponeva:
- `isAuthenticated`
- `isTokenValid`
- `isOfflineMode`
- `isLoading`
- `tokens`
- `errorMessage`

Property derivate:
- `canAccessApp`
- `needsReLogin`
- `isOnlineAuthenticated`

## Limiti dell'implementazione attuale
- Forte accoppiamento tra router, storage locale, JWT parsing e client HTTP.
- Refresh gestito sia nel provider sia nell'interceptor, con responsabilità duplicate.
- `userProvider` dipende dal contenuto del JWT, quindi il modello utente non è separato dal token.
- Il flusso è pensato per login proprietario con coppia access/refresh token, non per un identity provider esterno come Keycloak.

## Stato temporaneo introdotto ora
- Il router non usa più `authProvider` come guard.
- `ApiClient` usa un client HTTP plain senza interceptor auth.
- `authProvider` è in bypass e non legge più token né fa refresh.
- La route `/login` è stata trasformata in pagina informativa con accesso diretto all'app.
