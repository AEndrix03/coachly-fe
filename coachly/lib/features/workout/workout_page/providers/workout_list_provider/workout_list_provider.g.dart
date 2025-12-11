// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutPageService)
const workoutPageServiceProvider = WorkoutPageServiceProvider._();

final class WorkoutPageServiceProvider
    extends
        $FunctionalProvider<
          WorkoutPageService,
          WorkoutPageService,
          WorkoutPageService
        >
    with $Provider<WorkoutPageService> {
  const WorkoutPageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutPageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutPageServiceHash();

  @$internal
  @override
  $ProviderElement<WorkoutPageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutPageService create(Ref ref) {
    return workoutPageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutPageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutPageService>(value),
    );
  }
}

String _$workoutPageServiceHash() =>
    r'1a69b138a63e70eee538b197e499cd2926c9e39e';

@ProviderFor(workoutPageRepository)
const workoutPageRepositoryProvider = WorkoutPageRepositoryProvider._();

final class WorkoutPageRepositoryProvider
    extends
        $FunctionalProvider<
          IWorkoutPageRepository,
          IWorkoutPageRepository,
          IWorkoutPageRepository
        >
    with $Provider<IWorkoutPageRepository> {
  const WorkoutPageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutPageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutPageRepositoryHash();

  @$internal
  @override
  $ProviderElement<IWorkoutPageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWorkoutPageRepository create(Ref ref) {
    return workoutPageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWorkoutPageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWorkoutPageRepository>(value),
    );
  }
}

String _$workoutPageRepositoryHash() =>
    r'2d73e24930c903de433c2eddb0f1a13f74090722';

@ProviderFor(WorkoutListNotifier)
const workoutListProvider = WorkoutListNotifierProvider._();

final class WorkoutListNotifierProvider
    extends $NotifierProvider<WorkoutListNotifier, WorkoutListState> {
  const WorkoutListNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$workoutListNotifierHash();

  @$internal
  @override
  WorkoutListNotifier create() => WorkoutListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutListState>(value),
    );
  }
}

String _$workoutListNotifierHash() =>
    r'e902f5916d2ebf48e43263f49dfd7e56032a5bc2';

abstract class _$WorkoutListNotifier extends $Notifier<WorkoutListState> {
  WorkoutListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WorkoutListState, WorkoutListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutListState, WorkoutListState>,
              WorkoutListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
