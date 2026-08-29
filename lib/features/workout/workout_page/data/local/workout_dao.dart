import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/database/tables/user_tables.dart';
import 'package:coachly/features/workout/workout_page/data/models/structured_workout_snapshot_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'workout_dao.g.dart';

/// Accesso locale alle schede di allenamento.
///
/// Lo schema non rispecchia il backend: hanno una colonna solo i campi su cui
/// si filtra o si ordina, il resto vive nel blob `payload`
/// (`docs/development/04-data-layer.md`). Le letture sono stream Drift: una
/// scrittura aggiorna la UI perche' il database notifica, non perche' qualcuno
/// ha chiamato `invalidate`.
@DriftAccessor(tables: [Workouts, WorkoutSnapshots])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  /// Lettura reattiva: sostituisce le invalidazioni manuali dopo ogni scrittura.
  Stream<List<WorkoutModel>> watchWorkouts() {
    final query = select(workouts)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.lastUsed)]);
    return query.watch().map(
      (rows) => rows.map(_toModel).nonNulls.toList(growable: false),
    );
  }

  Future<List<WorkoutModel>> getWorkouts() async {
    final query = select(workouts)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.lastUsed)]);
    final rows = await query.get();
    return rows.map(_toModel).nonNulls.toList(growable: false);
  }

  Future<WorkoutModel?> getWorkout(String workoutId) async {
    final row = await (select(
      workouts,
    )..where((table) => table.id.equals(workoutId))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Future<List<WorkoutModel>> getDirtyWorkouts() async {
    final rows = await (select(
      workouts,
    )..where((row) => row.dirty.equals(true))).get();
    return rows.map(_toModel).nonNulls.toList(growable: false);
  }

  Future<int> countWorkouts() async {
    return (await getWorkouts()).length;
  }

  /// Scrive una scheda toccata dall'utente: resta `dirty` finche' non sale.
  Future<void> patchWorkout(WorkoutModel workout, {DateTime? updatedAt}) {
    return upsert(workout.copyWith(dirty: true), updatedAt: updatedAt);
  }

  Future<void> upsert(WorkoutModel workout, {DateTime? updatedAt}) {
    return into(
      workouts,
    ).insertOnConflictUpdate(_toCompanion(workout, updatedAt: updatedAt));
  }

  /// Applica una lista remota senza calpestare le modifiche locali non salite.
  ///
  /// Una scheda `dirty` vince sempre sul remoto: il client e' l'autore
  /// (`docs/development/05-sync-and-offline.md`).
  Future<void> patchWorkouts(
    List<WorkoutModel> incoming, {
    DateTime? updatedAt,
  }) async {
    await transaction(() async {
      final dirtyIds = (await getDirtyWorkouts())
          .map((workout) => workout.id)
          .toSet();
      final incomingIds = incoming.map((workout) => workout.id).toSet();

      final obsoleteIds = (await getWorkouts())
          .map((workout) => workout.id)
          .where((id) => !incomingIds.contains(id) && !dirtyIds.contains(id))
          .toList(growable: false);
      if (obsoleteIds.isNotEmpty) {
        await (delete(workouts)..where((row) => row.id.isIn(obsoleteIds))).go();
      }

      for (final workout in incoming) {
        if (dirtyIds.contains(workout.id) && !workout.dirty) {
          continue;
        }
        await upsert(workout, updatedAt: updatedAt);
      }
    });
  }

  Future<void> setActive(
    String workoutId, {
    required bool active,
    DateTime? updatedAt,
  }) async {
    final workout = await getWorkout(workoutId);
    if (workout == null) {
      return;
    }
    await patchWorkout(workout.copyWith(active: active), updatedAt: updatedAt);
  }

  Future<void> markSynced(String workoutId, {DateTime? updatedAt}) async {
    await (update(workouts)..where((row) => row.id.equals(workoutId))).write(
      WorkoutsCompanion(
        dirty: const Value(false),
        updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt),
      ),
    );
  }

  Future<void> deleteWorkout(String workoutId) async {
    await transaction(() async {
      await (delete(workouts)..where((row) => row.id.equals(workoutId))).go();
      await deleteSnapshot(workoutId);
    });
  }

  // --- Snapshot del comando strutturato -------------------------------------

  Future<StructuredWorkoutSnapshot?> getSnapshot(String workoutId) async {
    final row = await (select(
      workoutSnapshots,
    )..where((table) => table.workoutId.equals(workoutId))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return StructuredWorkoutSnapshot(
      workoutId: row.workoutId,
      workoutWriteCommandJson: row.commandJson,
      sourceUpdatedAt: row.sourceUpdatedAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<void> saveSnapshot(StructuredWorkoutSnapshot snapshot) {
    return into(workoutSnapshots).insertOnConflictUpdate(
      WorkoutSnapshotsCompanion.insert(
        workoutId: snapshot.workoutId,
        commandJson: snapshot.workoutWriteCommandJson,
        sourceUpdatedAt: snapshot.sourceUpdatedAt ?? snapshot.updatedAt,
        updatedAt: snapshot.updatedAt,
      ),
    );
  }

  Future<void> deleteSnapshot(String workoutId) {
    return (delete(
      workoutSnapshots,
    )..where((row) => row.workoutId.equals(workoutId))).go();
  }

  // --- Mapping --------------------------------------------------------------

  WorkoutsCompanion _toCompanion(WorkoutModel workout, {DateTime? updatedAt}) {
    return WorkoutsCompanion.insert(
      id: workout.id,
      origin: const Value('user'),
      goal: Value(workout.goal),
      durationMinutes: Value(workout.durationMinutes),
      sessionsCount: Value(workout.sessionsCount),
      progress: Value(workout.progress),
      active: Value(workout.active),
      dirty: Value(workout.dirty),
      payload: Value(jsonEncode(workout.toJson())),
      lastUsed: workout.lastUsed,
      updatedAt: updatedAt ?? workout.lastUsed,
      deletedAt: workout.delete
          ? Value(updatedAt ?? workout.lastUsed)
          : const Value(null),
    );
  }

  /// Le colonne sono l'autorita' su cio' che hanno: il payload riempie il resto.
  WorkoutModel? _toModel(WorkoutRow row) {
    final payload = row.payload;
    if (payload == null) {
      return null;
    }
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      return null;
    }
    final model = WorkoutModel.fromJsonSafe(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
    return model.copyWith(
      id: row.id,
      goal: row.goal ?? model.goal,
      durationMinutes: row.durationMinutes,
      sessionsCount: row.sessionsCount,
      progress: row.progress,
      active: row.active,
      dirty: row.dirty,
      delete: row.deletedAt != null,
      lastUsed: row.lastUsed,
    );
  }
}

/// `keepAlive`: il DAO vive quanto il database.
final workoutDaoProvider = Provider<WorkoutDao>(
  (ref) => WorkoutDao(ref.watch(appDatabaseProvider)),
);
