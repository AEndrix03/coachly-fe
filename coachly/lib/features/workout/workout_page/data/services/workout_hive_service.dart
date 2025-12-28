import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutHiveServiceProvider = Provider<WorkoutHiveService>((ref) {
  return WorkoutHiveService(LocalDatabaseService());
});

class WorkoutHiveService {
  final LocalDatabaseService _localDbService;

  WorkoutHiveService(this._localDbService);

  Future<List<WorkoutModel>> getWorkouts() async {
    final box = _localDbService.workouts;
    return box.values.toList();
  }

  Future<WorkoutModel?> getWorkout(String workoutId) async {
    final box = _localDbService.workouts;
    return box.get(workoutId);
  }

  Future<void> saveWorkouts(List<WorkoutModel> workouts) async {
    final box = _localDbService.workouts;
    await box.clear();
    for (final workout in workouts) {
      await box.put(workout.id, workout);
    }
  }

  Future<void> patchWorkouts(List<WorkoutModel> workouts) async {
    final box = _localDbService.workouts;

    final localDirtyIds = <String>{};
    for (final key in box.keys) {
      final workout = box.get(key);
      if (workout != null && workout.dirty) {
        localDirtyIds.add(workout.id);
      }
    }

    final incomingIds = workouts.map((w) => w.id).toSet();
    final keysToDelete = <dynamic>[];

    for (final key in box.keys) {
      final workout = box.get(key);
      if (workout != null) {
        if (!incomingIds.contains(workout.id) && !workout.dirty) {
          keysToDelete.add(key);
        }
      }
    }
    await box.deleteAll(keysToDelete);

    for (final workout in workouts) {
      if (!localDirtyIds.contains(workout.id) || workout.dirty) {
        await box.put(workout.id, workout);
      }
    }
  }

  Future<void> patchWorkout(WorkoutModel workout) async {
    final box = _localDbService.workouts;
    final dirtyWorkout = workout.copyWith(dirty: true);
    await box.put(dirtyWorkout.id, dirtyWorkout);
  }

  // Modifica locale: enable
  Future<void> enableWorkout(String workoutId) async {
    final box = _localDbService.workouts;
    final workout = box.get(workoutId);
    if (workout != null) {
      await patchWorkout(workout.copyWith(active: true));
    }
  }

  // Modifica locale: disable
  Future<void> disableWorkout(String workoutId) async {
    final box = _localDbService.workouts;
    final workout = box.get(workoutId);
    if (workout != null) {
      await patchWorkout(workout.copyWith(active: false));
    }
  }

  // Modifica locale: delete (soft delete)
  Future<void> deleteWorkout(String workoutId) async {
    final box = _localDbService.workouts;
    final workout = box.get(workoutId);
    if (workout != null) {
      await patchWorkout(workout.copyWith(delete: true));
    }
  }

  // Modifica locale: update generico
  Future<void> updateWorkout(WorkoutModel updatedWorkout) async {
    await patchWorkout(updatedWorkout);
  }

  // Marca workout come sincronizzato (rimuove dirty flag)
  Future<void> markWorkoutSynced(String workoutId) async {
    final box = _localDbService.workouts;
    final workout = box.get(workoutId);
    if (workout != null) {
      final cleanWorkout = workout.copyWith(dirty: false);
      await box.put(workoutId, cleanWorkout);
    }
  }

  Future<List<WorkoutModel>> getDirtyWorkouts() async {
    return (await getWorkouts()).where((workout) => workout.dirty).toList();
  }

  Future<int> countWorkouts() async {
    final box = _localDbService.workouts;
    return box.length;
  }
}
