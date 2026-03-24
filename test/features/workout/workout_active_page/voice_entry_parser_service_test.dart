import 'package:coachly/features/workout/workout_active_page/voice/services/voice_entry_parser_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VoiceEntryParserService', () {
    test('extracts sets reps and weight from normalized text', () {
      const service = VoiceEntryParserService();

      final result = service.parse(
        originalText: 'Lat machine presa larga, 3 da 10, 45 chili',
        normalizedText: 'lat machine presa larga 3 da 10 45 kg',
      );

      expect(result.sets, 3);
      expect(result.reps, 10);
      expect(result.weightKg, 45);
      expect(result.exercisePhrase, 'lat machine presa larga');
    });
  });
}
