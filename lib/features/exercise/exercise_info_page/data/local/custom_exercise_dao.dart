import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/database/tables/catalog_tables.dart';
import 'package:coachly/core/database/tables/user_tables.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/mappers/exercise_catalog_mappers.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'custom_exercise_dao.g.dart';

/// Accesso locale agli esercizi creati dall'utente.
///
/// Tabella separata dal catalogo, non un flag `isPersonal` su una riga sola: il
/// catalogo viene sostituito in blocco dai delta, questi **no**. Sono dati
/// utente, e perderli è una perdita irreversibile
/// (`docs/development/04-data-layer.md`).
///
/// Conseguenza: l'elenco che l'utente vede come "i miei esercizi" è l'unione di
/// due letture, e la fa il repository — non il DAO.
@DriftAccessor(tables: [CustomExercises, LocalizedTexts])
class CustomExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$CustomExerciseDaoMixin {
  CustomExerciseDao(super.db, this._clock, this._logger);

  final Clock _clock;
  final AppLogger _logger;

  static const _entityType = 'custom_exercise';

  /// I riepiloghi degli esercizi personali, ricalcolati a ogni scrittura.
  Stream<List<ExerciseModel>> watchSummaries() =>
      _liveQuery().watch().asyncMap(_toSummaries);

  Future<List<ExerciseModel>> getSummaries() =>
      _liveQuery().get().then(_toSummaries);

  Future<ExerciseDetailModel?> getDetail(String id) async {
    final row = await (select(
      customExercises,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    final payload = row?.payload;
    if (payload == null) return null;
    try {
      return ExerciseDetailModel.fromJson(
        jsonDecode(payload) as Map<String, dynamic>,
      );
    } catch (error) {
      _logger.warn(
        'Payload di esercizio personale illeggibile',
        context: {'id': id},
        error: error,
      );
      return null;
    }
  }

  Future<void> upsert(ExerciseDetailModel exercise) async {
    final id = exercise.id;
    if (id == null || id.isEmpty) return;

    final now = _clock.nowUtc();
    await transaction(() async {
      await into(customExercises).insertOnConflictUpdate(
        CustomExercisesCompanion.insert(
          id: id,
          difficultyLevel: Value(exercise.difficultyLevel),
          mechanicsType: Value(exercise.mechanicsType),
          forceType: Value(exercise.forceType),
          unilateral: Value(exercise.isUnilateral ?? false),
          bodyweight: Value(exercise.isBodyweight ?? false),
          payload: Value(jsonEncode(exercise.toJson())),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          localizedTexts,
          localizedTextRows(
            exerciseId: id,
            nameI18n: exercise.nameI18n,
            descriptionI18n: exercise.descriptionI18n,
            tipsI18n: exercise.tipsI18n,
            entityType: _entityType,
          ),
        );
      });
    });
  }

  /// Soft delete: la riga resta finché la cancellazione non è salita.
  Future<void> markDeleted(String id) =>
      (update(customExercises)..where((table) => table.id.equals(id))).write(
        CustomExercisesCompanion(
          deletedAt: Value(_clock.nowUtc()),
          updatedAt: Value(_clock.nowUtc()),
        ),
      );

  Future<void> replaceAll(List<ExerciseDetailModel> exercises) async {
    await transaction(() async {
      await delete(customExercises).go();
      for (final exercise in exercises) {
        await upsert(exercise);
      }
    });
  }

  JoinedSelectStatement<HasResultSet, dynamic> _liveQuery() {
    final names = alias(localizedTexts, 'custom_exercise_names');
    return (select(customExercises)
          ..where((table) => table.deletedAt.isNull())
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .join([
          leftOuterJoin(
            names,
            names.entityId.equalsExp(customExercises.id) &
                names.entityType.equals(_entityType) &
                names.field.equals(localizedNameField),
          ),
        ]);
  }

  Future<List<ExerciseModel>> _toSummaries(List<TypedResult> rows) async {
    final byId = <String, ExerciseModel>{};
    final names = <String, Map<String, String>>{};

    for (final row in rows) {
      final exercise = row.readTable(customExercises);
      final text = row.readTableOrNull(
        alias(localizedTexts, 'custom_exercise_names'),
      );
      if (text != null) {
        (names[exercise.id] ??= {})[text.locale] = text.value;
      }
      byId[exercise.id] = ExerciseModel(
        id: exercise.id,
        // È l'unico posto in cui `isPersonal` è vero: nel catalogo è sempre
        // falso, perché lì gli esercizi dell'utente non ci sono.
        isPersonal: true,
        difficultyLevel: exercise.difficultyLevel,
        mechanicsType: exercise.mechanicsType,
        forceType: exercise.forceType,
        isUnilateral: exercise.unilateral,
        isBodyweight: exercise.bodyweight,
        nameI18n: names[exercise.id],
      );
    }

    return byId.entries
        .map((entry) => entry.value.copyWith(nameI18n: names[entry.key]))
        .toList(growable: false);
  }
}

final customExerciseDaoProvider = Provider<CustomExerciseDao>(
  (ref) => CustomExerciseDao(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
    ref.watch(appLoggerProvider),
  ),
);
