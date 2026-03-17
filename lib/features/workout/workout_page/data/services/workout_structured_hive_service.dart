import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/structured_workout_snapshot_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final workoutStructuredHiveServiceProvider =
    Provider<WorkoutStructuredHiveService>((ref) {
      final localDbService = ref.watch(localDatabaseServiceProvider);
      return WorkoutStructuredHiveService(localDbService);
    });

class WorkoutStructuredHiveService {
  final Box<Map> _structuredWorkoutsBox;

  WorkoutStructuredHiveService(LocalDatabaseService localDbService)
    : this.fromBox(localDbService.workoutStructured);

  WorkoutStructuredHiveService.fromBox(this._structuredWorkoutsBox);

  Future<StructuredWorkoutSnapshot?> getSnapshot(String workoutId) async {
    final raw = _structuredWorkoutsBox.get(workoutId);
    if (raw == null) {
      return null;
    }
    return StructuredWorkoutSnapshot.fromJson(_normalizeMap(raw));
  }

  Future<void> saveSnapshot(StructuredWorkoutSnapshot snapshot) async {
    await _structuredWorkoutsBox.put(snapshot.workoutId, snapshot.toJson());
  }

  Future<void> deleteSnapshot(String workoutId) async {
    await _structuredWorkoutsBox.delete(workoutId);
  }
}

Map<String, dynamic> _normalizeMap(Map raw) {
  return raw.map((key, value) => MapEntry(key.toString(), value));
}
