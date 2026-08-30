// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseList)
const exerciseListProvider = ExerciseListProvider._();

final class ExerciseListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ExerciseModel>>,
          List<ExerciseModel>,
          FutureOr<List<ExerciseModel>>
        >
    with
        $FutureModifier<List<ExerciseModel>>,
        $FutureProvider<List<ExerciseModel>> {
  const ExerciseListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseListHash();

  @$internal
  @override
  $FutureProviderElement<List<ExerciseModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExerciseModel>> create(Ref ref) {
    return exerciseList(ref);
  }
}

String _$exerciseListHash() => r'69f4266cabe569e2c9240d877de6d41b02b8f224';
