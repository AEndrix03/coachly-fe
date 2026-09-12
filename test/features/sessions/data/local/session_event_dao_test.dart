import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/features/sessions/data/local/session_event_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SessionEventDao dao;

  final occurredAt = DateTime.utc(2026, 3, 18, 11);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = SessionEventDao(db);
  });

  tearDown(() => db.close());

  Future<void> append(String id, String sessionId, int seq) => dao.append(
    id: id,
    sessionId: sessionId,
    seq: seq,
    occurredAt: occurredAt,
    type: 'set_completed',
  );

  group('nextSeq', () {
    test('parte da zero quando la sessione non ha eventi', () async {
      expect(await dao.nextSeq('s1'), 0);
    });

    test('riprende dal massimo scritto, non da un contatore in memoria', () async {
      // L'app puo' essere chiusa e riaperta a meta' allenamento: un contatore
      // ripartito da zero farebbe collidere i nuovi eventi con quelli gia'
      // scritti, e la collisione la scoprirebbe solo il backend.
      await append('e0', 's1', 0);
      await append('e1', 's1', 1);

      expect(await dao.nextSeq('s1'), 2);
    });

    test('è per sessione, non globale', () async {
      await append('e0', 's1', 7);

      expect(await dao.nextSeq('s2'), 0);
    });
  });

  group('pending', () {
    test('restituisce solo i non sincronizzati, in ordine di seq', () async {
      await append('e2', 's1', 2);
      await append('e0', 's1', 0);
      await append('e1', 's1', 1);
      await dao.markSynced(['e0'], syncedAt: occurredAt);

      final pending = await dao.pending();

      expect(pending.map((event) => event.seq), [1, 2]);
    });

    test('rispetta il tetto del batch', () async {
      for (var seq = 0; seq < 10; seq++) {
        await append('e$seq', 's1', seq);
      }

      expect((await dao.pending(limit: 4)).length, 4);
    });
  });

  test('riscrivere lo stesso evento non lo duplica', () async {
    await append('e0', 's1', 0);
    await append('e0', 's1', 0);

    expect((await dao.forSession('s1')).length, 1);
  });

  test('due eventi diversi non possono avere lo stesso seq', () async {
    // È lo stesso vincolo su cui si fonda l'idempotenza dell'append lato
    // backend: se saltasse qui, il secondo evento sparirebbe là in silenzio.
    await append('e0', 's1', 0);

    expect(
      () => append('e1', 's1', 0),
      throwsA(isA<Exception>()),
    );
  });
}
