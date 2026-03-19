import 'dart:collection';

import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';

class WorkoutSessionWriteCommandMapper {
  const WorkoutSessionWriteCommandMapper._();

  static WorkoutWriteCommand applySessionToWorkoutCommand({
    required WorkoutWriteCommand workoutCommand,
    required WorkoutSessionWriteCommand sessionCommand,
  }) {
    final sessionEntriesByExerciseId =
        <String, Queue<WorkoutSessionEntryWritePayload>>{};

    for (final sessionEntry in sessionCommand.entries) {
      final queue =
          sessionEntriesByExerciseId[sessionEntry.exerciseId] ??
          Queue<WorkoutSessionEntryWritePayload>();
      queue.add(sessionEntry);
      sessionEntriesByExerciseId[sessionEntry.exerciseId] = queue;
    }

    final updatedBlocks = workoutCommand.blocks.map((block) {
      final updatedEntries = block.entries.map((entry) {
        final queue = sessionEntriesByExerciseId[entry.exerciseId];
        final sessionEntry = queue == null || queue.isEmpty
            ? null
            : queue.removeFirst();

        if (sessionEntry == null) {
          return entry;
        }

        return WorkoutEntryWritePayload(
          id: entry.id,
          exerciseId: entry.exerciseId,
          position: entry.position,
          sets: _mergeSetRows(
            plannedSets: entry.sets,
            sessionSets: sessionEntry.sets,
          ),
        );
      }).toList();

      return WorkoutBlockWritePayload(
        id: block.id,
        position: block.position,
        label: block.label,
        restSeconds: block.restSeconds,
        notes: block.notes,
        entries: updatedEntries,
      );
    }).toList();

    return WorkoutWriteCommand(
      id: workoutCommand.id,
      name: workoutCommand.name,
      description: workoutCommand.description,
      translations: workoutCommand.translations,
      status: workoutCommand.status,
      blocks: updatedBlocks,
    );
  }

  static List<WorkoutSetWritePayload> _mergeSetRows({
    required List<WorkoutSetWritePayload> plannedSets,
    required List<WorkoutSessionSetWritePayload> sessionSets,
  }) {
    if (plannedSets.isEmpty || sessionSets.isEmpty) {
      return plannedSets;
    }

    final updateCount = plannedSets.length < sessionSets.length
        ? plannedSets.length
        : sessionSets.length;

    return List.generate(plannedSets.length, (index) {
      final plannedSet = plannedSets[index];
      if (index >= updateCount) {
        return plannedSet;
      }

      final sessionSet = sessionSets[index];
      final mergedLoad = sessionSet.load ?? plannedSet.load;
      final mergedLoadUnit = mergedLoad == null
          ? plannedSet.loadUnit
          : (sessionSet.loadUnit ?? plannedSet.loadUnit ?? 'kg');

      return WorkoutSetWritePayload(
        id: plannedSet.id,
        position: plannedSet.position,
        setType: sessionSet.setType ?? plannedSet.setType,
        reps: sessionSet.reps ?? plannedSet.reps,
        load: mergedLoad,
        loadUnit: mergedLoadUnit,
        restSeconds: plannedSet.restSeconds,
        notes: plannedSet.notes,
      );
    });
  }
}
