// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider per LocalDatabaseService (Singleton)

@ProviderFor(localDatabase)
const localDatabaseProvider = LocalDatabaseProvider._();

/// Provider per LocalDatabaseService (Singleton)

final class LocalDatabaseProvider
    extends
        $FunctionalProvider<
          LocalDatabaseService,
          LocalDatabaseService,
          LocalDatabaseService
        >
    with $Provider<LocalDatabaseService> {
  /// Provider per LocalDatabaseService (Singleton)
  const LocalDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $ProviderElement<LocalDatabaseService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalDatabaseService create(Ref ref) {
    return localDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDatabaseService>(value),
    );
  }
}

String _$localDatabaseHash() => r'22939fa6758a6183e73711fbea82242a1e09324f';

/// Provider per EnhancedSyncManager (Singleton)

@ProviderFor(syncManager)
const syncManagerProvider = SyncManagerProvider._();

/// Provider per EnhancedSyncManager (Singleton)

final class SyncManagerProvider
    extends
        $FunctionalProvider<
          EnhancedSyncManager,
          EnhancedSyncManager,
          EnhancedSyncManager
        >
    with $Provider<EnhancedSyncManager> {
  /// Provider per EnhancedSyncManager (Singleton)
  const SyncManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncManagerHash();

  @$internal
  @override
  $ProviderElement<EnhancedSyncManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EnhancedSyncManager create(Ref ref) {
    return syncManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnhancedSyncManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnhancedSyncManager>(value),
    );
  }
}

String _$syncManagerHash() => r'61b4309f973d70b4bb2d9b12866d66fe30573b7d';

/// Provider per stato sync enabled/disabled

@ProviderFor(SyncEnabled)
const syncEnabledProvider = SyncEnabledProvider._();

/// Provider per stato sync enabled/disabled
final class SyncEnabledProvider extends $NotifierProvider<SyncEnabled, bool> {
  /// Provider per stato sync enabled/disabled
  const SyncEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncEnabledHash();

  @$internal
  @override
  SyncEnabled create() => SyncEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$syncEnabledHash() => r'c710a62b3c8fce088b4022fac3ffd714ee86fcb8';

/// Provider per stato sync enabled/disabled

abstract class _$SyncEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider per sync stats (stream che aggiorna ogni 10 secondi)

@ProviderFor(syncStats)
const syncStatsProvider = SyncStatsProvider._();

/// Provider per sync stats (stream che aggiorna ogni 10 secondi)

final class SyncStatsProvider
    extends
        $FunctionalProvider<AsyncValue<SyncStats>, SyncStats, Stream<SyncStats>>
    with $FutureModifier<SyncStats>, $StreamProvider<SyncStats> {
  /// Provider per sync stats (stream che aggiorna ogni 10 secondi)
  const SyncStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatsHash();

  @$internal
  @override
  $StreamProviderElement<SyncStats> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<SyncStats> create(Ref ref) {
    return syncStats(ref);
  }
}

String _$syncStatsHash() => r'07eaf39018a06d1a93147c21168797dd2f38aa63';
