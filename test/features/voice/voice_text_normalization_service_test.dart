import 'package:coachly/features/voice/domain/voice_text_normalization_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VoiceTextNormalizationService', () {
    test('normalizes spoken numbers and kilograms', () {
      const service = VoiceTextNormalizationService();

      final normalized = service.normalize(
        'Lat machine presa larga, tre da dieci, 45 chili',
      );

      expect(normalized, 'lat machine presa larga 3 da 10 45 kg');
    });
  });
}
