import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/voice/data/local/voice_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late FixedClock clock;
  late VoiceDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FixedClock(DateTime.utc(2026, 1, 1));
    dao = VoiceDao(db, clock);
  });

  tearDown(() => db.close());

  group('alias', () {
    test('una conferma ripetuta alza il contatore di hit', () async {
      await dao.upsertAlias(phrase: 'panca piana', exerciseId: 'bench-press');
      await dao.upsertAlias(phrase: 'panca piana', exerciseId: 'bench-press');
      await dao.upsertAlias(phrase: 'panca piana', exerciseId: 'bench-press');

      final alias = await dao.aliasFor('panca piana');
      expect(alias, isNotNull);
      expect(alias!.exerciseId, 'bench-press');
      // È l'apprendimento più economico disponibile: nessun modello, un
      // contatore (`docs/development/23-voice.md`).
      expect(alias.hits, 3);
    });

    test('un esercizio diverso smentisce lalias e riparte da uno', () async {
      await dao.upsertAlias(phrase: 'panca', exerciseId: 'bench-press');
      await dao.upsertAlias(phrase: 'panca', exerciseId: 'bench-press');
      await dao.upsertAlias(phrase: 'panca', exerciseId: 'incline-press');

      final alias = await dao.aliasFor('panca');
      expect(alias!.exerciseId, 'incline-press');
      expect(alias.hits, 1);
    });

    test('createdAt non cambia, lastUsedAt si', () async {
      await dao.upsertAlias(phrase: 'squat', exerciseId: 'back-squat');
      clock.advance(const Duration(days: 5));
      await dao.upsertAlias(phrase: 'squat', exerciseId: 'back-squat');

      final alias = await dao.aliasFor('squat');
      expect(alias!.createdAt.toUtc(), DateTime.utc(2026, 1, 1));
      expect(alias.lastUsedAt.toUtc(), DateTime.utc(2026, 1, 6));
    });

    test('una frase vuota non produce alias', () async {
      await dao.upsertAlias(phrase: '   ', exerciseId: 'back-squat');
      expect(await dao.aliasFor(''), isNull);
      expect(await db.select(db.voiceAliases).get(), isEmpty);
    });

    test('watchAliases emette a ogni scrittura', () async {
      final emissions = <int>[];
      final subscription = dao
          .watchAliases()
          .map((rows) => rows.length)
          .listen(emissions.add);
      await pumpEventQueue();

      await dao.upsertAlias(phrase: 'stacco', exerciseId: 'deadlift');
      await pumpEventQueue();
      await subscription.cancel();

      expect(emissions, containsAllInOrder([0, 1]));
    });
  });

  group('log di risoluzione', () {
    Future<void> log(String id) => dao.logResolution(
      id: id,
      normalizedText: 'ottanta per otto rir due',
      outcome: 'accepted',
      confidence: 0.91,
    );

    test('la potatura cancella i log oltre i 90 giorni', () async {
      await log('old');
      clock.advance(const Duration(days: 89));
      await log('recent');

      // 90 giorni dopo il primo log: il primo e scaduto, il secondo no.
      clock.advance(const Duration(days: 1, minutes: 1));
      final removed = await dao.pruneExpiredLogs();

      expect(removed, 1);
      final remaining = await dao.allLogs();
      expect(remaining, hasLength(1));
      expect(remaining.single.id, 'recent');
    });

    test('senza tempo che passa non si pota nulla', () async {
      await log('a');
      await log('b');
      expect(await dao.pruneExpiredLogs(), 0);
      expect(await dao.allLogs(), hasLength(2));
    });

    test('la correzione dellutente si annota sul log', () async {
      await log('a');
      await dao.markCorrection(id: 'a', correctedExerciseId: 'bench-press');

      final row = (await dao.allLogs()).single;
      expect(row.correctedExerciseId, 'bench-press');
      // Il testo grezzo pre-normalizzazione non esiste nemmeno come colonna:
      // l'invariante di privacy e nello schema, non in una convenzione
      // (`docs/development/24-security-and-privacy.md`).
      expect(row.normalizedText, 'ottanta per otto rir due');
    });
  });
}
