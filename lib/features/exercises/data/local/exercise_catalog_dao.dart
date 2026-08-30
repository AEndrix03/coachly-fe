import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/database/tables/catalog_tables.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercises/data/local/exercise_catalog_query.dart';
import 'package:coachly/features/exercises/data/mappers/exercise_catalog_mappers.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/exercises/domain/models/exercise_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'exercise_catalog_dao.g.dart';

/// Accesso locale al catalogo esercizi.
///
/// Non esce da `data/local/`: il repository è l'unico punto di ingresso
/// (`docs/development/04-data-layer.md`, regola 1).
///
/// Due scelte che vale la pena rileggere fra sei mesi:
///
/// 1. **Le letture sono stream.** Una scrittura aggiorna la lista perché
///    SQLite notifica la tabella, non perché qualcuno ha chiamato
///    `ref.invalidate` (regola 4).
/// 2. **Il filtro è una `WHERE`.** Muscoli e attrezzi passano da una subquery
///    sulle tabelle ponte. Filtrare in Dart significherebbe deserializzare
///    l'intero catalogo a ogni battuta sulla barra di ricerca.
@DriftAccessor(
  tables: [
    CatalogExercises,
    LocalizedTexts,
    ExerciseMuscles,
    ExerciseEquipments,
    ExerciseCategories,
  ],
)
class ExerciseCatalogDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseCatalogDaoMixin {
  ExerciseCatalogDao(super.db, this._clock);

  final Clock _clock;

  // ── Letture ───────────────────────────────────────────────────────────────

  /// I riepiloghi che soddisfano [query], ricalcolati a ogni scrittura.
  Stream<List<ExerciseModel>> watchSummaries([
    ExerciseCatalogQuery query = const ExerciseCatalogQuery(),
  ]) => _summariesQuery(query).watch().map(_groupSummaries);

  /// Lettura una tantum, per i chiamanti non ancora reattivi.
  Future<List<ExerciseModel>> getSummaries([
    ExerciseCatalogQuery query = const ExerciseCatalogQuery(),
  ]) => _summariesQuery(query).get().then(_groupSummaries);

  /// Il dettaglio completo, decodificato dal blob `payload`.
  ///
  /// `null` quando non è ancora stato scaricato: i dettagli restano pigri, uno
  /// esercizio alla volta.
  Future<ExerciseDetailModel?> getDetail(String exerciseId) async {
    final row = await (select(
      catalogExercises,
    )..where((table) => table.id.equals(exerciseId))).getSingleOrNull();
    return row == null ? null : rowToDetail(row);
  }

  /// I dettagli effettivamente scaricati.
  ///
  /// Solo le righe con `payload` valorizzato: i dettagli restano pigri, uno
  /// esercizio per volta, quindi il catalogo contiene molti riepiloghi e pochi
  /// dettagli (`docs/development/04-data-layer.md`).
  Future<List<ExerciseDetailModel>> getAllDetails() async {
    final rows = await (select(
      catalogExercises,
    )..where((table) => table.payload.isNotNull())).get();
    return rows.map(rowToDetail).whereType<ExerciseDetailModel>().toList();
  }

  /// Il catalogo non è ancora stato popolato.
  Future<bool> isEmpty() async {
    final count = countAll();
    final row = await (selectOnly(
      catalogExercises,
    )..addColumns([count])).getSingle();
    return (row.read(count) ?? 0) == 0;
  }

  // ── Scritture ─────────────────────────────────────────────────────────────

  /// Sostituisce l'elenco del catalogo con [exercises].
  ///
  /// Gli esercizi spariti dal backend vengono rimossi, quelli sopravvissuti
  /// **conservano il dettaglio già scaricato**: il companion di riepilogo non
  /// contiene `payload`, quindi l'`UPDATE` non lo tocca.
  Future<void> upsertSummaries(List<ExerciseModel> exercises) async {
    final now = _clock.nowUtc();
    final valid = exercises
        .where((exercise) => (exercise.id ?? '').isNotEmpty)
        .toList(growable: false);
    final keptIds = valid.map((exercise) => exercise.id!).toList();

    await transaction(() async {
      await (delete(
        catalogExercises,
      )..where((table) => table.id.isNotIn(keptIds))).go();

      await batch((batch) {
        for (final exercise in valid) {
          final row = summaryToRow(exercise, updatedAt: now);
          batch.insert(
            catalogExercises,
            row,
            onConflict: DoUpdate((_) => row, target: [catalogExercises.id]),
          );
          batch.insertAllOnConflictUpdate(
            localizedTexts,
            localizedTextRows(
              exerciseId: exercise.id!,
              nameI18n: exercise.nameI18n,
              descriptionI18n: exercise.descriptionI18n,
              tipsI18n: exercise.tipsI18n,
            ),
          );
        }
      });
    });
  }

  /// Salva un dettaglio completo: colonne filtrabili, blob, testi e ponti.
  ///
  /// Tutto in una transazione: una riga di catalogo senza i suoi muscoli è
  /// esattamente l'incoerenza che faceva sparire gli esercizi dai filtri.
  Future<void> upsertDetail(ExerciseDetailModel exercise) async {
    final exerciseId = exercise.id;
    if (exerciseId == null || exerciseId.isEmpty) return;

    final now = _clock.nowUtc();
    final muscles = muscleRows(exercise);
    final equipments = equipmentRows(exercise);
    final categories = categoryRows(exercise);

    await transaction(() async {
      await into(
        catalogExercises,
      ).insertOnConflictUpdate(detailToRow(exercise, updatedAt: now));

      await (delete(
        exerciseMuscles,
      )..where((table) => table.exerciseId.equals(exerciseId))).go();
      await (delete(
        exerciseEquipments,
      )..where((table) => table.exerciseId.equals(exerciseId))).go();
      await (delete(
        exerciseCategories,
      )..where((table) => table.exerciseId.equals(exerciseId))).go();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          localizedTexts,
          localizedTextRows(
            exerciseId: exerciseId,
            nameI18n: exercise.nameI18n,
            descriptionI18n: exercise.descriptionI18n,
            tipsI18n: exercise.tipsI18n,
          ),
        );
        batch.insertAll(exerciseMuscles, muscles);
        batch.insertAll(exerciseEquipments, equipments);
        batch.insertAll(exerciseCategories, categories);
      });
    });
  }

  // ── Interni ───────────────────────────────────────────────────────────────

  /// La `SELECT` con i join: una riga per esercizio **per lingua**, poi
  /// raggruppata. Il join sui nomi è `LEFT`, così un esercizio senza testi
  /// tradotti resta visibile invece di sparire in silenzio.
  JoinedSelectStatement<HasResultSet, dynamic> _summariesQuery(
    ExerciseCatalogQuery query,
  ) {
    final statement = select(catalogExercises).join([
      leftOuterJoin(
        _names,
        _names.entityId.equalsExp(catalogExercises.id) &
            _names.entityType.equals(catalogExerciseEntityType) &
            _names.field.equals(localizedNameField),
      ),
    ]);

    for (final condition in _conditions(query)) {
      statement.where(condition);
    }
    statement.orderBy([OrderingTerm.asc(catalogExercises.id)]);
    return statement;
  }

  late final $LocalizedTextsTable _names = alias(
    localizedTexts,
    'exercise_names',
  );

  List<Expression<bool>> _conditions(ExerciseCatalogQuery query) {
    final conditions = <Expression<bool>>[];

    final difficultyLevel = query.difficultyLevel;
    if (difficultyLevel != null && difficultyLevel.isNotEmpty) {
      conditions.add(catalogExercises.difficultyLevel.equals(difficultyLevel));
    }

    final mechanicsType = query.mechanicsType;
    if (mechanicsType != null && mechanicsType.isNotEmpty) {
      conditions.add(catalogExercises.mechanicsType.equals(mechanicsType));
    }

    final forceType = query.forceType;
    if (forceType != null && forceType.isNotEmpty) {
      conditions.add(catalogExercises.forceType.equals(forceType));
    }

    final isUnilateral = query.isUnilateral;
    if (isUnilateral != null) {
      conditions.add(catalogExercises.unilateral.equals(isUnilateral));
    }

    final isBodyweight = query.isBodyweight;
    if (isBodyweight != null) {
      conditions.add(catalogExercises.bodyweight.equals(isBodyweight));
    }

    if (query.excludedExerciseIds.isNotEmpty) {
      conditions.add(
        catalogExercises.id.isNotIn(query.excludedExerciseIds.toList()),
      );
    }

    // `mine` chiede gli esercizi dell'utente, che non stanno nel catalogo ma
    // in `CustomExercises`: qui non c'è nulla da restituire.
    if (query.scope?.toLowerCase() == 'mine') {
      conditions.add(const Constant(false));
    }

    final text = query.textFilter?.trim().toLowerCase();
    if (text != null && text.isNotEmpty) {
      final matches = selectOnly(localizedTexts)
        ..addColumns([localizedTexts.entityId])
        ..where(
          localizedTexts.entityType.equals(catalogExerciseEntityType) &
              localizedTexts.field.equals(localizedNameField) &
              localizedTexts.value.lower().like('%$text%'),
        );
      conditions.add(catalogExercises.id.isInQuery(matches));
    }

    if (query.muscleIds.isNotEmpty) {
      final matches = selectOnly(exerciseMuscles)
        ..addColumns([exerciseMuscles.exerciseId])
        ..where(exerciseMuscles.muscleId.isIn(query.muscleIds));
      conditions.add(catalogExercises.id.isInQuery(matches));
    }

    if (query.equipmentIds.isNotEmpty) {
      final matches = selectOnly(exerciseEquipments)
        ..addColumns([exerciseEquipments.exerciseId])
        ..where(exerciseEquipments.equipmentId.isIn(query.equipmentIds));
      conditions.add(catalogExercises.id.isInQuery(matches));
    }

    if (query.categoryIds.isNotEmpty) {
      final matches = selectOnly(exerciseCategories)
        ..addColumns([exerciseCategories.exerciseId])
        ..where(exerciseCategories.categoryId.isIn(query.categoryIds));
      conditions.add(catalogExercises.id.isInQuery(matches));
    }

    return conditions;
  }

  /// Le righe del join tornano moltiplicate per lingua: qui si ricompone la
  /// mappa `nameI18n` senza perdere l'ordinamento della query.
  List<ExerciseModel> _groupSummaries(List<TypedResult> rows) {
    final byId = <String, CatalogExerciseRow>{};
    final localized = <String, Map<String, String>>{};

    for (final row in rows) {
      final exercise = row.readTable(catalogExercises);
      byId[exercise.id] = exercise;
      final name = row.readTableOrNull(_names);
      if (name != null) {
        (localized[exercise.id] ??= {})[name.locale] = name.value;
      }
    }

    return [
      for (final exercise in byId.values)
        rowToSummary(exercise, nameI18n: localized[exercise.id]),
    ];
  }
}

/// `keepAlive` per costruzione: un `Provider` non generato in Riverpod 3 non
/// viene smaltito, e il DAO non ha stato da liberare.
final exerciseCatalogDaoProvider = Provider<ExerciseCatalogDao>((ref) {
  return ExerciseCatalogDao(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  );
});
