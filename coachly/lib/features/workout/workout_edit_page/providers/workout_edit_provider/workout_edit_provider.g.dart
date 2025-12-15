// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutEditPageNotifier)
const workoutEditPageProvider = WorkoutEditPageNotifierFamily._();

final class WorkoutEditPageNotifierProvider
    extends $NotifierProvider<WorkoutEditPageNotifier, WorkoutEditState> {
  const WorkoutEditPageNotifierProvider._({
    required WorkoutEditPageNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workoutEditPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutEditPageNotifierHash();

  @override
  String toString() {
    return r'workoutEditPageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WorkoutEditPageNotifier create() => WorkoutEditPageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutEditState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutEditPageNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutEditPageNotifierHash() =>
    r'7c38e8c405931d221fc3d0999c99ba68e9e9c1c2';

final class WorkoutEditPageNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          WorkoutEditPageNotifier,
          WorkoutEditState,
          WorkoutEditState,
          WorkoutEditState,
          String
        > {
  const WorkoutEditPageNotifierFamily._()
    : super(
        retry: null,
        name: r'workoutEditPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkoutEditPageNotifierProvider call(String workoutId) =>
      WorkoutEditPageNotifierProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'workoutEditPageProvider';
}

abstract class _$WorkoutEditPageNotifier extends $Notifier<WorkoutEditState> {
  late final _$args = ref.$arg as String;
  String get workoutId => _$args;

  WorkoutEditState build(String workoutId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<WorkoutEditState, WorkoutEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutEditState, WorkoutEditState>,
              WorkoutEditState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
