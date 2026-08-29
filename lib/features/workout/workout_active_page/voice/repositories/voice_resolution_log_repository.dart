import 'dart:async';
import 'dart:convert';

import 'package:coachly/core/ids/id_generator.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/features/workout/workout_active_page/data/local/voice_dao.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceResolutionLogRepositoryProvider =
    Provider<VoiceResolutionLogRepository>((ref) {
      final repository = VoiceResolutionLogRepository(
        ref.watch(voiceDaoProvider),
        ref.watch(idGeneratorProvider),
      );
      // La potatura si innesca alla prima creazione del repository, cioe' la
      // prima volta che il sottosistema vocale viene usato in questa sessione.
      // Una ritenzione dichiarata e mai eseguita non e' una politica di
      // privacy, e' un commento (`docs/development/24-security-and-privacy.md`).
      unawaited(
        repository.pruneExpired().catchError((Object error) {
          ref
              .read(appLoggerProvider)
              .warn('Potatura dei log vocali fallita', error: error);
          return 0;
        }),
      );
      return repository;
    });

/// Log di risoluzione vocale, dataset per la calibrazione delle soglie.
///
/// **Privacy** (`docs/development/24-security-and-privacy.md`): le trascrizioni
/// nascono da un microfono aperto in un luogo pubblico, dove possono comparire
/// terzi. Quindi:
///
/// - il testo grezzo pre-normalizzazione **non si conserva**: di
///   [ParsedVoiceEntry] questo repository legge solo `normalizedText`, mai
///   `originalText`;
/// - i log restano **locali** e non entrano in outbox: salgono solo con un
///   consenso esplicito e separato, che oggi è di default `off`;
/// - si potano dopo 90 giorni, via [pruneExpired].
class VoiceResolutionLogRepository {
  const VoiceResolutionLogRepository(this._dao, this._ids);

  final VoiceDao _dao;
  final IdGenerator _ids;

  Future<String> createLog({
    required ParsedVoiceEntry parsedEntry,
    required List<VoiceExerciseCandidate> candidates,
    required double confidence,
    required VoiceMatchDecisionType decisionType,
  }) async {
    final logId = _ids.newId();
    await _dao.logResolution(
      id: logId,
      // Solo il normalizzato: `parsedEntry.originalText` non va persistito.
      normalizedText: parsedEntry.normalizedText,
      outcome: decisionType.name,
      confidence: confidence,
      candidates: jsonEncode([
        for (final candidate in candidates.take(5))
          {
            'exerciseId': candidate.exerciseId,
            'displayName': candidate.displayName,
            'baseScore': candidate.baseScore,
            'finalScore': candidate.finalScore,
            'isInActiveWorkout': candidate.isInActiveWorkout,
          },
      ]),
      chosenExerciseId: candidates.isEmpty ? null : candidates.first.exerciseId,
    );
    return logId;
  }

  /// Annota l'esercizio che l'utente ha scelto correggendo la proposta.
  Future<void> markSelection({
    required String logId,
    required String selectedExerciseId,
  }) {
    return _dao.markCorrection(
      id: logId,
      correctedExerciseId: selectedExerciseId,
    );
  }

  /// Potatura a 90 giorni. Va chiamata all'avvio del sottosistema vocale.
  Future<int> pruneExpired() => _dao.pruneExpiredLogs();
}
