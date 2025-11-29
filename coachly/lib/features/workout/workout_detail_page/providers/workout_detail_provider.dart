import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/workout_detail_model/workout_detail_model.dart';
import '../data/repositories/workout_detail_page_repository.dart';

final workoutDetailPageRepositoryProvider =
    Provider<IWorkoutDetailPageRepository>((ref) {
      return WorkoutDetailPageRepositoryImpl();
    });

final workoutDetailProvider = FutureProvider.family<WorkoutDetailModel, String>(
  (ref, id) async {
    final repo = ref.read(workoutDetailPageRepositoryProvider);
    return await repo.getWorkoutDetail(id);
  },
);

final workoutExercisesProvider =
    FutureProvider.family<List<ExerciseModel>, String>((ref, id) async {
      final repo = ref.read(workoutDetailPageRepositoryProvider);
      return await repo.getWorkoutExercises(id);
    });
