import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchConfidenceDeciderServiceProvider =
    Provider<MatchConfidenceDeciderService>((ref) {
      return const MatchConfidenceDeciderService();
    });

class MatchConfidenceDeciderService {
  const MatchConfidenceDeciderService({
    this.autoMatchThreshold = 0.82,
    this.topSuggestionsThreshold = 0.68,
    this.minDeltaForAutoMatch = 0.06,
  });

  final double autoMatchThreshold;
  final double topSuggestionsThreshold;
  final double minDeltaForAutoMatch;

  VoiceMatchDecision decide(List<VoiceExerciseCandidate> rankedCandidates) {
    if (rankedCandidates.isEmpty) {
      return const VoiceMatchDecision(
        type: VoiceMatchDecisionType.manualSelection,
        confidence: 0,
      );
    }

    final top1 = rankedCandidates.first;
    final top2 = rankedCandidates.length > 1 ? rankedCandidates[1] : null;
    final delta = top2 == null ? 1.0 : (top1.finalScore - top2.finalScore);

    if (top1.finalScore >= autoMatchThreshold && delta >= minDeltaForAutoMatch) {
      return VoiceMatchDecision(
        type: VoiceMatchDecisionType.autoMatch,
        confidence: top1.finalScore,
      );
    }

    if (top1.finalScore >= topSuggestionsThreshold) {
      return VoiceMatchDecision(
        type: VoiceMatchDecisionType.topSuggestions,
        confidence: top1.finalScore,
      );
    }

    return VoiceMatchDecision(
      type: VoiceMatchDecisionType.manualSelection,
      confidence: top1.finalScore,
    );
  }
}
