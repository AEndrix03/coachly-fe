import 'package:coachly/core/ids/id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UuidIdGenerator', () {
    test('produce uuid v4 formalmente validi', () {
      const generator = UuidIdGenerator();
      final id = generator.newId();

      expect(
        id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-'
            r'[0-9a-f]{12}$',
          ),
        ),
      );
    });

    test('non ripete lo stesso identificatore', () {
      const generator = UuidIdGenerator();
      final ids = List.generate(200, (_) => generator.newId()).toSet();

      expect(ids, hasLength(200));
    });

    test('la chiave di idempotenza e distinta dall id', () {
      const generator = UuidIdGenerator();

      expect(generator.newIdempotencyKey(), isNot(generator.newId()));
    });
  });

  group('SequentialIdGenerator', () {
    test('produce identificatori prevedibili e ordinati', () {
      final generator = SequentialIdGenerator(prefix: 'job');

      expect(generator.newId(), 'job-1');
      expect(generator.newId(), 'job-2');
      expect(generator.issuedIds, 2);
    });

    test('id e chiavi di idempotenza hanno contatori separati', () {
      final generator = SequentialIdGenerator();

      expect(generator.newId(), 'id-1');
      expect(generator.newIdempotencyKey(), 'idem-1');
      expect(generator.newIdempotencyKey(), 'idem-2');
      expect(generator.issuedIdempotencyKeys, 2);
      expect(generator.issuedIds, 1);
    });
  });
}
