import 'package:coachly/core/text_filter/offensive_text_filter_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = OffensiveTextFilterService();

  group('OffensiveTextFilterService', () {
    test('replaces offensive words in free text', () {
      final sanitized = service.sanitize('Sei uno stronzo e un idiot4.');

      expect(sanitized, isNot(contains('stronzo')));
      expect(sanitized.toLowerCase(), isNot(contains('idiot4')));
      expect(sanitized, contains('gentilezza'));
    });

    test('detects separated and obfuscated profanity', () {
      final sanitized = service.sanitize('v.a.f.f.a.n.c.u.l.o non va bene');

      expect(sanitized.toLowerCase(), isNot(contains('v.a.f.f.a.n.c.u.l.o')));
      expect(sanitized, isNot(equals('v.a.f.f.a.n.c.u.l.o non va bene')));
    });

    test('title policy also replaces generic profanity', () {
      final freeText = service.sanitize('Workout di merda');
      final strictTitle = service.sanitize(
        'Workout di merda',
        policy: TextModerationPolicy.titleStrict,
      );

      expect(freeText, equals('Workout di merda'));
      expect(strictTitle.toLowerCase(), isNot(contains('merda')));
      expect(strictTitle, contains('gentilezza'));
    });

    test('does not alter clean text', () {
      final sanitized = service.sanitize('Allenamento spinta e mobilita');

      expect(sanitized, equals('Allenamento spinta e mobilita'));
    });
  });
}
