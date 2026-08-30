import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/features/workouts/domain/workout_draft.dart';
import 'package:coachly/features/workouts/data/repositories/workout_check_repository.dart';
import 'package:coachly/features/workouts/data/services/workout_check_service.dart';
import 'package:coachly/features/workouts/domain/workout_check_models.dart';
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
