import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:coachly/features/workouts/domain/workout_check_models.dart';
import 'package:coachly/features/workouts/domain/workout_check_rules.dart';

class WorkoutCheckService {
  final IExerciseInfoPageRepository exerciseCache;
  final List<WorkoutCheckRule> rules;

  WorkoutCheckService(this.exerciseCache)
    : rules = [
        MuscleCoverageRule(),
        MovementPatternRule(),
        WorkoutStructureRule(),
        EstimatedDurationRule(),
        GoalAlignmentRule(),
        ExerciseOverlapRule(),
      ];

  Future<WorkoutCheckReport> evaluate(WorkoutDraft draft) async {
    final details = <String, ExerciseDetailModel>{};
    for (final exercise in draft.exercises) {
      final detail = await exerciseCache.getCachedDetail(exercise.exerciseId);
      if (detail != null) details[exercise.exerciseId] = detail;
    }
    final context = WorkoutCheckContext(draft: draft, exerciseDetails: details);
    final findings = rules
        .where((rule) => rule.supports(context))
        .expand((rule) => rule.evaluate(context))
        .toList();
    final exposure = <String, int>{};
    for (final exercise in draft.exercises) {
      final detail = context.exerciseDetails[exercise.exerciseId];
      for (final relation in detail?.muscles ?? const []) {
        final name = relation.muscle?.nameI18n['en'] ?? relation.muscle?.code;
        if (name != null) {
          exposure.update(
            name,
            (v) => v + exercise.sets,
            ifAbsent: () => exercise.sets,
          );
        }
      }
    }
    return WorkoutCheckReport(
      mode: draft.trainingGoal ?? 'bodybuilding',
      findings: findings,
      dataQuality: details.length == draft.exercises.length
          ? WorkoutCheckDataQuality.complete
          : details.isEmpty
          ? WorkoutCheckDataQuality.insufficient
          : WorkoutCheckDataQuality.partial,
      generatedAt: DateTime.now(),
      draftRevision:
          '${draft.exerciseCount}-${draft.workingSets}-${draft.sections.length}',
      muscleSetExposure: exposure,
    );
  }
}
