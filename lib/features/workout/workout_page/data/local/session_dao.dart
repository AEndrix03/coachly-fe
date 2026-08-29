import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/database/tables/user_tables.dart';
import 'package:coachly/features/workout/workout_page/data/models/local_workout_session_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'session_dao.g.dart';

/// Accesso locale alle sessioni di allenamento.
///
/// Le sessioni sono il prodotto della app: nascono sul dispositivo, spesso
/// offline, e non si perdono mai per colpa della sync
/// (`docs/development/05-sync-and-offline.md`).
@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Stream<List<LocalWorkoutSession>> watchSessions() {
    final query = select(sessions)
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    return query.watch().map(
      (rows) => rows.map(_toModel).nonNulls.toList(growable: false),
    );
  }

  Stream<List<LocalWorkoutSession>> watchSessionsForWorkout(String workoutId) {
    final query = select(sessions)
      ..where((row) => row.workoutId.equals(workoutId))
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    return query.watch().map(
      (rows) => rows.map(_toModel).nonNulls.toList(growable: false),
    );
  }

  Future<List<LocalWorkoutSession>> getAllSessions() async {
    final query = select(sessions)
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    final rows = await query.get();
    return rows.map(_toModel).nonNulls.toList(growable: false);
  }

  Future<List<LocalWorkoutSession>> getSessionsForWorkout(
    String workoutId,
  ) async {
    final query = select(sessions)
      ..where((row) => row.workoutId.equals(workoutId))
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    final rows = await query.get();
    return rows.map(_toModel).nonNulls.toList(growable: false);
  }

  Future<LocalWorkoutSession?> getSession(String localSessionId) async {
    final row = await (select(
      sessions,
    )..where((table) => table.id.equals(localSessionId))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Future<void> upsert(LocalWorkoutSession session) {
    return into(sessions).insertOnConflictUpdate(_toCompanion(session));
  }

  /// Aggiorna lo stato di sync **senza mai toccare il dato dell'utente**.
  Future<void> updateSyncState(
    String localSessionId,
    LocalWorkoutSessionSyncState state, {
    required DateTime updatedAt,
  }) async {
    final session = await getSession(localSessionId);
    if (session == null) {
      return;
    }
    await upsert(session.copyWith(syncState: state, updatedAt: updatedAt));
  }

  SessionsCompanion _toCompanion(LocalWorkoutSession session) {
    return SessionsCompanion.insert(
      id: session.localSessionId,
      workoutId: session.workoutId,
      status: Value(session.syncState.value),
      payload: Value(jsonEncode(session.toJson())),
      startedAt: Value(session.startedAt),
      completedAt: Value(session.completedAt),
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
    );
  }

  LocalWorkoutSession? _toModel(SessionRow row) {
    final payload = row.payload;
    if (payload == null) {
      return null;
    }
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      return null;
    }
    final session = LocalWorkoutSession.fromJson(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
    return session.copyWith(
      localSessionId: row.id,
      workoutId: row.workoutId,
      syncState: LocalWorkoutSessionSyncState.fromValue(row.status),
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

/// `keepAlive`: il DAO vive quanto il database.
final sessionDaoProvider = Provider<SessionDao>(
  (ref) => SessionDao(ref.watch(appDatabaseProvider)),
);
