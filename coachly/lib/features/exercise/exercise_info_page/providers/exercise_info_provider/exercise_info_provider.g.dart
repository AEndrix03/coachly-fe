// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseInfoPageService)
const exerciseInfoPageServiceProvider = ExerciseInfoPageServiceProvider._();

final class ExerciseInfoPageServiceProvider
    extends
        $FunctionalProvider<
          ExerciseInfoPageService,
          ExerciseInfoPageService,
          ExerciseInfoPageService
        >
    with $Provider<ExerciseInfoPageService> {
  const ExerciseInfoPageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseInfoPageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseInfoPageServiceHash();

  @$internal
  @override
  $ProviderElement<ExerciseInfoPageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExerciseInfoPageService create(Ref ref) {
    return exerciseInfoPageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseInfoPageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseInfoPageService>(value),
    );
  }
}

String _$exerciseInfoPageServiceHash() =>
    r'35caf88efa893b948cfbbb38fb567e079d120de6';

@ProviderFor(exerciseInfoPageRepository)
const exerciseInfoPageRepositoryProvider =
    ExerciseInfoPageRepositoryProvider._();

final class ExerciseInfoPageRepositoryProvider
    extends
        $FunctionalProvider<
          IExerciseInfoPageRepository,
          IExerciseInfoPageRepository,
          IExerciseInfoPageRepository
        >
    with $Provider<IExerciseInfoPageRepository> {
  const ExerciseInfoPageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseInfoPageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseInfoPageRepositoryHash();

  @$internal
  @override
  $ProviderElement<IExerciseInfoPageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IExerciseInfoPageRepository create(Ref ref) {
    return exerciseInfoPageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IExerciseInfoPageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IExerciseInfoPageRepository>(value),
    );
  }
}

String _$exerciseInfoPageRepositoryHash() =>
    r'815da93e37a586975e4a51ca56cfd4fe8205fbf2';

@ProviderFor(ExerciseInfoNotifier)
const exerciseInfoProvider = ExerciseInfoNotifierProvider._();

final class ExerciseInfoNotifierProvider
    extends $NotifierProvider<ExerciseInfoNotifier, ExerciseInfoState> {
  const ExerciseInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseInfoNotifierHash();

  @$internal
  @override
  ExerciseInfoNotifier create() => ExerciseInfoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseInfoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseInfoState>(value),
    );
  }
}

String _$exerciseInfoNotifierHash() =>
    r'b1a9cad0ed9b6844854180d159009ff4851e1c63';

abstract class _$ExerciseInfoNotifier extends $Notifier<ExerciseInfoState> {
  ExerciseInfoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExerciseInfoState, ExerciseInfoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExerciseInfoState, ExerciseInfoState>,
              ExerciseInfoState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
