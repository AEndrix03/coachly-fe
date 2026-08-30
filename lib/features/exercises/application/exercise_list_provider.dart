import 'package:coachly/features/exercises/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercises/application/exercise_detail_view_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_list_provider.g.dart';

@riverpod
Future<List<ExerciseModel>> exerciseList(Ref ref) async {
  final catalog = await ref.watch(exerciseDetailCatalogProvider.future);
  return [
    for (final exercise in catalog)
      ExerciseModel(
        id: exercise.id,
        nameI18n: {'it': exercise.name, 'en': exercise.name},
        descriptionI18n: {
          'it': exercise.description,
          'en': exercise.description,
        },
        tipsI18n: {
          'it': exercise.execution.steps.join('\n'),
          'en': exercise.execution.steps.join('\n'),
        },
        difficultyLevel: exercise.biomechanics.training.technicalDemand,
        mechanicsType: exercise.movementProfile.jointClass,
        forceType: exercise.movementProfile.pattern,
        isUnilateral: exercise.unilateral,
        isBodyweight: exercise.bodyweight,
      ),
  ];
}
