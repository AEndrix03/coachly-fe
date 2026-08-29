import 'package:flutter/foundation.dart';

/// Stato della cache locale richiesto alla build corrente.
///
/// Vedi `docs/development/17-config-and-flags.md` e
/// `docs/development/05-sync-and-offline.md`. Si controlla lo **stato** della
/// cache, mai la sua esistenza: in tutte le modalita' il layer locale resta
/// attivo, altrimenti la app finisce in uno stato che in produzione non esiste
/// mai e che genera da solo i sintomi che dovrebbe diagnosticare (richieste
/// concorrenti duplicate, errori sovrapposti).
enum CacheMode {
  /// Comportamento normale. E' l'unica modalita' delle build release.
  warm('warm'),

  /// Svuota il database locale all'avvio, poi normale.
  /// Simula la prima installazione.
  cold('cold'),

  /// Ignora il catalogo pre-installato e forza il download.
  ///
  /// NON ANCORA OPERATIVO: il catalogo pre-installato (asset di seed) non
  /// esiste ancora nel repository. Il valore e' predisposto perche' il
  /// contratto di `CACHE_MODE` sia gia' completo; oggi si comporta come
  /// [warm].
  noSeed('no-seed');

  const CacheMode(this.wireName);

  /// Valore accettato da `--dart-define=CACHE_MODE=`.
  final String wireName;

  /// `cold` e `noSeed` sono modalita' di debug: nelle build release sono
  /// inerti e la risoluzione ricade su [warm].
  bool get isDebugOnly => this != CacheMode.warm;

  /// Risolve un valore di `CACHE_MODE`. Un valore sconosciuto ricade su
  /// [warm]: una build non deve mai fallire per un flag di debug scritto male.
  ///
  /// [isReleaseBuild] e' iniettabile per i test; in produzione arriva da
  /// `kReleaseMode`.
  static CacheMode resolve(String raw, {required bool isReleaseBuild}) {
    final normalized = raw.trim().toLowerCase();
    final parsed = CacheMode.values
        .where((mode) => mode.wireName == normalized)
        .firstOrNull;
    if (parsed == null) return CacheMode.warm;
    if (isReleaseBuild && parsed.isDebugOnly) return CacheMode.warm;
    return parsed;
  }
}

/// Unico punto di verita' della configurazione di build.
///
/// Nessuna feature legge `String.fromEnvironment` direttamente
/// (`docs/development/17-config-and-flags.md`). Le preferenze utente non
/// stanno qui: cambiano a runtime e vivono nelle preferenze.
abstract final class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev.aredegalli.it:8800/api',
  );

  static const String keycloakIssuer = String.fromEnvironment(
    'KEYCLOAK_ISSUER',
    defaultValue: 'https://auth.aredegalli.it/realms/coachly-app',
  );

  // `AUTHENTICATION.md` documenta `coachly-app`, il codice precedente usava
  // `coachly-mobile`. Il disallineamento e' segnalato in
  // `docs/development/17-config-and-flags.md` e non e' risolto qui: cambiare
  // il default senza conferma dal realm Keycloak romperebbe il login.
  static const String keycloakClientId = String.fromEnvironment(
    'KEYCLOAK_CLIENT_ID',
    defaultValue: 'coachly-mobile',
  );

  static const String logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'info',
  );

  static const String rawCacheMode = String.fromEnvironment(
    'CACHE_MODE',
    defaultValue: 'warm',
  );

  static CacheMode get cacheMode =>
      CacheMode.resolve(rawCacheMode, isReleaseBuild: kReleaseMode);

  /// Configurazione attiva, per la debug screen
  /// (`docs/development/17-config-and-flags.md`).
  ///
  /// Non contiene segreti: solo identificatori pubblici del client OAuth.
  static Map<String, Object> get debugSnapshot => {
    'environment': environment,
    'apiBaseUrl': apiBaseUrl,
    'keycloakIssuer': keycloakIssuer,
    'keycloakClientId': keycloakClientId,
    'cacheMode': cacheMode.wireName,
    'rawCacheMode': rawCacheMode,
    'logLevel': logLevel,
    'isReleaseBuild': kReleaseMode,
  };
}
