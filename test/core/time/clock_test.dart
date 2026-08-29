import 'package:coachly/core/time/clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FixedClock', () {
    test('il tempo non scorre finche non lo si muove', () {
      final clock = FixedClock(DateTime.utc(2026, 3, 28, 23, 30));

      final first = clock.nowUtc();
      final second = clock.nowUtc();

      expect(first, second);
      expect(first, DateTime.utc(2026, 3, 28, 23, 30));
    });

    test('advance sposta l allenamento oltre la mezzanotte', () {
      final clock = FixedClock(DateTime.utc(2026, 3, 28, 23, 30));

      clock.advance(const Duration(minutes: 45));

      expect(clock.nowUtc(), DateTime.utc(2026, 3, 29, 0, 15));
      expect(clock.nowUtc().day, 29);
    });

    test('setTo riposiziona l orologio su un istante preciso', () {
      final clock = FixedClock(DateTime.utc(2026, 1, 1));

      clock.setTo(DateTime.utc(2026, 10, 25, 2, 30));

      expect(clock.nowUtc(), DateTime.utc(2026, 10, 25, 2, 30));
    });

    test('nowUtc e now descrivono lo stesso istante', () {
      final clock = FixedClock(DateTime.utc(2026, 6, 1, 12));

      expect(clock.now().toUtc().difference(clock.nowUtc()), Duration.zero);
      expect(clock.nowUtc().isUtc, isTrue);
    });

    test('un istante locale resta locale su now e diventa utc su nowUtc', () {
      final local = DateTime(2026, 6, 1, 12);
      final clock = FixedClock(local);

      expect(clock.now().isUtc, isFalse);
      expect(clock.now(), local);
      expect(clock.nowUtc(), local.toUtc());
    });

    test('lo streak interrotto si misura in giorni fra due letture', () {
      final clock = FixedClock(DateTime.utc(2026, 2, 1, 20));
      final lastWorkoutAt = clock.nowUtc();

      clock.advance(const Duration(days: 2, hours: 1));

      expect(clock.nowUtc().difference(lastWorkoutAt).inDays, 2);
    });
  });

  group('SystemClock', () {
    test('nowUtc e in utc e vicino a now', () {
      const clock = SystemClock();

      final utc = clock.nowUtc();
      final local = clock.now();

      expect(utc.isUtc, isTrue);
      expect(local.isUtc, isFalse);
      expect(
        utc.difference(local.toUtc()).abs(),
        lessThan(const Duration(seconds: 5)),
      );
    });
  });
}
