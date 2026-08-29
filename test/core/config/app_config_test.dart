import 'package:coachly/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheMode.resolve', () {
    test('maps the three documented wire names in a debug build', () {
      expect(CacheMode.resolve('warm', isReleaseBuild: false), CacheMode.warm);
      expect(CacheMode.resolve('cold', isReleaseBuild: false), CacheMode.cold);
      expect(
        CacheMode.resolve('no-seed', isReleaseBuild: false),
        CacheMode.noSeed,
      );
    });

    test('is case and whitespace tolerant', () {
      expect(
        CacheMode.resolve('  COLD ', isReleaseBuild: false),
        CacheMode.cold,
      );
    });

    test('falls back to warm on an unknown or empty value', () {
      expect(CacheMode.resolve('', isReleaseBuild: false), CacheMode.warm);
      expect(
        CacheMode.resolve('enabled', isReleaseBuild: false),
        CacheMode.warm,
      );
      expect(CacheMode.resolve('true', isReleaseBuild: false), CacheMode.warm);
    });

    test('debug-only modes are inert in a release build', () {
      expect(CacheMode.resolve('cold', isReleaseBuild: true), CacheMode.warm);
      expect(
        CacheMode.resolve('no-seed', isReleaseBuild: true),
        CacheMode.warm,
      );
      expect(CacheMode.resolve('warm', isReleaseBuild: true), CacheMode.warm);
    });

    test('only warm is allowed in release', () {
      expect(CacheMode.warm.isDebugOnly, isFalse);
      expect(CacheMode.cold.isDebugOnly, isTrue);
      expect(CacheMode.noSeed.isDebugOnly, isTrue);
    });
  });

  group('AppConfig.debugSnapshot', () {
    test('exposes every build-config key the debug screen shows', () {
      expect(
        AppConfig.debugSnapshot.keys,
        containsAll(<String>[
          'environment',
          'apiBaseUrl',
          'keycloakIssuer',
          'keycloakClientId',
          'cacheMode',
          'rawCacheMode',
          'logLevel',
          'isReleaseBuild',
        ]),
      );
    });

    test('reports the resolved cache mode, not the raw define', () {
      expect(
        AppConfig.debugSnapshot['cacheMode'],
        AppConfig.cacheMode.wireName,
      );
    });

    test('mirrors the current configuration values', () {
      expect(AppConfig.debugSnapshot['environment'], AppConfig.environment);
      expect(AppConfig.debugSnapshot['apiBaseUrl'], AppConfig.apiBaseUrl);
      expect(
        AppConfig.debugSnapshot['keycloakIssuer'],
        AppConfig.keycloakIssuer,
      );
      expect(AppConfig.debugSnapshot['logLevel'], AppConfig.logLevel);
    });

    test('defaults to warm when CACHE_MODE is not defined', () {
      expect(AppConfig.cacheMode, CacheMode.warm);
    });

    test('carries no secret material', () {
      final serialized = AppConfig.debugSnapshot.toString().toLowerCase();
      expect(serialized.contains('secret'), isFalse);
      expect(serialized.contains('token'), isFalse);
    });
  });
}
