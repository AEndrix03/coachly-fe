// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutStatsNotifier)
const workoutStatsProvider = WorkoutStatsNotifierProvider._();

final class WorkoutStatsNotifierProvider
    extends $NotifierProvider<WorkoutStatsNotifier, WorkoutStatsState> {
  const WorkoutStatsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutStatsNotifierHash();

  @$internal
  @override
  WorkoutStatsNotifier create() => WorkoutStatsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutStatsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutStatsState>(value),
    );
  }
}

String _$workoutStatsNotifierHash() =>
    r'0fa0757489ece0a4a6af716e70ce3b4d9beff51a';

abstract class _$WorkoutStatsNotifier extends $Notifier<WorkoutStatsState> {
  WorkoutStatsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WorkoutStatsState, WorkoutStatsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutStatsState, WorkoutStatsState>,
              WorkoutStatsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
