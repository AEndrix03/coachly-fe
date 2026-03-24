import 'dart:math';

import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseRerankerServiceProvider = Provider<ExerciseRerankerService>((ref) {
  return const ExerciseRerankerService();
});

class ExerciseRerankerService {
  const ExerciseRerankerService();

  List<VoiceExerciseCandidate> rerank({
    required List<VoiceExerciseCandidate> candidates,
    required VoiceResolutionContext context,
    required UserVoiceAliasMatch? userAliasMatch,
  }) {
    final exerciseOrderById = {
      for (final exercise in context.workoutExercises) exercise.exerciseId: exercise.order,
    };
    final completedById = {
      for (final exercise in context.workoutExercises)
        exercise.exerciseId: exercise.hasCompletedSets,
    };

    final reranked = candidates.map((candidate) {
      var boost = 0.0;
      var penalty = 0.0;

      if (candidate.isInActiveWorkout) {
        boost += 0.25;
      } else {
        penalty += 0.08;
      }

      if (context.currentExerciseOrder != null) {
        final candidateOrder = exerciseOrderById[candidate.exerciseId];
        if (candidateOrder != null) {
          final distance = (candidateOrder - context.currentExerciseOrder!).abs();
          final proximityBoost = max(0.0, 0.10 - (distance * 0.03));
          boost += proximityBoost;
        }
      }

      if (completedById[candidate.exerciseId] == true) {
        boost += 0.08;
      }

      if (userAliasMatch != null && userAliasMatch.exerciseId == candidate.exerciseId) {
        boost += userAliasMatch.confirmations >= 2 ? 0.30 : 0.15;
      }

      final tokenOverlap = candidate.scoreBreakdown['tokenOverlapScore'] ?? 0;
      final exact = candidate.scoreBreakdown['exactOrPrefixScore'] ?? 0;
      if (tokenOverlap < 0.2 && exact < 0.65) {
        penalty += 0.10;
      }

      final finalScore = _clamp(candidate.baseScore + boost - penalty);

      return candidate.copyWith(
        finalScore: finalScore,
        scoreBreakdown: {
          ...candidate.scoreBreakdown,
          'contextBoost': boost,
          'penalties': penalty,
          'finalScore': finalScore,
        },
      );
    }).toList();

    reranked.sort((a, b) => b.finalScore.compareTo(a.finalScore));
    return reranked;
  }

  double _clamp(double value) {
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }
}
