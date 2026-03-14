class ApiEndpoints {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev.aredegalli.it:8800/api',
  );

  static const String keycloakIssuer = String.fromEnvironment(
    'KEYCLOAK_ISSUER',
    defaultValue: 'https://auth.aredegalli.it/realms/coachly-app',
  );

  // Assunzione iniziale: il client id coincide con il realm/app name.
  // Se nel realm Keycloak il client ha un nome diverso, sovrascriverlo con
  // --dart-define=KEYCLOAK_CLIENT_ID=<client-id-reale>.
  static const String keycloakClientId = String.fromEnvironment(
    'KEYCLOAK_CLIENT_ID',
    defaultValue: 'coachly-app',
  );

  static const String keycloakRedirectScheme = 'it.coachly.coachly';
  static const String keycloakRedirectUri =
      '$keycloakRedirectScheme:/oauthredirect/';
  static const String keycloakPostLogoutRedirectUri =
      '$keycloakRedirectScheme:/logout/';

  static const String keycloakTokenEndpoint =
      '$keycloakIssuer/protocol/openid-connect/token';
  static const String keycloakLogoutEndpoint =
      '$keycloakIssuer/protocol/openid-connect/logout';
  static const String keycloakDiscoveryUrl =
      '$keycloakIssuer/.well-known/openid-configuration';
  static const List<String> openIdScopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
  ];
}
