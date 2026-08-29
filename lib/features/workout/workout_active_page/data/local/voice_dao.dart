import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accesso Drift alle due tabelle del sottosistema vocale.
///
/// Vedi `docs/development/23-voice.md`. Il DAO non esce da `data/local/`: sopra
/// di lui stanno i repository, che sono l'unico punto di ingresso
/// (`docs/development/04-data-layer.md`).
///
/// **Privacy** (`docs/development/24-security-and-privacy.md`): i log di
/// risoluzione contengono trascrizioni di parlato registrato in un luogo
/// pubblico, dove possono comparire terzi. Da qui derivano tre invarianti che
/// questo file rende strutturali:
///
/// 1. il testo grezzo pre-normalizzazione **non attraversa mai** questa
///    interfaccia: [logResolution] accetta solo `normalizedText`;
/// 2. i log restano **locali** — nessun metodo scrive in outbox;
/// 3. si potano dopo [logRetention] giorni, via [pruneExpiredLogs].
class VoiceDao {
  VoiceDao(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  /// Finestra di conservazione dei log vocali.
  static const Duration logRetention = Duration(days: 90);

  // ─── Alias ─────────────────────────────────────────────────────────────────

  /// Alias imparato per [phrase], oppure `null`.
  ///
  /// [phrase] è la forma **già normalizzata**: l'alias è una chiave di lookup,
  /// non una trascrizione.
  Future<VoiceAliasRow?> aliasFor(String phrase) {
    final key = phrase.trim();
    if (key.isEmpty) return Future<VoiceAliasRow?>.value();
    return (_db.select(
      _db.voiceAliases,
    )..where((row) => row.phrase.equals(key))).getSingleOrNull();
  }

  /// Tutti gli alias, come stream: una scrittura notifica i lettori senza
  /// nessuna `invalidate` (`docs/development/04-data-layer.md`, regola 4).
  Stream<List<VoiceAliasRow>> watchAliases() => (_db.select(
    _db.voiceAliases,
  )..orderBy([(row) => OrderingTerm.desc(row.hits)])).watch();

  /// Registra la conferma manuale di [phrase] → [exerciseId].
  ///
  /// È l'apprendimento più economico disponibile: ogni conferma alza il
  /// contatore di hit e con esso la confidenza per quella persona. Se la frase
  /// era associata a un altro esercizio il contatore riparte da uno, perché
  /// l'associazione precedente è stata smentita.
  Future<void> upsertAlias({
    required String phrase,
    required String exerciseId,
  }) async {
    final key = phrase.trim();
    if (key.isEmpty || exerciseId.trim().isEmpty) return;
    final now = _clock.nowUtc();

    await _db.transaction(() async {
      final existing = await aliasFor(key);
      final hits = existing != null && existing.exerciseId == exerciseId
          ? existing.hits + 1
          : 1;

      await _db
          .into(_db.voiceAliases)
          .insertOnConflictUpdate(
            VoiceAliasRow(
              phrase: key,
              exerciseId: exerciseId,
              hits: hits,
              createdAt: existing?.createdAt ?? now,
              lastUsedAt: now,
            ),
          );
    });
  }

  // ─── Log di risoluzione ────────────────────────────────────────────────────

  /// Registra un esito di risoluzione.
  ///
  /// [normalizedText] è, per costruzione, l'unico testo che si conserva.
  Future<void> logResolution({
    required String id,
    required String normalizedText,
    required String outcome,
    String? candidates,
    String? chosenExerciseId,
    double? confidence,
  }) {
    return _db
        .into(_db.voiceResolutionLogs)
        .insertOnConflictUpdate(
          VoiceResolutionLogRow(
            id: id,
            normalizedText: normalizedText,
            candidates: candidates,
            outcome: outcome,
            chosenExerciseId: chosenExerciseId,
            correctedExerciseId: null,
            confidence: confidence,
            createdAt: _clock.nowUtc(),
          ),
        );
  }

  /// Annota la correzione dell'utente sul log [id].
  ///
  /// È il campo che rende i log utili al tuning delle soglie: dice non solo
  /// cosa ha deciso il sistema, ma cosa era giusto.
  Future<void> markCorrection({
    required String id,
    required String correctedExerciseId,
  }) {
    return (_db.update(
      _db.voiceResolutionLogs,
    )..where((row) => row.id.equals(id))).write(
      VoiceResolutionLogsCompanion(
        correctedExerciseId: Value(correctedExerciseId),
      ),
    );
  }

  Future<List<VoiceResolutionLogRow>> allLogs() =>
      _db.select(_db.voiceResolutionLogs).get();

  /// Cancella i log creati prima di [cutoff].
  Future<int> pruneOlderThan(DateTime cutoff) {
    return (_db.delete(
      _db.voiceResolutionLogs,
    )..where((row) => row.createdAt.isSmallerThanValue(cutoff))).go();
  }

  /// Potatura a [logRetention] dal presente, letto dal [Clock] iniettato.
  Future<int> pruneExpiredLogs() =>
      pruneOlderThan(_clock.nowUtc().subtract(logRetention));
}

/// `keepAlive` per costruzione: un `Provider` non generato non si auto-dispone
/// in Riverpod 3, ed è ciò che serve a un DAO condiviso.
final voiceDaoProvider = Provider<VoiceDao>((ref) {
  return VoiceDao(ref.watch(appDatabaseProvider), ref.watch(clockProvider));
});
