// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseList)
const exerciseListProvider = ExerciseListFamily._();

final class ExerciseListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ExerciseDetailModel>>,
          List<ExerciseDetailModel>,
          FutureOr<List<ExerciseDetailModel>>
        >
    with
        $FutureModifier<List<ExerciseDetailModel>>,
        $FutureProvider<List<ExerciseDetailModel>> {
  const ExerciseListProvider._({
    required ExerciseListFamily super.from,
    required ExerciseFilterModel? super.argument,
  }) : super(
         retry: null,
         name: r'exerciseListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseListHash();

  @override
  String toString() {
    return r'exerciseListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ExerciseDetailModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExerciseDetailModel>> create(Ref ref) {
    final argument = this.argument as ExerciseFilterModel?;
    return exerciseList(ref, filter: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseListHash() => r'1e0275eec7fe5d3ba61b076f106a7441468d89b7';

final class ExerciseListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ExerciseDetailModel>>,
          ExerciseFilterModel?
        > {
  const ExerciseListFamily._()
    : super(
        retry: null,
        name: r'exerciseListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseListProvider call({ExerciseFilterModel? filter}) =>
      ExerciseListProvider._(argument: filter, from: this);

  @override
  String toString() => r'exerciseListProvider';
}
