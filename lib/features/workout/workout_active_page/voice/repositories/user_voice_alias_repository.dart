import 'package:coachly/features/workout/workout_active_page/data/local/voice_dao.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userVoiceAliasRepositoryProvider = Provider<UserVoiceAliasRepository>((
  ref,
) {
  return UserVoiceAliasRepository(ref.watch(voiceDaoProvider));
});

/// Alias vocali imparati dall'utente (`docs/development/23-voice.md`).
///
/// Il database è per utente (`docs/development/24-security-and-privacy.md`),
/// quindi la chiave è la sola frase normalizzata: non serve prefissarla con
/// l'id dell'utente come faceva la vecchia box Hive condivisa.
class UserVoiceAliasRepository {
  const UserVoiceAliasRepository(this._dao);

  final VoiceDao _dao;

  Future<UserVoiceAliasMatch?> getAlias({
    required String normalizedSpokenForm,
  }) async {
    final row = await _dao.aliasFor(normalizedSpokenForm);
    if (row == null || row.exerciseId.trim().isEmpty) return null;
    return UserVoiceAliasMatch(
      exerciseId: row.exerciseId,
      confirmations: row.hits,
    );
  }

  /// Ogni conferma manuale alza il contatore di hit, e con esso la confidenza
  /// della prossima risoluzione della stessa frase.
  Future<void> registerSelection({
    required String normalizedSpokenForm,
    required String exerciseId,
  }) {
    return _dao.upsertAlias(
      phrase: normalizedSpokenForm,
      exerciseId: exerciseId,
    );
  }

  /// Lettura reattiva: la UI si aggiorna perché il database notifica.
  Stream<List<UserVoiceAliasMatch>> watchAliases() {
    return _dao.watchAliases().map(
      (rows) => rows
          .map(
            (row) => UserVoiceAliasMatch(
              exerciseId: row.exerciseId,
              confirmations: row.hits,
            ),
          )
          .toList(growable: false),
    );
  }
}
