import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_list_provider.g.dart';

@riverpod
class WorkoutList extends _$WorkoutList {
  IWorkoutPageRepository get _repository =>
      ref.read(workoutPageRepositoryProvider);

  @override
  Future<List<WorkoutModel>> build() async {
    final response = await _repository.getWorkouts();
    if (response.success) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to fetch workouts');
    }
  }

  Future<void> enableWorkout(String workoutId) async {
    await _repository.enableWorkout(workoutId);
    ref.invalidateSelf();
  }

  Future<void> disableWorkout(String workoutId) async {
    await _repository.disableWorkout(workoutId);
    ref.invalidateSelf();
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _repository.deleteWorkout(workoutId);
    ref.invalidateSelf();
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    await _repository.updateWorkout(workout);
    ref.invalidateSelf();
  }
}

final recentWorkoutsProvider = FutureProvider.autoDispose<List<WorkoutModel>>((
  ref,
) async {
  final repository = ref.watch(workoutPageRepositoryProvider);
  final response = await repository.getRecentWorkouts();
  if (response.success) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to fetch recent workouts');
  }
});
