// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_assembler_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentWorkoutContext)
const currentWorkoutContextProvider = CurrentWorkoutContextProvider._();

final class CurrentWorkoutContextProvider
    extends $FunctionalProvider<WorkoutContext, WorkoutContext, WorkoutContext>
    with $Provider<WorkoutContext> {
  const CurrentWorkoutContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWorkoutContextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWorkoutContextHash();

  @$internal
  @override
  $ProviderElement<WorkoutContext> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkoutContext create(Ref ref) {
    return currentWorkoutContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutContext value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutContext>(value),
    );
  }
}

String _$currentWorkoutContextHash() =>
    r'52ed5d8e4088537b9818d846328f29bb6ebc725e';

@ProviderFor(aiCoachWorkoutId)
const aiCoachWorkoutIdProvider = AiCoachWorkoutIdProvider._();

final class AiCoachWorkoutIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const AiCoachWorkoutIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCoachWorkoutIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCoachWorkoutIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return aiCoachWorkoutId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$aiCoachWorkoutIdHash() => r'cc1576bdfca092b05a660b0431b8ecb1f974f5ad';
