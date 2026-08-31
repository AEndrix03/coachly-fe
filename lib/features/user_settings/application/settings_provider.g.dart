// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lingua dell'interfaccia.
///
/// È una **preferenza banale**: sta in `SharedPreferencesAsync`, non in Drift
/// (`docs/development/04-data-layer.md`, "Cosa non sta in Drift"). Perderla
/// significa ripartire dalla lingua di default, che è esattamente il
/// comportamento del primo avvio.

@ProviderFor(Language)
const languageProvider = LanguageProvider._();

/// Lingua dell'interfaccia.
///
/// È una **preferenza banale**: sta in `SharedPreferencesAsync`, non in Drift
/// (`docs/development/04-data-layer.md`, "Cosa non sta in Drift"). Perderla
/// significa ripartire dalla lingua di default, che è esattamente il
/// comportamento del primo avvio.
final class LanguageProvider extends $NotifierProvider<Language, Locale> {
  /// Lingua dell'interfaccia.
  ///
  /// È una **preferenza banale**: sta in `SharedPreferencesAsync`, non in Drift
  /// (`docs/development/04-data-layer.md`, "Cosa non sta in Drift"). Perderla
  /// significa ripartire dalla lingua di default, che è esattamente il
  /// comportamento del primo avvio.
  const LanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageHash();

  @$internal
  @override
  Language create() => Language();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$languageHash() => r'8f667d4953302c053b82e892d02b6ffeeb7c42bf';

/// Lingua dell'interfaccia.
///
/// È una **preferenza banale**: sta in `SharedPreferencesAsync`, non in Drift
/// (`docs/development/04-data-layer.md`, "Cosa non sta in Drift"). Perderla
/// significa ripartire dalla lingua di default, che è esattamente il
/// comportamento del primo avvio.

abstract class _$Language extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
