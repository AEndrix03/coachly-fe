import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accesso Drift alle bozze di allenamento in corso.
///
/// La bozza è ciò che permette a una sessione di sopravvivere alla chiusura
/// della app in palestra. È **dato utente**, quindi insostituibile
/// (`docs/development/04-data-layer.md`): la riga si sovrascrive, non si
/// accumula, e si cancella solo quando la sessione è stata salvata davvero.
///
/// Il payload è un documento JSON: la forma dello stato attivo cambia spesso e
/// non merita una tabella normalizzata finché non ci sono query che la
/// interrogano per campo.
class ActiveWorkoutDraftDao {
  ActiveWorkoutDraftDao(this._db, this._clock, this._logger);

  final AppDatabase _db;
  final Clock _clock;
  final AppLogger _logger;

  Future<void> save(String workoutId, Map<String, dynamic> payload) {
    return _db
        .into(_db.activeWorkoutDrafts)
        .insertOnConflictUpdate(
          ActiveWorkoutDraftRow(
            workoutId: workoutId,
            payload: jsonEncode(payload),
            updatedAt: _clock.nowUtc(),
          ),
        );
  }

  Future<Map<String, dynamic>?> read(String workoutId) async {
    final row = await (_db.select(
      _db.activeWorkoutDrafts,
    )..where((r) => r.workoutId.equals(workoutId))).getSingleOrNull();
    if (row == null) return null;
    return _decode(workoutId, row.payload);
  }

  Stream<Map<String, dynamic>?> watch(String workoutId) {
    return (_db.select(_db.activeWorkoutDrafts)
          ..where((r) => r.workoutId.equals(workoutId)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _decode(workoutId, row.payload));
  }

  Future<void> delete(String workoutId) {
    return (_db.delete(
      _db.activeWorkoutDrafts,
    )..where((r) => r.workoutId.equals(workoutId))).go();
  }

  Map<String, dynamic>? _decode(String workoutId, String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } on FormatException catch (error) {
      // Una bozza illeggibile non deve impedire di aprire l'allenamento: si
      // riparte dalla scheda, che è il dato autoritativo.
      _logger.warn(
        'Active workout draft is not readable JSON',
        context: {'workoutId': workoutId},
        error: error,
      );
      return null;
    }
  }
}

final activeWorkoutDraftDaoProvider = Provider<ActiveWorkoutDraftDao>((ref) {
  return ActiveWorkoutDraftDao(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
    ref.watch(appLoggerProvider),
  );
});
