// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutList)
const workoutListProvider = WorkoutListProvider._();

final class WorkoutListProvider
    extends $AsyncNotifierProvider<WorkoutList, List<WorkoutModel>> {
  const WorkoutListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutListHash();

  @$internal
  @override
  WorkoutList create() => WorkoutList();
}

String _$workoutListHash() => r'd8e0c67f4a57714856dbce79eb06e34c84fa365e';

abstract class _$WorkoutList extends $AsyncNotifier<List<WorkoutModel>> {
  FutureOr<List<WorkoutModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<WorkoutModel>>, List<WorkoutModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WorkoutModel>>, List<WorkoutModel>>,
              AsyncValue<List<WorkoutModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
