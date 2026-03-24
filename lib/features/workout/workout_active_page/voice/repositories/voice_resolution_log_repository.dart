import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceResolutionLogRepositoryProvider =
    Provider<VoiceResolutionLogRepository>((ref) {
      final localDb = ref.watch(localDatabaseServiceProvider);
      return VoiceResolutionLogRepository(localDb);
    });

class VoiceResolutionLogRepository {
  const VoiceResolutionLogRepository(this._localDbService);

  final LocalDatabaseService _localDbService;

  Future<String> createLog({
    required ParsedVoiceEntry parsedEntry,
    required List<VoiceExerciseCandidate> candidates,
    required double confidence,
    required VoiceMatchDecisionType decisionType,
  }) async {
    final logId = DateTime.now().microsecondsSinceEpoch.toString();
    await _localDbService.voiceResolutionLogs.put(logId, {
      'id': logId,
      'originalText': parsedEntry.originalText,
      'normalizedText': parsedEntry.normalizedText,
      'parsedExercisePhrase': parsedEntry.exercisePhrase,
      'detectedSets': parsedEntry.sets,
      'detectedReps': parsedEntry.reps,
      'detectedWeight': parsedEntry.weightKg,
      'topCandidates': candidates.take(5).map((candidate) {
        return {
          'exerciseId': candidate.exerciseId,
          'displayName': candidate.displayName,
          'baseScore': candidate.baseScore,
          'finalScore': candidate.finalScore,
          'isInActiveWorkout': candidate.isInActiveWorkout,
        };
      }).toList(),
      'selectedExerciseId': null,
      'confidence': confidence,
      'decision': decisionType.name,
      'createdAt': DateTime.now().toIso8601String(),
    });
    return logId;
  }

  Future<void> markSelection({
    required String logId,
    required String selectedExerciseId,
  }) async {
    final current = _localDbService.voiceResolutionLogs.get(logId);
    if (current == null) {
      return;
    }

    await _localDbService.voiceResolutionLogs.put(logId, {
      ...current,
      'selectedExerciseId': selectedExerciseId,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
