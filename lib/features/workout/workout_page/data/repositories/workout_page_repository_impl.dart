import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_session_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/structured_workout_snapshot_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_sync_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_structured_hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutPageRepositoryProvider = Provider<IWorkoutPageRepository>((ref) {
  return WorkoutPageRepositoryImpl(
    ref.watch(workoutPageServiceProvider),
    ref.watch(workoutHiveServiceProvider),
    ref.watch(workoutSessionHiveServiceProvider),
    ref.watch(workoutStructuredHiveServiceProvider),
    ref.watch(workoutSessionSyncServiceProvider),
  );
});

class WorkoutPageRepositoryImpl implements IWorkoutPageRepository {
  final WorkoutPageService _apiService;
  final WorkoutHiveService _hiveService;
  final WorkoutSessionHiveService _sessionHiveService;
  final WorkoutStructuredHiveService _structuredHiveService;
  final WorkoutSessionSyncService _sessionSyncService;

  Future<ApiResponse<List<WorkoutModel>>>? _ongoingRefresh;

  WorkoutPageRepositoryImpl(
    this._apiService,
    this._hiveService,
    this._sessionHiveService,
    this._structuredHiveService,
    this._sessionSyncService,
  );

  @override
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts() async {
    final localWorkouts = await _hiveService.getWorkouts();
    if (localWorkouts.isNotEmpty) {
      return ApiResponse.success(data: localWorkouts);
    }
    return _refreshFromRemoteDeduplicated();
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> refreshFromRemote() async {
    final response = await _refreshFromRemoteDeduplicated();
    unawaited(
      _sessionSyncService.syncPendingSessions(trigger: 'refresh_remote'),
    );
    return response;
  }

  Future<ApiResponse<List<WorkoutModel>>> _refreshFromRemoteDeduplicated() {
    final ongoingRefresh = _ongoingRefresh;
    if (ongoingRefresh != null) {
      return ongoingRefresh;
    }

    final refreshFuture = _performRefreshFromRemote();
    _ongoingRefresh = refreshFuture;
    refreshFuture.whenComplete(() {
      if (identical(_ongoingRefresh, refreshFuture)) {
        _ongoingRefresh = null;
      }
    });
    return refreshFuture;
  }

  Future<ApiResponse<List<WorkoutModel>>> _performRefreshFromRemote() async {
    List<WorkoutModel>? remoteWorkouts;
    try {
      final remoteResponse = await _apiService.fetchWorkouts();
      if (remoteResponse.success && remoteResponse.data != null) {
        remoteWorkouts = remoteResponse.data!;
        await _hiveService.patchWorkouts(remoteWorkouts);
      } else {
        return ApiResponse.error(
          message:
              remoteResponse.message ??
              'Failed to refresh workouts from remote',
          statusCode: remoteResponse.statusCode,
          errors: remoteResponse.errors,
        );
      }

      final localWorkouts = await _hiveService.getWorkouts();
      return ApiResponse.success(data: localWorkouts);
    } catch (error) {
      final localWorkouts = await _hiveService.getWorkouts();
      if (localWorkouts.isNotEmpty) {
        return ApiResponse.success(
          data: localWorkouts,
          message: 'API failed, showing local data.',
        );
      }

      if (remoteWorkouts != null && remoteWorkouts.isNotEmpty) {
        return ApiResponse.success(
          data: remoteWorkouts,
          message: 'Local cache failed, showing remote data.',
        );
      }

      return ApiResponse.error(
        message: 'Failed to fetch workouts: ${error.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts() async {
    final response = await getWorkouts();
    if (response.success) {
      final allWorkouts = response.data ?? [];
      allWorkouts.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return ApiResponse.success(data: allWorkouts.take(3).toList());
    }
    return response;
  }

  @override
  Future<ApiResponse<WorkoutModel?>> getWorkout(String workoutId) async {
    try {
      var workout = await _hiveService.getWorkout(workoutId);
      if (workout == null) {
        await refreshFromRemote();
        workout = await _hiveService.getWorkout(workoutId);
      }

      if (workout != null) {
        return ApiResponse.success(data: workout);
      }

      return ApiResponse.error(message: 'Workout not found in local cache');
    } catch (error) {
      return ApiResponse.error(message: error.toString());
    }
  }

  @override
  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats() async {
    return _apiService.fetchWorkoutStats();
  }

  @override
  Future<ApiResponse<void>> enableWorkout(String workoutId) async {
    await _hiveService.enableWorkout(workoutId);
    return ApiResponse.success(message: 'Enabled workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> disableWorkout(String workoutId) async {
    await _hiveService.disableWorkout(workoutId);
    return ApiResponse.success(message: 'Disabled workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> deleteWorkout(String workoutId) async {
    await _hiveService.deleteWorkout(workoutId);
    return ApiResponse.success(message: 'Deleted workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> updateWorkout(WorkoutModel updatedWorkout) async {
    await _hiveService.patchWorkout(updatedWorkout);
    return ApiResponse.success(message: 'Updated workout ${updatedWorkout.id}');
  }

  @override
  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    WorkoutWriteCommand command,
  ) async {
    final response = await _apiService.patchWorkout(workoutId, command);
    if (response.success) {
      await refreshFromRemote();
    }
    return response;
  }

  @override
  Future<ApiResponse<void>> saveSession(
    String workoutId,
    WorkoutSessionWriteCommand sessionCommand,
  ) async {
    final workoutResponse = await getWorkout(workoutId);
    final workout = workoutResponse.data;
    if (!workoutResponse.success || workout == null) {
      return ApiResponse.error(
        message:
            workoutResponse.message ??
            'Workout not found for local-first session save.',
        statusCode: workoutResponse.statusCode,
        errors: workoutResponse.errors,
      );
    }

    final now = DateTime.now().toUtc();
    final localSessionId = _generateUuidV4();
    final jobId = _generateUuidV4();

    try {
      final baseCommand = await _resolveStructuredSnapshotCommand(
        workout: workout,
        workoutId: workoutId,
      );

      final mergedWorkoutCommand =
          WorkoutSessionWriteCommandMapper.applySessionToWorkoutCommand(
            workoutCommand: baseCommand,
            sessionCommand: sessionCommand,
          );

      final sessionPayload = <String, dynamic>{
        ...sessionCommand.toJson(),
        'clientSessionId': localSessionId,
      };

      final localSession = LocalWorkoutSession.fromWriteCommand(
        localSessionId: localSessionId,
        workoutId: workoutId,
        command: sessionCommand,
        now: now,
      );
      await _sessionHiveService.saveSession(localSession);

      final updatedSnapshot = StructuredWorkoutSnapshot(
        workoutId: workoutId,
        workoutWriteCommandJson: jsonEncode(
          mergedWorkoutCommand.toJson(includeId: true),
        ),
        sourceUpdatedAt: workout.lastUsed,
        updatedAt: now,
      );
      await _structuredHiveService.saveSnapshot(updatedSnapshot);

      final patchedLocalWorkout = _applyMergedCommandToWorkoutModel(
        workout: workout,
        mergedWorkoutCommand: mergedWorkoutCommand,
        completedAt: sessionCommand.completedAt ?? DateTime.now(),
      );
      await _hiveService.patchWorkout(patchedLocalWorkout);

      final syncJob = SessionSyncJob(
        jobId: jobId,
        localSessionId: localSessionId,
        workoutId: workoutId,
        sessionPayloadJson: jsonEncode(sessionPayload),
        mergedWorkoutCommandJson: jsonEncode(
          mergedWorkoutCommand.toJson(includeId: false),
        ),
        status: SessionSyncJobStatus.queued,
        retryCount: 0,
        nextRetryAt: null,
        lastError: null,
        createdAt: now,
        updatedAt: now,
      );
      await _sessionHiveService.enqueueSyncJob(syncJob);

      unawaited(
        _sessionSyncService.syncPendingSessions(trigger: 'save_session'),
      );
      return ApiResponse.success(
        message: 'Session saved locally and queued for sync.',
      );
    } catch (error) {
      return ApiResponse.error(
        message: 'Failed to save session locally: ${error.toString()}',
      );
    }
  }

  Future<WorkoutWriteCommand> _resolveStructuredSnapshotCommand({
    required WorkoutModel workout,
    required String workoutId,
  }) async {
    final existingSnapshot = await _structuredHiveService.getSnapshot(
      workoutId,
    );
    if (existingSnapshot != null) {
      try {
        final snapshotJson = jsonDecode(
          existingSnapshot.workoutWriteCommandJson,
        );
        if (snapshotJson is Map) {
          return WorkoutWriteCommand.fromJson(
            snapshotJson.map((key, value) => MapEntry(key.toString(), value)),
          );
        }
      } catch (_) {
        // Fallback below.
      }
    }

    final command = WorkoutWriteCommandMapper.fromWorkoutModel(workout);
    final snapshot = StructuredWorkoutSnapshot(
      workoutId: workoutId,
      workoutWriteCommandJson: jsonEncode(command.toJson(includeId: true)),
      sourceUpdatedAt: workout.lastUsed,
      updatedAt: DateTime.now().toUtc(),
    );
    await _structuredHiveService.saveSnapshot(snapshot);
    return command;
  }

  WorkoutModel _applyMergedCommandToWorkoutModel({
    required WorkoutModel workout,
    required WorkoutWriteCommand mergedWorkoutCommand,
    required DateTime completedAt,
  }) {
    final existingByExerciseId = <String, Queue<WorkoutExerciseModel>>{};
    for (final exercise in workout.workoutExercises) {
      final exerciseId = exercise.exercise.id;
      if (exerciseId == null || exerciseId.isEmpty) {
        continue;
      }
      final queue =
          existingByExerciseId[exerciseId] ?? Queue<WorkoutExerciseModel>();
      queue.add(exercise);
      existingByExerciseId[exerciseId] = queue;
    }

    final mergedEntries = <WorkoutEntryWritePayload>[];
    for (final block in mergedWorkoutCommand.blocks) {
      mergedEntries.addAll(block.entries);
    }

    final updatedExercises = <WorkoutExerciseModel>[];
    for (final mergedEntry in mergedEntries) {
      final queue = existingByExerciseId[mergedEntry.exerciseId];
      final previousExercise = queue == null || queue.isEmpty
          ? null
          : queue.removeFirst();

      final firstSet = mergedEntry.sets.isNotEmpty
          ? mergedEntry.sets.first
          : null;
      final setCount = mergedEntry.sets.length;
      final reps = firstSet?.reps;
      final setsLabel = reps != null ? '${setCount}x$reps' : '${setCount}x';
      final restLabel = firstSet?.restSeconds != null
          ? '${firstSet!.restSeconds}s'
          : (previousExercise?.rest ?? '-');
      final weightLabel = _buildWeightLabel(
        load: firstSet?.load,
        loadUnit: firstSet?.loadUnit,
        fallback: previousExercise?.weight ?? '-',
      );

      final updatedExercise =
          previousExercise?.copyWith(
            sets: setsLabel,
            rest: restLabel,
            weight: weightLabel,
          ) ??
          WorkoutExerciseModel(
            id: mergedEntry.id ?? '${workout.id}_${mergedEntry.position}',
            exercise: ExerciseDetailModel(id: mergedEntry.exerciseId),
            sets: setsLabel,
            rest: restLabel,
            weight: weightLabel,
            progress: 0.0,
          );

      updatedExercises.add(updatedExercise);
    }

    for (final queue in existingByExerciseId.values) {
      if (queue.isNotEmpty) {
        updatedExercises.addAll(queue);
      }
    }

    return workout.copyWith(
      workoutExercises: updatedExercises,
      exercises: updatedExercises.length,
      sessionsCount: workout.sessionsCount + 1,
      lastUsed: completedAt,
      dirty: true,
    );
  }

  String _buildWeightLabel({
    required num? load,
    required String? loadUnit,
    required String fallback,
  }) {
    if (load == null) {
      return fallback;
    }

    final normalizedLoad = load % 1 == 0 ? load.toInt().toString() : '$load';
    final unit = (loadUnit == null || loadUnit.isEmpty) ? '' : loadUnit;
    return '$normalizedLoad$unit';
  }

  String _generateUuidV4() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
