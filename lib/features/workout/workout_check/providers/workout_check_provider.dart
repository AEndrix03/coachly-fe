import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_check/data/workout_check_repository.dart';
import 'package:coachly/features/workout/workout_check/data/workout_check_service.dart';
import 'package:coachly/features/workout/workout_check/domain/workout_check_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutCheckRepositoryProvider = Provider<WorkoutCheckRepository>((ref) {
  return LocalWorkoutCheckRepository(
    WorkoutCheckService(ref.watch(exerciseInfoPageRepositoryProvider)),
  );
});

final workoutCheckProvider = FutureProvider.autoDispose
    .family<WorkoutCheckReport, WorkoutDraft>(
      (ref, draft) => ref.watch(workoutCheckRepositoryProvider).evaluate(draft),
    );
