// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CoachDiscoveryNotifier)
const coachDiscoveryProvider = CoachDiscoveryNotifierProvider._();

final class CoachDiscoveryNotifierProvider
    extends $NotifierProvider<CoachDiscoveryNotifier, CoachDiscoveryState> {
  const CoachDiscoveryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachDiscoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachDiscoveryNotifierHash();

  @$internal
  @override
  CoachDiscoveryNotifier create() => CoachDiscoveryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoachDiscoveryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoachDiscoveryState>(value),
    );
  }
}

String _$coachDiscoveryNotifierHash() =>
    r'f28df25a75a227fd58473044da89849858dbae91';

abstract class _$CoachDiscoveryNotifier extends $Notifier<CoachDiscoveryState> {
  CoachDiscoveryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CoachDiscoveryState, CoachDiscoveryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoachDiscoveryState, CoachDiscoveryState>,
              CoachDiscoveryState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
