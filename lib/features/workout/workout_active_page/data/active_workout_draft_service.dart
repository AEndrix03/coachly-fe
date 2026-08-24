import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final activeWorkoutDraftServiceProvider = Provider<ActiveWorkoutDraftService>((
  ref,
) {
  return ActiveWorkoutDraftService(
    ref.watch(localDatabaseServiceProvider).activeWorkoutDrafts,
  );
});

class ActiveWorkoutDraftService {
  final Box<Map> _box;
  const ActiveWorkoutDraftService(this._box);

  Future<void> save(String workoutId, ActiveWorkoutState state) async {
    await _box.put(workoutId, {
      'sessionId': state.sessionId,
      'startedAt': state.startedAt?.toIso8601String(),
      'currentBlockId': state.currentTarget?.blockId,
      'currentExerciseId': state.currentTarget?.exerciseId,
      'currentSetId': state.currentTarget?.setId,
      'phase': state.phase.name,
      'lastSetCompletedAt': state.lastSetCompletedAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'exerciseEntryIds': [
        for (final exercise in state.exercises) exercise.exercise.id,
      ],
      'sets': [
        for (final exercise in state.exercises)
          for (final set in exercise.sets)
            {
              'exerciseEntryId': exercise.exercise.id,
              'setId': set.id,
              'position': set.position,
              'setType': set.setType,
              'weight': set.weight,
              'reps': set.reps,
              'rir': set.rir,
              'durationSeconds': set.durationSeconds,
              'distance': set.distance,
              'leftReps': set.leftReps,
              'rightReps': set.rightReps,
              'completed': set.completed,
              'skipped': set.skipped,
            },
      ],
    });
  }

  Map<String, dynamic>? read(String workoutId) {
    final raw = _box.get(workoutId);
    return raw?.map((key, value) => MapEntry(key.toString(), value));
  }

  Future<void> saveRest({
    required String workoutId,
    required DateTime endsAt,
    required int initialSeconds,
  }) async {
    final current = read(workoutId) ?? <String, dynamic>{};
    await _box.put(workoutId, {
      ...current,
      'restEndsAt': endsAt.toIso8601String(),
      'restInitialSeconds': initialSeconds,
    });
  }

  Future<void> clearRest(String workoutId) async {
    final current = read(workoutId);
    if (current == null) return;
    current.remove('restEndsAt');
    current.remove('restInitialSeconds');
    await _box.put(workoutId, current);
  }

  Future<void> delete(String workoutId) => _box.delete(workoutId);
}
