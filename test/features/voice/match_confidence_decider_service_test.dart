import 'package:coachly/features/voice/domain/models/voice_resolution_models.dart';
import 'package:coachly/features/voice/domain/match_confidence_decider_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchConfidenceDeciderService', () {
    test('returns autoMatch when confidence and delta are high', () {
      const decider = MatchConfidenceDeciderService();

      final decision = decider.decide([
        const VoiceExerciseCandidate(
          exerciseId: 'ex_1',
          displayName: 'Lat Pulldown',
          baseScore: 0.84,
          finalScore: 0.9,
          isInActiveWorkout: true,
          scoreBreakdown: {},
        ),
        const VoiceExerciseCandidate(
          exerciseId: 'ex_2',
          displayName: 'Close Grip Pulldown',
          baseScore: 0.6,
          finalScore: 0.7,
          isInActiveWorkout: true,
          scoreBreakdown: {},
        ),
      ]);

      expect(decision.type, VoiceMatchDecisionType.autoMatch);
    });
  });
}
