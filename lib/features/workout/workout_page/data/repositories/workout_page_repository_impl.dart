import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/ids/id_generator.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/local/outbox_dao.dart';
import 'package:coachly/features/workout/workout_page/data/local/session_dao.dart';
import 'package:coachly/features/workout/workout_page/data/local/workout_dao.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_session_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/structured_workout_snapshot_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `keepAlive`: il repository e' il confine dei dati e vive quanto il
/// container (`docs/development/01-principles.md`).
final workoutPageRepositoryProvider = Provider<IWorkoutPageRepository>((ref) {
  return WorkoutPageRepositoryImpl(
    apiService: ref.watch(workoutPageServiceProvider),
    workoutDao: ref.watch(workoutDaoProvider),
    sessionDao: ref.watch(sessionDaoProvider),
    outboxDao: ref.watch(outboxDaoProvider),
    database: ref.watch(appDatabaseProvider),
    sessionSyncService: ref.watch(workoutSessionSyncServiceProvider),
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
  );
});

class WorkoutPageRepositoryImpl implements IWorkoutPageRepository {
  final WorkoutPageService _apiService;
  final WorkoutDao _workoutDao;
  final SessionDao _sessionDao;
  final OutboxDao _outboxDao;
  final AppDatabase _database;
  final WorkoutSessionSyncService _sessionSyncService;
  final Clock _clock;
  final IdGenerator _idGenerator;

  WorkoutPageRepositoryImpl({
    required WorkoutPageService apiService,
    required WorkoutDao workoutDao,
    required SessionDao sessionDao,
    required OutboxDao outboxDao,
    required AppDatabase database,
    required WorkoutSessionSyncService sessionSyncService,
    required Clock clock,
    required IdGenerator idGenerator,
  }) : _apiService = apiService,
       _workoutDao = workoutDao,
       _sessionDao = sessionDao,
       _outboxDao = outboxDao,
       _database = database,
       _sessionSyncService = sessionSyncService,
       _clock = clock,
       _idGenerator = idGenerator;

  /// Lettura reattiva: sostituisce le invalidazioni manuali dopo ogni
  /// scrittura (`docs/development/04-data-layer.md`).
  @override
  Stream<List<WorkoutModel>> watchWorkouts() => _workoutDao.watchWorkouts();

  @override
  Stream<List<LocalWorkoutSession>> watchSessions() =>
      _sessionDao.watchSessions();

  @override
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts() async {
    final localWorkouts = await _workoutDao.getWorkouts();
    if (localWorkouts.isNotEmpty) {
      return ApiResponse.success(data: localWorkouts);
    }
    return _performRefreshFromRemote();
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> refreshFromRemote() async {
    final response = await _performRefreshFromRemote();
    unawaited(
      _sessionSyncService.syncPendingSessions(trigger: 'refresh_remote'),
    );
    return response;
  }

  /// La deduplica delle richieste concorrenti sta nel `RequestCoalescer` di
  /// `ApiClient` (`docs/development/06-networking.md`), non piu' qui.
  Future<ApiResponse<List<WorkoutModel>>> _performRefreshFromRemote() async {
    List<WorkoutModel>? remoteWorkouts;
    try {
      final remoteResponse = await _apiService.fetchWorkouts();
      if (remoteResponse.success && remoteResponse.data != null) {
        remoteWorkouts = remoteResponse.data!;
        await _workoutDao.patchWorkouts(
          remoteWorkouts,
          updatedAt: _clock.nowUtc(),
        );
      } else {
        return ApiResponse.error(
          message:
              remoteResponse.message ??
              'Failed to refresh workouts from remote',
          statusCode: remoteResponse.statusCode,
          errors: remoteResponse.errors,
        );
      }

      final localWorkouts = await _workoutDao.getWorkouts();
      return ApiResponse.success(data: localWorkouts);
    } catch (error) {
      final localWorkouts = await _workoutDao.getWorkouts();
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
      final allWorkouts = [...?response.data]
        ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return ApiResponse.success(data: allWorkouts.take(3).toList());
    }
    return response;
  }

  @override
  Future<ApiResponse<WorkoutModel?>> getWorkout(String workoutId) async {
    try {
      var workout = await _workoutDao.getWorkout(workoutId);
      if (workout == null) {
        await refreshFromRemote();
        workout = await _workoutDao.getWorkout(workoutId);
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
    try {
      final workouts = await _workoutDao.getWorkouts();
      final sessions = await _sessionDao.getAllSessions();
      // Una sessione fallita in modo permanente resta un allenamento fatto:
      // non conta per la telemetria, ma il dato locale non si tocca.
      final validSessions = sessions
          .where(
            (session) =>
                session.syncState !=
                LocalWorkoutSessionSyncState.failedPermanent,
          )
          .toList(growable: false);

      final activeWorkouts = workouts
          .where((workout) => workout.active && !workout.delete)
          .length;

      final completedWorkouts = validSessions.isNotEmpty
          ? validSessions.length
          : workouts.fold<int>(
              0,
              (total, workout) => total + workout.sessionsCount,
            );

      final progressPercentage = workouts.isEmpty
          ? 0.0
          : (workouts.where((workout) => workout.sessionsCount > 0).length /
                    workouts.length) *
                100;

      final weeklyWorkouts = _computeWeeklyWorkouts(
        sessions: validSessions,
        workouts: workouts,
      );
      final currentStreak = _computeCurrentStreak(
        sessions: validSessions,
        workouts: workouts,
      );

      return ApiResponse.success(
        data: WorkoutStatsModel(
          activeWorkouts: activeWorkouts,
          completedWorkouts: completedWorkouts,
          progressPercentage: progressPercentage,
          currentStreak: currentStreak,
          weeklyWorkouts: weeklyWorkouts,
        ),
      );
    } catch (error) {
      return ApiResponse.error(
        message: 'Failed to compute workout stats: ${error.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<void>> enableWorkout(String workoutId) async {
    await _workoutDao.setActive(
      workoutId,
      active: true,
      updatedAt: _clock.nowUtc(),
    );
    return ApiResponse.success(message: 'Enabled workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> disableWorkout(String workoutId) async {
    await _workoutDao.setActive(
      workoutId,
      active: false,
      updatedAt: _clock.nowUtc(),
    );
    return ApiResponse.success(message: 'Disabled workout $workoutId');
  }

  @override
  Future<ApiResponse<void>> deleteWorkout(String workoutId) async {
    final response = await _apiService.deleteWorkout(workoutId);
    if (!response.success) {
      return response;
    }
    await _workoutDao.deleteWorkout(workoutId);
    return response;
  }

  @override
  Future<ApiResponse<void>> updateWorkout(WorkoutModel updatedWorkout) async {
    await _workoutDao.patchWorkout(updatedWorkout, updatedAt: _clock.nowUtc());
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

    final now = _clock.nowUtc();
    final localSessionId = _idGenerator.newId();
    final outboxId = _idGenerator.newIdempotencyKey();

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

      final patchedLocalWorkout = _applyMergedCommandToWorkoutModel(
        workout: workout,
        mergedWorkoutCommand: mergedWorkoutCommand,
        completedAt: sessionCommand.completedAt ?? _clock.now(),
      );

      // Il dato e la sua riga di outbox nella **stessa** transazione: se il
      // dato entrasse senza la riga, l'allenamento resterebbe sul dispositivo
      // e non salirebbe mai (`docs/development/04-data-layer.md`).
      await _database.transaction(() async {
        await _sessionDao.upsert(localSession);
        await _workoutDao.saveSnapshot(
          StructuredWorkoutSnapshot(
            workoutId: workoutId,
            workoutWriteCommandJson: jsonEncode(
              mergedWorkoutCommand.toJson(includeId: true),
            ),
            sourceUpdatedAt: workout.lastUsed,
            updatedAt: now,
          ),
        );
        await _workoutDao.patchWorkout(patchedLocalWorkout, updatedAt: now);
        await _outboxDao.enqueue(
          id: outboxId,
          entityType: 'session',
          entityId: localSessionId,
          operation: 'create',
          payload: jsonEncode(sessionPayload),
          secondaryPayload: jsonEncode(
            mergedWorkoutCommand.toJson(includeId: false),
          ),
        );
      });

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
    final existingSnapshot = await _workoutDao.getSnapshot(workoutId);
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
    await _workoutDao.saveSnapshot(
      StructuredWorkoutSnapshot(
        workoutId: workoutId,
        workoutWriteCommandJson: jsonEncode(command.toJson(includeId: true)),
        sourceUpdatedAt: workout.lastUsed,
        updatedAt: _clock.nowUtc(),
      ),
    );
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

  int _computeWeeklyWorkouts({
    required List<LocalWorkoutSession> sessions,
    required List<WorkoutModel> workouts,
  }) {
    final today = _localDay(_clock.now());
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    if (sessions.isNotEmpty) {
      return sessions.where((session) {
        final completedAt = session.completedAt ?? session.createdAt;
        final day = _localDay(completedAt);
        return !day.isBefore(weekStart) && !day.isAfter(weekEnd);
      }).length;
    }

    return workouts.where((workout) {
      if (workout.sessionsCount <= 0) {
        return false;
      }
      final day = _localDay(workout.lastUsed);
      return !day.isBefore(weekStart) && !day.isAfter(weekEnd);
    }).length;
  }

  int _computeCurrentStreak({
    required List<LocalWorkoutSession> sessions,
    required List<WorkoutModel> workouts,
  }) {
    final sessionDays = <DateTime>{};
    for (final session in sessions) {
      final completedAt = session.completedAt ?? session.createdAt;
      sessionDays.add(_localDay(completedAt));
    }

    if (sessionDays.isEmpty) {
      for (final workout in workouts) {
        if (workout.sessionsCount <= 0) {
          continue;
        }
        sessionDays.add(_localDay(workout.lastUsed));
      }
    }

    if (sessionDays.isEmpty) {
      return 0;
    }

    var cursor = _localDay(_clock.now());
    var streak = 0;
    while (sessionDays.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  DateTime _localDay(DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}
