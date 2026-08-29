// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_builder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateWorkoutController)
const createWorkoutControllerProvider = CreateWorkoutControllerProvider._();

final class CreateWorkoutControllerProvider
    extends $NotifierProvider<CreateWorkoutController, WorkoutBuilderState> {
  const CreateWorkoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createWorkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createWorkoutControllerHash();

  @$internal
  @override
  CreateWorkoutController create() => CreateWorkoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutBuilderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutBuilderState>(value),
    );
  }
}

String _$createWorkoutControllerHash() =>
    r'2ed7e6dd13bd40ad6812217317177dae04d952b6';

abstract class _$CreateWorkoutController
    extends $Notifier<WorkoutBuilderState> {
  WorkoutBuilderState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WorkoutBuilderState, WorkoutBuilderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutBuilderState, WorkoutBuilderState>,
              WorkoutBuilderState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EditWorkoutController)
const editWorkoutControllerProvider = EditWorkoutControllerFamily._();

final class EditWorkoutControllerProvider
    extends $NotifierProvider<EditWorkoutController, WorkoutBuilderState> {
  const EditWorkoutControllerProvider._({
    required EditWorkoutControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'editWorkoutControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editWorkoutControllerHash();

  @override
  String toString() {
    return r'editWorkoutControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditWorkoutController create() => EditWorkoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutBuilderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutBuilderState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditWorkoutControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editWorkoutControllerHash() =>
    r'fc571ab8f3b82ba560eed9761125e0ac49b37e3b';

final class EditWorkoutControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EditWorkoutController,
          WorkoutBuilderState,
          WorkoutBuilderState,
          WorkoutBuilderState,
          String
        > {
  const EditWorkoutControllerFamily._()
    : super(
        retry: null,
        name: r'editWorkoutControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditWorkoutControllerProvider call(String workoutId) =>
      EditWorkoutControllerProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'editWorkoutControllerProvider';
}

abstract class _$EditWorkoutController extends $Notifier<WorkoutBuilderState> {
  late final _$args = ref.$arg as String;
  String get workoutId => _$args;

  WorkoutBuilderState build(String workoutId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<WorkoutBuilderState, WorkoutBuilderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutBuilderState, WorkoutBuilderState>,
              WorkoutBuilderState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
