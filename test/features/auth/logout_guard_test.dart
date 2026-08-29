import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/features/workout/workout_page/data/local/outbox_dao.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/core/sync/sync_queue.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Il logout cancella il database locale. Se la coda di sync non è vuota,
/// quei dati sono l'unica copia esistente di allenamenti registrati in
/// palestra, spesso offline: cancellarli senza conferma è una perdita
/// irreversibile.
///
/// Vedi `docs/development/24-security-and-privacy.md`.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(_FakeAuthService()),
        appDatabaseProvider.overrideWithValue(db),
        // La guardia dipende da `SyncQueue`, non dalla feature workout: cosi'
        // il test non trascina dentro l'intero stack di rete.
        syncQueueProvider.overrideWithValue(
          OutboxSyncQueue(OutboxDao(db, clock: const SystemClock())),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> enqueue(String id) => db
      .into(db.outbox)
      .insert(
        OutboxCompanion.insert(
          id: id,
          entityType: 'session',
          entityId: 'session-$id',
          operation: 'create',
          payload: '{}',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );

  test('senza dati in coda il conteggio è zero', () async {
    final container = buildContainer();

    expect(await container.read(authProvider.notifier).pendingSyncCount(), 0);
  });

  test('con allenamenti non sincronizzati il logout viene rifiutato', () async {
    await enqueue('job-1');
    await enqueue('job-2');
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
      await db.select(db.outbox).get(),
      hasLength(2),
      reason: "i dati dell'utente devono restare sul dispositivo",
    );
  });

  test('con force il logout procede e svuota il database', () async {
    await enqueue('job-1');
    final container = buildContainer();

    final didLogout = await container
        .read(authProvider.notifier)
        .logout(force: true);

    expect(didLogout, isTrue);
    // `force` si passa solo dopo che l'utente ha confermato esplicitamente di
    // voler uscire pur avendo dati non sincronizzati.
    expect(await db.select(db.outbox).get(), isEmpty);
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
