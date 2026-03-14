# Coachly FE Authentication

Questo frontend ora usa Keycloak con Authorization Code Flow + PKCE per autenticarsi e per chiamare le API protette su `https://dev.aredegalli.it:8800/api`.

## Cosa fa il flusso attuale

- La login page apre il browser di sistema e delega il login a Keycloak.
- I token vengono salvati con `flutter_secure_storage`.
- Ogni chiamata API passa da un client HTTP autenticato che aggiunge `Authorization: Bearer <access_token>`.
- Se l'access token sta per scadere, il frontend prova un refresh preventivo.
- Se un endpoint risponde `401`, il frontend tenta un refresh e ripete la richiesta una volta.
- Se il refresh fallisce, la sessione locale viene invalidata e il router riporta a `/login`.
- Il redirect di ritorno usa la custom URI `it.coachly.coachly:/oauthredirect/`.

## Endpoint usati

- API backend: `https://dev.aredegalli.it:8800/api`
- Keycloak issuer: `https://auth.aredegalli.it/realms/coachly-app`
- Keycloak token endpoint: `https://auth.aredegalli.it/realms/coachly-app/protocol/openid-connect/token`
- Redirect URI app: `it.coachly.coachly:/oauthredirect/`
- Post logout redirect URI: `it.coachly.coachly:/logout/`

## Configurazione

Le costanti sono in [api_endpoints.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/core/network/api_endpoints.dart).

Sono overrideabili con `--dart-define`:

```bash
flutter run ^
  --dart-define=API_BASE_URL=https://dev.aredegalli.it:8800/api ^
  --dart-define=KEYCLOAK_ISSUER=https://auth.aredegalli.it/realms/coachly-app ^
  --dart-define=KEYCLOAK_CLIENT_ID=coachly-app
```

Se avvii da Android Studio solo con il tasto Run, puoi evitare il terminale. In quel caso:

1. Apri `Run > Edit Configurations...`
2. Seleziona la configurazione Flutter
3. Aggiungi in `Additional run args` solo se il client id reale non e `coachly-app`

## Assunzione importante

Nel codice ho impostato come default `KEYCLOAK_CLIENT_ID=coachly-app` perché dal materiale fornito il nome certo disponibile è quello del realm. Se il client Keycloak reale ha un id diverso, il login non funzionerà finché non imposti il valore corretto via `--dart-define`.

## Configurazione Keycloak richiesta

Nel client Keycloak devi avere:

- `Access Type` / client type: `public`
- `Standard Flow`: abilitato
- `Direct Access Grants`: disabilitato
- `Valid Redirect URIs`: almeno `it.coachly.coachly:/oauthredirect/`
- `Valid Post Logout Redirect URIs`: almeno `it.coachly.coachly:/logout/`

Questa è la configurazione coerente con le best practice per app mobile native.

## File principali toccati

- [auth_service_impl.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/features/auth/data/services/auth_service_impl.dart)
- [auth_interceptor_client.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/core/network/interceptors/auth_interceptor_client.dart)
- [api_client.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/core/network/api_client.dart)
- [auth_provider.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/features/auth/providers/auth_provider.dart)
- [app_router.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/routes/app_router.dart)
- [login_page.dart](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/lib/features/auth/pages/login_page/login_page.dart)
- [AndroidManifest.xml](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/android/app/src/main/AndroidManifest.xml)
- [build.gradle.kts](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/android/app/build.gradle.kts)
- [Info.plist](/C:/Users/redeg/Documents/Progetti/Coachly/coachly-fe/ios/Runner/Info.plist)

## Verifica manuale

Esegui tu questi comandi dal repository:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run --dart-define=KEYCLOAK_CLIENT_ID=<client-id-reale>
```

Test minimo atteso:

1. Avvio app su `/login`.
2. Tap su login, apertura browser di sistema.
3. Login riuscito in Keycloak e ritorno automatico nell app.
4. Navigazione automatica a `/workouts`.
5. `GET /workouts/user` senza `401`.
6. Logout e ritorno a `/login`.
