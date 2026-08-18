// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_edit_draft_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutEditDraft)
const workoutEditDraftProvider = WorkoutEditDraftFamily._();

final class WorkoutEditDraftProvider
    extends $NotifierProvider<WorkoutEditDraft, WorkoutEditDraftState> {
  const WorkoutEditDraftProvider._({
    required WorkoutEditDraftFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workoutEditDraftProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutEditDraftHash();

  @override
  String toString() {
    return r'workoutEditDraftProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WorkoutEditDraft create() => WorkoutEditDraft();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutEditDraftState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutEditDraftState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutEditDraftProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutEditDraftHash() => r'ee90e067a4d22f2616e842dc677c1a9386d68080';

final class WorkoutEditDraftFamily extends $Family
    with
        $ClassFamilyOverride<
          WorkoutEditDraft,
          WorkoutEditDraftState,
          WorkoutEditDraftState,
          WorkoutEditDraftState,
          String
        > {
  const WorkoutEditDraftFamily._()
    : super(
        retry: null,
        name: r'workoutEditDraftProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkoutEditDraftProvider call(String workoutId) =>
      WorkoutEditDraftProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'workoutEditDraftProvider';
}

abstract class _$WorkoutEditDraft extends $Notifier<WorkoutEditDraftState> {
  late final _$args = ref.$arg as String;
  String get workoutId => _$args;

  WorkoutEditDraftState build(String workoutId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<WorkoutEditDraftState, WorkoutEditDraftState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutEditDraftState, WorkoutEditDraftState>,
              WorkoutEditDraftState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(lastExercisePrescription)
const lastExercisePrescriptionProvider = LastExercisePrescriptionFamily._();

final class LastExercisePrescriptionProvider
    extends
        $FunctionalProvider<
          WorkoutProgrammingEntryModel?,
          WorkoutProgrammingEntryModel?,
          WorkoutProgrammingEntryModel?
        >
    with $Provider<WorkoutProgrammingEntryModel?> {
  const LastExercisePrescriptionProvider._({
    required LastExercisePrescriptionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lastExercisePrescriptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lastExercisePrescriptionHash();

  @override
  String toString() {
    return r'lastExercisePrescriptionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<WorkoutProgrammingEntryModel?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutProgrammingEntryModel? create(Ref ref) {
    final argument = this.argument as String;
    return lastExercisePrescription(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutProgrammingEntryModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutProgrammingEntryModel?>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LastExercisePrescriptionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lastExercisePrescriptionHash() =>
    r'1dda35b105bd404543151280b53cc201e3ec520e';

final class LastExercisePrescriptionFamily extends $Family
    with $FunctionalFamilyOverride<WorkoutProgrammingEntryModel?, String> {
  const LastExercisePrescriptionFamily._()
    : super(
        retry: null,
        name: r'lastExercisePrescriptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LastExercisePrescriptionProvider call(String exerciseId) =>
      LastExercisePrescriptionProvider._(argument: exerciseId, from: this);

  @override
  String toString() => r'lastExercisePrescriptionProvider';
}
