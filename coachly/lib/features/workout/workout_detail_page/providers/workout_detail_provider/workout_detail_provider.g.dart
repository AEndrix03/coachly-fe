// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutDetailPageService)
const workoutDetailPageServiceProvider = WorkoutDetailPageServiceProvider._();

final class WorkoutDetailPageServiceProvider
    extends
        $FunctionalProvider<
          WorkoutDetailPageService,
          WorkoutDetailPageService,
          WorkoutDetailPageService
        >
    with $Provider<WorkoutDetailPageService> {
  const WorkoutDetailPageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutDetailPageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutDetailPageServiceHash();

  @$internal
  @override
  $ProviderElement<WorkoutDetailPageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutDetailPageService create(Ref ref) {
    return workoutDetailPageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutDetailPageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutDetailPageService>(value),
    );
  }
}

String _$workoutDetailPageServiceHash() =>
    r'c39912465d69a141ad8b1df5f94650dde0c09c2b';

@ProviderFor(workoutDetailPageRepository)
const workoutDetailPageRepositoryProvider =
    WorkoutDetailPageRepositoryProvider._();

final class WorkoutDetailPageRepositoryProvider
    extends
        $FunctionalProvider<
          IWorkoutDetailPageRepository,
          IWorkoutDetailPageRepository,
          IWorkoutDetailPageRepository
        >
    with $Provider<IWorkoutDetailPageRepository> {
  const WorkoutDetailPageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutDetailPageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutDetailPageRepositoryHash();

  @$internal
  @override
  $ProviderElement<IWorkoutDetailPageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWorkoutDetailPageRepository create(Ref ref) {
    return workoutDetailPageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWorkoutDetailPageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWorkoutDetailPageRepository>(value),
    );
  }
}

String _$workoutDetailPageRepositoryHash() =>
    r'cb326769c2bed0cf41fa863963c23cb5b92db096';

@ProviderFor(WorkoutDetailPageNotifier)
const workoutDetailPageProvider = WorkoutDetailPageNotifierProvider._();

final class WorkoutDetailPageNotifierProvider
    extends
        $NotifierProvider<WorkoutDetailPageNotifier, WorkoutDetailPageState> {
  const WorkoutDetailPageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutDetailPageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutDetailPageNotifierHash();

  @$internal
  @override
  WorkoutDetailPageNotifier create() => WorkoutDetailPageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutDetailPageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutDetailPageState>(value),
    );
  }
}

String _$workoutDetailPageNotifierHash() =>
    r'a7fbcd2449bcefc17e8cdcb1528446544575dd59';

abstract class _$WorkoutDetailPageNotifier
    extends $Notifier<WorkoutDetailPageState> {
  WorkoutDetailPageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<WorkoutDetailPageState, WorkoutDetailPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutDetailPageState, WorkoutDetailPageState>,
              WorkoutDetailPageState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
