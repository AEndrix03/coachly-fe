import 'dart:io';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercises/data/local/custom_exercise_dao.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/sessions/data/local/session_dao.dart';
import 'package:coachly/features/sessions/domain/models/local_workout_session_model.dart';
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/features/active_workout/data/local/active_workout_draft_dao.dart';
import 'package:coachly/features/workouts/data/local/workout_dao.dart';
import 'package:coachly/features/workouts/domain/models/workout_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'dati utente e outbox sopravvivono alla riapertura del database',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'coachly-persistence-',
      );
      final file = File(
        '${directory.path}${Platform.pathSeparator}coachly.sqlite',
      );
      final now = DateTime.utc(2026, 8, 31, 10);
      final clock = FixedClock(now);

      var db = AppDatabase(NativeDatabase(file));
      await WorkoutDao(db).upsert(
        WorkoutModel(
          id: '11111111-1111-4111-8111-111111111111',
          titleI18n: const {'it': 'Persistente'},
          descriptionI18n: const {'it': 'Salvato localmente'},
          goal: 'strength',
          type: 'strength',
          lastUsed: now,
          dirty: true,
        ),
      );
      await CustomExerciseDao(db, clock, const SilentAppLogger()).upsert(
        const ExerciseDetailModel(
          id: '22222222-2222-4222-8222-222222222222',
          isPersonal: true,
          nameI18n: {'it': 'Offline'},
        ),
      );
      await ActiveWorkoutDraftDao(db, clock, const SilentAppLogger()).save(
        '11111111-1111-4111-8111-111111111111',
        {'phase': 'working', 'currentSetId': 'set-2'},
      );
      await SessionDao(db).upsert(
        LocalWorkoutSession(
          localSessionId: '33333333-3333-4333-8333-333333333333',
          workoutId: '11111111-1111-4111-8111-111111111111',
          startedAt: now,
          completedAt: now,
          notes: null,
          entries: const [],
          syncState: LocalWorkoutSessionSyncState.queued,
          retryCount: 0,
          nextRetryAt: null,
          lastError: null,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await OutboxDao(db, clock: clock).enqueue(
        id: '44444444-4444-4444-8444-444444444444',
        entityType: 'session',
        entityId: '33333333-3333-4333-8333-333333333333',
        operation: 'create',
        payload: '{}',
      );
      await db.close();

      db = AppDatabase(NativeDatabase(file));
      expect(await WorkoutDao(db).getWorkouts(), hasLength(1));
      expect(
        await CustomExerciseDao(
          db,
          clock,
          const SilentAppLogger(),
        ).getSummaries(),
        hasLength(1),
      );
      expect(
        await ActiveWorkoutDraftDao(
          db,
          clock,
          const SilentAppLogger(),
        ).read('11111111-1111-4111-8111-111111111111'),
        containsPair('currentSetId', 'set-2'),
      );
      expect(await SessionDao(db).getAllSessions(), hasLength(1));
      expect(await OutboxDao(db, clock: clock).pendingOrdered(), hasLength(1));

      await db.close();
      await directory.delete(recursive: true);
    },
  );
}
