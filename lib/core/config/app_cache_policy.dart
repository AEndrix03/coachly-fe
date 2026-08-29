import 'package:coachly/core/config/app_config.dart';

/// Alias di compatibilita' verso [AppConfig.cacheMode].
///
/// `ENABLE_LOCAL_CACHE` disattivava il layer locale in modo permanente. E'
/// stato sostituito da `CACHE_MODE` (`docs/development/05-sync-and-offline.md`):
/// il layer locale resta sempre attivo. Questa classe esiste solo finche' i
/// call-site residui non sono migrati e va rimossa con essi.
@Deprecated('Usa AppConfig.cacheMode. Rimosso a migrazione completata.')
abstract final class AppCachePolicy {
  static bool get isEnabled => AppConfig.cacheMode == CacheMode.warm;
}
