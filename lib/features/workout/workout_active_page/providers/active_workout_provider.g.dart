// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveWorkout)
const activeWorkoutProvider = ActiveWorkoutFamily._();

final class ActiveWorkoutProvider
    extends $NotifierProvider<ActiveWorkout, ActiveWorkoutState> {
  const ActiveWorkoutProvider._({
    required ActiveWorkoutFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeWorkoutProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutHash();

  @override
  String toString() {
    return r'activeWorkoutProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActiveWorkout create() => ActiveWorkout();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveWorkoutState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveWorkoutState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveWorkoutProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeWorkoutHash() => r'0a5bce82f8592addbb485e732157570db134f0ea';

final class ActiveWorkoutFamily extends $Family
    with
        $ClassFamilyOverride<
          ActiveWorkout,
          ActiveWorkoutState,
          ActiveWorkoutState,
          ActiveWorkoutState,
          String
        > {
  const ActiveWorkoutFamily._()
    : super(
        retry: null,
        name: r'activeWorkoutProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveWorkoutProvider call(String workoutId) =>
      ActiveWorkoutProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'activeWorkoutProvider';
}

abstract class _$ActiveWorkout extends $Notifier<ActiveWorkoutState> {
  late final _$args = ref.$arg as String;
  String get workoutId => _$args;

  ActiveWorkoutState build(String workoutId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ActiveWorkoutState, ActiveWorkoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActiveWorkoutState, ActiveWorkoutState>,
              ActiveWorkoutState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
