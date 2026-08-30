import 'dart:math';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/features/sessions/data/local/session_dao.dart';
import 'package:coachly/features/workouts/data/local/workout_dao.dart';
import 'package:coachly/features/sessions/domain/models/local_workout_session_model.dart';
import 'package:coachly/features/workouts/data/services/workout_page_service.dart';
import 'package:coachly/features/sessions/data/services/workout_session_sync_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../network/fake_dio.dart';

/// Il backoff del sync diventa verificabile solo con un Clock iniettato:
/// `nextAttemptAt` e' un istante calcolato a partire da "adesso".
void main() {
  group('backoff del sync con FixedClock', () {
    late AppDatabase db;
    late FixedClock clock;
    late WorkoutDao workoutDao;
    late SessionDao sessionDao;
    late OutboxDao outboxDao;
    late _FailingWorkoutPageService workoutPageService;

    final frozenNow = DateTime.utc(2026, 3, 28, 23, 55);

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      clock = FixedClock(frozenNow);
      workoutDao = WorkoutDao(db);
      sessionDao = SessionDao(db);
      outboxDao = OutboxDao(db, clock: clock, random: Random(5));
      workoutPageService = _FailingWorkoutPageService();
    });

    tearDown(() => db.close());

    WorkoutSessionSyncService buildService() {
      return WorkoutSessionSyncService(
        sessionDao: sessionDao,
        workoutDao: workoutDao,
        outboxDao: outboxDao,
        workoutPageService: workoutPageService,
        isAuthenticatedReader: () => true,
        clock: clock,
        isOnlineOverride: () async => true,
      );
    }

    Future<void> seed() async {
      await sessionDao.upsert(
        _buildLocalSession(
          localSessionId: 'backoff-session',
          now: clock.nowUtc(),
        ),
      );
      await outboxDao.enqueue(
        id: 'o1',
        entityType: 'session',
        entityId: 'backoff-session',
        operation: 'create',
        payload: '{"entries":[]}',
        secondaryPayload: '{"name":"Workout","blocks":[]}',
      );
    }

    test('il primo errore transiente programma il retry dal clock', () async {
      final service = buildService();
      await seed();

      await service.syncPendingSessions(trigger: 'test_backoff');

      final row = await outboxDao.getById('o1');
      expect(OutboxStatus.fromValue(row!.status), OutboxStatus.pending);
      expect(row.attempts, 1);
      expect(row.updatedAt.toUtc(), frozenNow);

      // base 5s piu' jitter fino al 20%.
      final delay = row.nextAttemptAt!.difference(frozenNow);
      expect(delay, greaterThanOrEqualTo(const Duration(seconds: 5)));
      expect(delay, lessThanOrEqualTo(const Duration(seconds: 6)));

      service.dispose();
    });

    test('il retry attende che il clock raggiunga nextAttemptAt', () async {
      final service = buildService();
      await seed();

      await service.syncPendingSessions(trigger: 'first_attempt');
      final callsAfterFirst = workoutPageService.uploadCalls;

      // Il tempo non e' avanzato: la riga in attesa viene saltata.
      await service.syncPendingSessions(trigger: 'too_early');
      expect(workoutPageService.uploadCalls, callsAfterFirst);

      // Oltre la mezzanotte e oltre il ritardo: la riga viene ritentata.
      clock.advance(const Duration(minutes: 10));
      await service.syncPendingSessions(trigger: 'after_delay');
      expect(workoutPageService.uploadCalls, callsAfterFirst + 1);

      final row = await outboxDao.getById('o1');
      expect(row!.attempts, 2);
      expect(row.updatedAt.toUtc(), frozenNow.add(const Duration(minutes: 10)));
      expect(row.updatedAt.toUtc().day, 29);

      service.dispose();
    });

    test('il backoff cresce e resta limitato a 15 minuti', () async {
      final service = buildService();
      await seed();

      final delays = <Duration>[];
      for (var attempt = 0; attempt < 10; attempt++) {
        await service.syncPendingSessions(trigger: 'attempt');
        final row = await outboxDao.getById('o1');
        delays.add(row!.nextAttemptAt!.difference(clock.nowUtc()));
        clock.advance(const Duration(hours: 1));
      }

      expect(delays.first, lessThan(const Duration(seconds: 7)));
      expect(delays[3], greaterThan(delays.first));
      expect(delays.last, lessThanOrEqualTo(const Duration(minutes: 18)));

      service.dispose();
    });
  });
}

LocalWorkoutSession _buildLocalSession({
  required String localSessionId,
  required DateTime now,
}) {
  return LocalWorkoutSession(
    localSessionId: localSessionId,
    workoutId: 'workout-1',
    startedAt: now.subtract(const Duration(minutes: 30)),
    completedAt: now,
    notes: null,
    entries: const [
      LocalWorkoutSessionEntry(
        exerciseId: 'exercise-1',
        position: 0,
        completed: true,
        notes: null,
        sets: [
          LocalWorkoutSessionSet(
            position: 0,
            setType: 'normal',
            reps: 10,
            load: 80,
            loadUnit: 'kg',
            completed: true,
            notes: null,
          ),
        ],
      ),
    ],
    syncState: LocalWorkoutSessionSyncState.queued,
    retryCount: 0,
    nextRetryAt: null,
    lastError: null,
    createdAt: now,
    updatedAt: now,
  );
}

class _FailingWorkoutPageService extends WorkoutPageService {
  _FailingWorkoutPageService()
    : super(
        ApiClient(dio: fakeDio(FakeDioAdapter()), baseUrl: 'https://localhost'),
      );

  int uploadCalls = 0;

  @override
  Future<ApiResponse<void>> saveWorkoutSessionPayload(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    uploadCalls += 1;
    return ApiResponse.error(
      message: 'Temporary server issue',
      statusCode: 503,
    );
  }
}
