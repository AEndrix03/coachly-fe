import 'dart:io';

import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/session_sync_job_model.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// Il logout cancella il database locale. Se la coda di sync non è vuota,
/// quei dati sono l'unica copia esistente di allenamenti registrati in
/// palestra: cancellarli senza conferma è una perdita irreversibile.
///
/// Vedi `docs/development/24-security-and-privacy.md`.
void main() {
  late Directory tempDir;
  late Box<Map> sessionsBox;
  late Box<Map> syncJobsBox;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('coachly_logout_guard');
    Hive.init(tempDir.path);
    sessionsBox = await Hive.openBox<Map>('sessions_test');
    syncJobsBox = await Hive.openBox<Map>('sync_jobs_test');
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(_FakeAuthService()),
        workoutSessionHiveServiceProvider.overrideWithValue(
          WorkoutSessionHiveService.fromBoxes(
            sessionsBox: sessionsBox,
            syncJobsBox: syncJobsBox,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> enqueueJob(String jobId) async {
    final now = DateTime.now().toUtc();
    final job = SessionSyncJob(
      jobId: jobId,
      localSessionId: 'session-$jobId',
      workoutId: 'workout-1',
      sessionPayloadJson: '{}',
      mergedWorkoutCommandJson: '{}',
      status: SessionSyncJobStatus.queued,
      retryCount: 0,
      nextRetryAt: null,
      lastError: null,
      createdAt: now,
      updatedAt: now,
    );
    await syncJobsBox.put(jobId, job.toJson());
  }

  test('senza dati in coda il conteggio è zero', () async {
    final container = buildContainer();

    final pending = await container
        .read(authProvider.notifier)
        .pendingSyncCount();

    expect(pending, 0);
  });

  test('con allenamenti non sincronizzati il logout viene rifiutato', () async {
    await enqueueJob('job-1');
    await enqueueJob('job-2');
    final container = buildContainer();
    final notifier = container.read(authProvider.notifier);

    expect(await notifier.pendingSyncCount(), 2);

    final didLogout = await notifier.logout();

    expect(
      didLogout,
      isFalse,
      reason: 'il logout non deve procedere con dati non sincronizzati',
    );
    expect(
      syncJobsBox.length,
      2,
      reason: 'i dati dell\'utente devono restare sul dispositivo',
    );
  });
}

class _FakeAuthService implements AuthService {
  @override
  Future<void> clearTokens() async {}

  @override
  Future<void> endSession() async {}

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getIdToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<LoginResponseDto> login() => throw UnimplementedError();

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) =>
      throw UnimplementedError();

  @override
  Future<void> saveTokens(
    String accessToken,
    String refreshToken, {
    String? idToken,
  }) async {}
}
