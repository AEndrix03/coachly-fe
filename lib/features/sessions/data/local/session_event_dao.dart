import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/database/tables/user_tables.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'session_event_dao.g.dart';

/// Accesso all'event log delle sessioni.
///
/// La tabella e' append-only: qui non esiste nessun metodo che aggiorna il
/// contenuto di un evento o che ne cancella uno. L'unica colonna che cambia
/// dopo la scrittura e' `syncedAt`, che non e' un dato dell'evento ma lo stato
/// del suo trasporto.
@DriftAccessor(tables: [SessionEvents])
class SessionEventDao extends DatabaseAccessor<AppDatabase>
    with _$SessionEventDaoMixin {
  SessionEventDao(super.db);

  /// Registra un evento.
  ///
  /// Il `seq` lo assegna il chiamante, non il database: e' l'ordine dei fatti
  /// come li ha visti il dispositivo, e deve restare stabile anche se la riga
  /// viene scritta due volte. `insertOnConflictUpdate` sulla chiave rende la
  /// scrittura ripetibile senza duplicare.
  Future<void> append({
    required String id,
    required String sessionId,
    required int seq,
    required DateTime occurredAt,
    required String type,
    String payload = '{}',
  }) async {
    await into(sessionEvents).insertOnConflictUpdate(
      SessionEventsCompanion.insert(
        id: id,
        sessionId: sessionId,
        seq: seq,
        occurredAt: occurredAt,
        type: type,
        payload: Value(payload),
      ),
    );
  }

  /// Il prossimo `seq` libero per una sessione.
  ///
  /// Si legge dal database e non da un contatore in memoria: l'app puo' essere
  /// chiusa e riaperta a meta' allenamento, e un contatore ripartito da zero
  /// farebbe collidere gli eventi con quelli gia' scritti.
  Future<int> nextSeq(String sessionId) async {
    final maxSeq = sessionEvents.seq.max();
    final query = selectOnly(sessionEvents)
      ..addColumns([maxSeq])
      ..where(sessionEvents.sessionId.equals(sessionId));
    final row = await query.getSingle();
    return (row.read(maxSeq) ?? -1) + 1;
  }

  /// Gli eventi non ancora confermati dal backend, in ordine.
  ///
  /// [limit] riflette il tetto del batch dichiarato in
  /// `docs/development/05-sync-and-offline.md`.
  Future<List<SessionEventRow>> pending({int limit = 500}) {
    return (select(sessionEvents)
          ..where((row) => row.syncedAt.isNull())
          ..orderBy([
            (row) => OrderingTerm.asc(row.sessionId),
            (row) => OrderingTerm.asc(row.seq),
          ])
          ..limit(limit))
        .get();
  }

  /// Marca come sincronizzati gli eventi confermati dal backend.
  Future<void> markSynced(List<String> ids, {required DateTime syncedAt}) async {
    if (ids.isEmpty) return;
    await (update(sessionEvents)..where((row) => row.id.isIn(ids))).write(
      SessionEventsCompanion(syncedAt: Value(syncedAt)),
    );
  }

  /// Gli eventi di una sessione, in ordine. Lo stato corrente della sessione
  /// e' una proiezione di questa sequenza.
  Future<List<SessionEventRow>> forSession(String sessionId) {
    return (select(sessionEvents)
          ..where((row) => row.sessionId.equals(sessionId))
          ..orderBy([(row) => OrderingTerm.asc(row.seq)]))
        .get();
  }
}

/// `keepAlive`: il DAO vive quanto il database.
final sessionEventDaoProvider = Provider<SessionEventDao>(
  (ref) => SessionEventDao(ref.watch(appDatabaseProvider)),
);
