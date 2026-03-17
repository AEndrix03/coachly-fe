import 'dart:io';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/sync/adapters/workout_adapter.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_sync_service.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_structured_hive_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

const _exerciseId = '11111111-1111-4111-8111-111111111111';

void main() {
  group('WorkoutPageRepositoryImpl.saveSession', () {
    late Directory tempDir;
    late Box<WorkoutModel> workoutsBox;
    late Box<Map> sessionsBox;
    late Box<Map> jobsBox;
    late Box<Map> structuredBox;
    late WorkoutHiveService workoutHiveService;
    late WorkoutSessionHiveService sessionHiveService;
    late WorkoutStructuredHiveService structuredHiveService;
    late _FakeWorkoutPageService fakeWorkoutPageService;
    late WorkoutSessionSyncService syncService;
    late WorkoutPageRepositoryImpl repository;

    setUp(() async {
      await Hive.close();
      tempDir = await Directory.systemTemp.createTemp(
        'coachly_workout_repository_test_',
      );
      Hive.init(tempDir.path);

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(WorkoutAdapter());
      }

      workoutsBox = await Hive.openBox<WorkoutModel>('repository_workouts_box');
      sessionsBox = await Hive.openBox<Map>('repository_sessions_box');
      jobsBox = await Hive.openBox<Map>('repository_jobs_box');
      structuredBox = await Hive.openBox<Map>('repository_structured_box');

      workoutHiveService = WorkoutHiveService.fromBox(workoutsBox);
      sessionHiveService = WorkoutSessionHiveService.fromBoxes(
        sessionsBox: sessionsBox,
        syncJobsBox: jobsBox,
      );
      structuredHiveService = WorkoutStructuredHiveService.fromBox(
        structuredBox,
      );
      fakeWorkoutPageService = _FakeWorkoutPageService();
      syncService = WorkoutSessionSyncService(
        sessionHiveService: sessionHiveService,
        workoutPageService: fakeWorkoutPageService,
        workoutHiveService: workoutHiveService,
        isAuthenticatedReader: () => true,
        isOnlineOverride: () async => false,
        invalidateWorkoutCaches: () {},
      );

      repository = WorkoutPageRepositoryImpl(
        fakeWorkoutPageService,
        workoutHiveService,
        sessionHiveService,
        structuredHiveService,
        syncService,
      );

      await workoutsBox.put('workout-1', _buildWorkout());
    });

    tearDown(() async {
      syncService.dispose();
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'returns local success immediately and enqueues persistent sync job',
      () async {
        final response = await repository.saveSession(
          'workout-1',
          _buildSession(),
        );

        expect(response.success, isTrue);
        expect(response.message, contains('queued'));

        final sessions = await sessionHiveService.getSessionsForWorkout(
          'workout-1',
        );
        expect(sessions, hasLength(1));
        expect(sessions.first.syncState, LocalWorkoutSessionSyncState.queued);

        final jobs = await sessionHiveService.getPendingJobsOrdered();
        expect(jobs, hasLength(1));
        expect(jobs.first.status, SessionSyncJobStatus.queued);
      },
    );

    test('updates local workout values before remote sync attempt', () async {
      await repository.saveSession('workout-1', _buildSession());

      final updatedWorkout = workoutsBox.get('workout-1');
      expect(updatedWorkout, isNotNull);
      expect(updatedWorkout!.dirty, isTrue);
      expect(updatedWorkout.workoutExercises.first.sets, '2x10');
      expect(updatedWorkout.workoutExercises.first.weight, '85kg');
      expect(fakeWorkoutPageService.uploadCalls, 0);
      expect(fakeWorkoutPageService.patchCalls, 0);
    });
  });
}

WorkoutModel _buildWorkout() {
  return WorkoutModel(
    id: 'workout-1',
    titleI18n: const {'it': 'Push Day'},
    descriptionI18n: const {'it': 'Desc'},
    goal: 'strength',
    lastUsed: DateTime.parse('2026-03-18T10:00:00.000Z'),
    type: 'Strength',
    workoutExercises: const [
      WorkoutExerciseModel(
        id: 'entry-1',
        exercise: ExerciseDetailModel(id: _exerciseId),
        sets: '2x8',
        rest: '90s',
        weight: '80kg',
        progress: 0,
      ),
    ],
    exercises: 1,
    sessionsCount: 4,
  );
}

WorkoutSessionWriteCommand _buildSession() {
  return WorkoutSessionWriteCommand(
    startedAt: DateTime.parse('2026-03-18T10:00:00.000Z'),
    completedAt: DateTime.parse('2026-03-18T10:45:00.000Z'),
    notes: null,
    entries: const [
      WorkoutSessionEntryWritePayload(
        exerciseId: _exerciseId,
        position: 0,
        completed: true,
        notes: null,
        sets: [
          WorkoutSessionSetWritePayload(
            position: 0,
            setType: 'normal',
            reps: 10,
            load: 85,
            loadUnit: 'kg',
            completed: true,
            notes: null,
          ),
        ],
      ),
    ],
  );
}

class _FakeWorkoutPageService extends WorkoutPageService {
  _FakeWorkoutPageService()
    : super(ApiClient(client: _NoopHttpClient(), baseUrl: 'https://localhost'));

  int uploadCalls = 0;
  int patchCalls = 0;

  @override
  Future<ApiResponse<void>> saveWorkoutSessionPayload(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    uploadCalls += 1;
    return ApiResponse.success();
  }

  @override
  Future<ApiResponse<void>> patchWorkoutPayload(
    String workoutId,
    Map<String, dynamic> commandPayload,
  ) async {
    patchCalls += 1;
    return ApiResponse.success();
  }
}

class _NoopHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError('No HTTP calls expected in repository tests.');
  }
}
