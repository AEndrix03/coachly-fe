import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final workoutHiveServiceProvider = Provider<WorkoutHiveService>((ref) {
  final localDbService = ref.watch(localDatabaseServiceProvider);
  return WorkoutHiveService(localDbService);
});

class WorkoutHiveService {
  final Box<WorkoutModel> _workoutsBox;

  WorkoutHiveService(LocalDatabaseService localDbService)
    : this.fromBox(localDbService.workouts);

  WorkoutHiveService.fromBox(this._workoutsBox);

  Future<List<WorkoutModel>> getWorkouts() async {
    return _workoutsBox.values.toList();
  }

  Future<WorkoutModel?> getWorkout(String workoutId) async {
    return _workoutsBox.get(workoutId);
  }

  Future<void> saveWorkouts(List<WorkoutModel> workouts) async {
    await _workoutsBox.clear();
    for (final workout in workouts) {
      await _workoutsBox.put(workout.id, workout);
    }
  }

  Future<void> patchWorkouts(List<WorkoutModel> workouts) async {
    final localDirtyIds = <String>{};
    for (final key in _workoutsBox.keys) {
      final workout = _workoutsBox.get(key);
      if (workout != null && workout.dirty) {
        localDirtyIds.add(workout.id);
      }
    }

    final incomingIds = workouts.map((w) => w.id).toSet();
    final keysToDelete = <dynamic>[];

    for (final key in _workoutsBox.keys) {
      final workout = _workoutsBox.get(key);
      if (workout != null) {
        if (!incomingIds.contains(workout.id) && !workout.dirty) {
          keysToDelete.add(key);
        }
      }
    }
    await _workoutsBox.deleteAll(keysToDelete);

    for (final workout in workouts) {
      if (!localDirtyIds.contains(workout.id) || workout.dirty) {
        await _workoutsBox.put(workout.id, workout);
      }
    }
  }

  Future<void> patchWorkout(WorkoutModel workout) async {
    final dirtyWorkout = workout.copyWith(dirty: true);
    await _workoutsBox.put(dirtyWorkout.id, dirtyWorkout);
  }

  // Modifica locale: enable
  Future<void> enableWorkout(String workoutId) async {
    final workout = _workoutsBox.get(workoutId);
    if (workout != null) {
      await patchWorkout(workout.copyWith(active: true));
    }
  }

  // Modifica locale: disable
  Future<void> disableWorkout(String workoutId) async {
    final workout = _workoutsBox.get(workoutId);
    if (workout != null) {
      await patchWorkout(workout.copyWith(active: false));
    }
  }

  // Modifica locale: delete (soft delete)
  Future<void> deleteWorkout(String workoutId) async {
    final workout = _workoutsBox.get(workoutId);
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
    final workout = _workoutsBox.get(workoutId);
    if (workout != null) {
      final cleanWorkout = workout.copyWith(dirty: false);
      await _workoutsBox.put(workoutId, cleanWorkout);
    }
  }

  Future<List<WorkoutModel>> getDirtyWorkouts() async {
    return (await getWorkouts()).where((workout) => workout.dirty).toList();
  }

  Future<int> countWorkouts() async {
    return _workoutsBox.length;
  }
}
