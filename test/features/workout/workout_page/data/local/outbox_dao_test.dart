import 'dart:math';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/workout/workout_page/data/local/outbox_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// La coda e' append-only e client-authored: quattro stati, nessun conflitto
/// (`docs/development/05-sync-and-offline.md`).
void main() {
  late AppDatabase db;
  late FixedClock clock;
  late OutboxDao dao;

  final frozenNow = DateTime.utc(2026, 3, 28, 23, 55);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FixedClock(frozenNow);
    dao = OutboxDao(db, clock: clock, random: Random(3));
  });

  tearDown(() => db.close());

  Future<void> enqueue(String id, {String entityId = 'session-1'}) {
    return dao.enqueue(
      id: id,
      entityType: 'session',
      entityId: entityId,
      operation: 'create',
      payload: '{}',
    );
  }

  test('accoda in stato pending con il tempo del Clock', () async {
    await enqueue('o1');

    final row = (await dao.pendingOrdered()).single;
    expect(OutboxStatus.fromValue(row.status), OutboxStatus.pending);
    expect(row.attempts, 0);
    expect(row.nextAttemptAt, isNull);
    expect(row.createdAt.toUtc(), frozenNow);
  });

  test('pendingOrdered rispetta la semantica FIFO', () async {
    await enqueue('o1', entityId: 's1');
    clock.advance(const Duration(seconds: 30));
    await enqueue('o2', entityId: 's2');
    clock.advance(const Duration(seconds: 30));
    await enqueue('o3', entityId: 's3');

    expect((await dao.pendingOrdered()).map((row) => row.id), [
      'o1',
      'o2',
      'o3',
    ]);
  });

  test('sent e failed_permanent escono dalla coda', () async {
    await enqueue('o1', entityId: 's1');
    await enqueue('o2', entityId: 's2');

    await dao.markSent('o1');
    await dao.markFailedPermanent('o2', error: '[400] rejected');

    expect(await dao.pendingOrdered(), isEmpty);
    // Il fallimento riguarda la telemetria: la riga resta, con il suo errore.
    final failed = await dao.getById('o2');
    expect(
      OutboxStatus.fromValue(failed!.status),
      OutboxStatus.failedPermanent,
    );
    expect(failed.lastError, '[400] rejected');
    expect(failed.nextAttemptAt, isNull);
  });

  test('markSending non perde la riga', () async {
    await enqueue('o1');
    await dao.markSending('o1');

    final row = (await dao.pendingOrdered()).single;
    expect(OutboxStatus.fromValue(row.status), OutboxStatus.sending);
  });

  test('il backoff parte dal Clock e cresce esponenzialmente', () async {
    await enqueue('o1');

    final first = await dao.markFailed('o1', error: '[500] boom');
    // base 5s piu' jitter fino al 20%.
    expect(
      first.difference(frozenNow),
      greaterThanOrEqualTo(const Duration(seconds: 5)),
    );
    expect(
      first.difference(frozenNow),
      lessThanOrEqualTo(const Duration(seconds: 6)),
    );

    final afterFirst = await dao.getById('o1');
    expect(afterFirst!.attempts, 1);
    expect(OutboxStatus.fromValue(afterFirst.status), OutboxStatus.pending);

    final second = await dao.markFailed('o1', error: '[500] boom');
    expect(
      second.difference(frozenNow),
      greaterThan(first.difference(frozenNow)),
    );
  });

  test('il backoff resta limitato a 15 minuti', () async {
    await enqueue('o1');

    Duration? last;
    for (var attempt = 0; attempt < 12; attempt++) {
      final next = await dao.markFailed('o1', error: '[503] busy');
      last = next.difference(clock.nowUtc());
    }

    expect(last, greaterThanOrEqualTo(const Duration(minutes: 15)));
    expect(last, lessThanOrEqualTo(const Duration(minutes: 18)));
  });

  test('earliestNextAttemptAt trova il tentativo imminente', () async {
    await enqueue('o1', entityId: 's1');
    await enqueue('o2', entityId: 's2');

    await dao.markFailed('o2', error: 'boom');
    clock.advance(const Duration(minutes: 5));
    await dao.markFailed('o1', error: 'boom');

    final earliest = await dao.earliestNextAttemptAt();
    final o2 = await dao.getById('o2');
    expect(earliest, o2!.nextAttemptAt);
  });

  test('pruneSent butta solo le righe confermate dal server', () async {
    await enqueue('o1', entityId: 's1');
    await enqueue('o2', entityId: 's2');
    await dao.markSent('o1');
    await dao.markFailedPermanent('o2', error: 'nope');

    expect(await dao.pruneSent(), 1);
    expect(await dao.getById('o1'), isNull);
    expect(await dao.getById('o2'), isNotNull);
  });

  test('watchPending emette dopo una scrittura', () async {
    final counts = <int>[];
    final subscription = dao.watchPending().listen(
      (rows) => counts.add(rows.length),
    );
    await pumpEventQueue();

    await enqueue('o1');
    await pumpEventQueue();
    await subscription.cancel();

    expect(counts, containsAllInOrder([0, 1]));
  });
}
