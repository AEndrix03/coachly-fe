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
    final workoutMaps = await _localDbService.getAllItems(
      LocalDatabaseService.workoutsBox,
    );
    return workoutMaps.map((map) => WorkoutModel.fromJson(map)).toList();
  }

  Future<void> saveWorkouts(List<WorkoutModel> workouts) async {
    final box = _localDbService.workouts;
    await box.clear();
    for (final workout in workouts) {
      await box.put(workout.id, workout.toJson());
    }
  }

  Future<void> addWorkouts(List<WorkoutModel> workouts) async {
    final box = _localDbService.workouts;
    for (final workout in workouts) {
      if (!box.containsKey(workout.id)) {
        await box.put(workout.id, workout.toJson());
      }
    }
  }
}
