import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userVoiceAliasRepositoryProvider = Provider<UserVoiceAliasRepository>((ref) {
  final localDb = ref.watch(localDatabaseServiceProvider);
  return UserVoiceAliasRepository(localDb);
});

class UserVoiceAliasRepository {
  const UserVoiceAliasRepository(this._localDbService);

  final LocalDatabaseService _localDbService;

  Future<UserVoiceAliasMatch?> getAlias({
    required String userId,
    required String normalizedSpokenForm,
  }) async {
    final key = _buildKey(userId, normalizedSpokenForm);
    final raw = _localDbService.voiceAliases.get(key);
    if (raw == null) {
      return null;
    }

    final exerciseId = raw['exerciseId'] as String?;
    if (exerciseId == null || exerciseId.trim().isEmpty) {
      return null;
    }

    final confirmations = (raw['confirmations'] as num?)?.toInt() ?? 0;
    return UserVoiceAliasMatch(
      exerciseId: exerciseId,
      confirmations: confirmations,
    );
  }

  Future<void> registerSelection({
    required String userId,
    required String normalizedSpokenForm,
    required String exerciseId,
  }) async {
    final key = _buildKey(userId, normalizedSpokenForm);
    final current = _localDbService.voiceAliases.get(key);

    var confirmations = 1;
    if (current != null && current['exerciseId'] == exerciseId) {
      final currentConfirmations = (current['confirmations'] as num?)?.toInt() ?? 0;
      confirmations = currentConfirmations + 1;
    }

    await _localDbService.voiceAliases.put(key, {
      'userId': userId,
      'spokenForm': normalizedSpokenForm,
      'exerciseId': exerciseId,
      'confirmations': confirmations,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  String _buildKey(String userId, String spokenForm) {
    return '$userId::$spokenForm';
  }
}
