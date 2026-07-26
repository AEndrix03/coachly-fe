/// Controls use of local read caches.
///
/// Offline-first remains the default in every build. Development can opt into
/// network-first behaviour at build time with:
/// `--dart-define=ENABLE_LOCAL_CACHE=true|false`.
abstract final class AppCachePolicy {
  static const bool isEnabled = bool.fromEnvironment(
    'ENABLE_LOCAL_CACHE',
    defaultValue: true,
  );
}
