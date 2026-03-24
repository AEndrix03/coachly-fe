import 'dart:math';

import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/voice_text_normalization_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseCandidateRetrieverServiceProvider =
    Provider<ExerciseCandidateRetrieverService>((ref) {
      final normalizer = ref.watch(voiceTextNormalizationServiceProvider);
      return ExerciseCandidateRetrieverService(normalizer);
    });

class ExerciseCandidateRetrieverService {
  const ExerciseCandidateRetrieverService(this._normalizer);

  final VoiceTextNormalizationService _normalizer;

  List<VoiceExerciseCandidate> retrieve({
    required String phrase,
    required List<VoiceExerciseCatalogEntry> catalog,
    required VoiceResolutionContext context,
  }) {
    final normalizedPhrase = _normalizer.normalize(phrase);
    if (normalizedPhrase.isEmpty) {
      return const <VoiceExerciseCandidate>[];
    }

    final phraseTokens = _tokens(normalizedPhrase);
    final phraseTrigrams = _trigrams(normalizedPhrase);

    final candidates = <VoiceExerciseCandidate>[];
    for (final exercise in catalog) {
      final isInWorkout = context.containsExercise(exercise.exerciseId);
      final aliases = exercise.aliases.isEmpty
          ? <String>[exercise.canonicalName]
          : exercise.aliases;

      var bestExactScore = 0.0;
      var bestTokenScore = 0.0;
      var bestTrigramScore = 0.0;
      var bestEditScore = 0.0;
      var bestDisplayName = exercise.canonicalName;

      for (final rawAlias in aliases) {
        final alias = _normalizer.normalize(rawAlias);
        if (alias.isEmpty) {
          continue;
        }

        final exactScore = _exactOrPrefixScore(normalizedPhrase, alias);
        final tokenScore = _tokenOverlapScore(phraseTokens, _tokens(alias));
        final trigramScore = _jaccard(phraseTrigrams, _trigrams(alias));
        final editScore = _editSimilarity(normalizedPhrase, alias);

        final combined = (0.5 * exactScore) +
            (0.25 * tokenScore) +
            (0.15 * trigramScore) +
            (0.10 * editScore);

        if (combined > (0.5 * bestExactScore) +
            (0.25 * bestTokenScore) +
            (0.15 * bestTrigramScore) +
            (0.10 * bestEditScore)) {
          bestExactScore = exactScore;
          bestTokenScore = tokenScore;
          bestTrigramScore = trigramScore;
          bestEditScore = editScore;
          bestDisplayName = rawAlias;
        }
      }

      final baseScore = (0.5 * bestExactScore) +
          (0.25 * bestTokenScore) +
          (0.15 * bestTrigramScore) +
          (0.10 * bestEditScore);

      if (baseScore < 0.15) {
        continue;
      }

      candidates.add(
        VoiceExerciseCandidate(
          exerciseId: exercise.exerciseId,
          displayName: bestDisplayName,
          baseScore: baseScore,
          finalScore: baseScore,
          isInActiveWorkout: isInWorkout,
          scoreBreakdown: {
            'exactOrPrefixScore': bestExactScore,
            'tokenOverlapScore': bestTokenScore,
            'trigramScore': bestTrigramScore,
            'editSimilarityScore': bestEditScore,
            'baseScore': baseScore,
          },
        ),
      );
    }

    candidates.sort((a, b) => b.baseScore.compareTo(a.baseScore));
    return candidates.take(10).toList(growable: false);
  }

  double _exactOrPrefixScore(String phrase, String alias) {
    if (phrase == alias) return 1.0;
    if (alias.startsWith(phrase) || phrase.startsWith(alias)) return 0.88;
    if (alias.contains(phrase) || phrase.contains(alias)) return 0.72;
    return 0.0;
  }

  Set<String> _tokens(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toSet();
  }

  double _tokenOverlapScore(Set<String> left, Set<String> right) {
    return _jaccard(left, right);
  }

  Set<String> _trigrams(String value) {
    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length < 3) {
      return {cleaned};
    }

    final trigrams = <String>{};
    for (var i = 0; i <= cleaned.length - 3; i++) {
      trigrams.add(cleaned.substring(i, i + 3));
    }
    return trigrams;
  }

  double _jaccard(Set<String> left, Set<String> right) {
    if (left.isEmpty || right.isEmpty) {
      return 0;
    }

    final intersection = left.intersection(right).length.toDouble();
    final union = left.union(right).length.toDouble();
    if (union == 0) {
      return 0;
    }
    return intersection / union;
  }

  double _editSimilarity(String phrase, String alias) {
    final maxLen = max(phrase.length, alias.length);
    if (maxLen == 0) {
      return 1;
    }

    final distance = _levenshtein(phrase, alias);
    return 1 - (distance / maxLen);
  }

  int _levenshtein(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (_) => List<int>.filled(b.length + 1, 0),
    );

    for (var i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = min(
          min(
            matrix[i - 1][j] + 1,
            matrix[i][j - 1] + 1,
          ),
          matrix[i - 1][j - 1] + cost,
        );
      }
    }

    return matrix[a.length][b.length];
  }
}
