import 'package:coachly/core/config/app_config.dart';

/// Endpoint derivati dalla configurazione di build.
///
/// I valori grezzi vivono in [AppConfig]: qui non si legge mai
/// `String.fromEnvironment` (`docs/development/17-config-and-flags.md`).
class ApiEndpoints {
  static const String apiBaseUrl = AppConfig.apiBaseUrl;
  static const String keycloakIssuer = AppConfig.keycloakIssuer;
  static const String keycloakClientId = AppConfig.keycloakClientId;

  static const String keycloakRedirectScheme = 'it.coachly.coachly';
  static const String keycloakRedirectUri =
      '$keycloakRedirectScheme:/oauthredirect/';
  static const String keycloakPostLogoutRedirectUri =
      '$keycloakRedirectScheme:/logout/';

  static const String keycloakAuthorizationEndpoint =
      '$keycloakIssuer/protocol/openid-connect/auth';
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
