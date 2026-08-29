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
    r'34b74514ddd63bea43f652d7f46f8f1bc308807a';

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
