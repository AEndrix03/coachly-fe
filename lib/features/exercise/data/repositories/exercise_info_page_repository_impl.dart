import 'dart:async';
import 'dart:convert';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart'
    show exerciseInfoPageServiceProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/ids/id_generator.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercise/data/local/custom_exercise_dao.dart';
import 'package:coachly/features/exercise/data/local/exercise_catalog_dao.dart';
import 'package:coachly/features/exercise/data/local/exercise_catalog_query.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/data/services/exercise_info_page_service.dart';
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/features/sessions/data/services/workout_session_sync_service.dart';

/// Implementazione di riferimento della migrazione a `Result<T, Failure>`.
///
/// Regola che governa il file: nessuna eccezione esce da un metodo pubblico.
/// Ogni accesso a rete o database viene racchiuso e convertito in `Failure`
/// qui, dove ci sono le informazioni per farlo
/// (`docs/development/07-errors-and-feedback.md`).
///
/// La cache non è più un box Hive ma il catalogo Drift. Il cambio non è
/// cosmetico: la vecchia cache persisteva tre campi mentre il filtro ne
/// interrogava nove, quindi con la cache attiva qualsiasi filtro diverso dal
/// testo restituiva zero risultati. Ora i campi filtrabili sono colonne e la
/// selezione è una `WHERE`: l'incoerenza non è più esprimibile
/// (`docs/development/04-data-layer.md`).
class ExerciseInfoPageRepositoryImpl implements IExerciseInfoPageRepository {
  final ExerciseInfoPageService _service;
  final ExerciseCatalogDao _catalog;
  final CustomExerciseDao _customExercises;
  final OutboxDao? _outbox;
  final AppDatabase? _database;
  final IdGenerator? _ids;
  final WorkoutSessionSyncService? _syncService;

  ExerciseInfoPageRepositoryImpl(
    this._service,
    this._catalog,
    this._customExercises, {
    OutboxDao? outbox,
    AppDatabase? database,
    IdGenerator? ids,
    WorkoutSessionSyncService? syncService,
  }) : _outbox = outbox,
       _database = database,
       _ids = ids,
       _syncService = syncService;

  @override
  Future<List<ExerciseDetailModel>> getDownloadedDetails() =>
      _catalog.getAllDetails();

  @override
  Future<ExerciseDetailModel?> getCachedDetail(String exerciseId) =>
      _catalog.getDetail(exerciseId);

  // API definitiva ───────────────────────────────────────────────────────────

  @override
  /// La deduplica delle richieste concorrenti non vive più qui: sta nel
  /// `RequestCoalescer` di `ApiClient` (`docs/development/06-networking.md`).
  Future<Result<ExerciseDetailModel, Failure>> getExerciseDetailResult(
    String exerciseId,
  ) async {
    try {
      final cached = await _catalog.getDetail(exerciseId);
      if (cached != null) return Ok(cached);

      final remote = (await _service.fetchExerciseDetails(
        exerciseId,
      )).toResult();
      if (remote case Ok(:final value)) {
        await _catalog.upsertDetail(value);
      }
      return remote;
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Stream<List<ExerciseModel>> watchExerciseSummaries(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) => _catalog.watchSummaries(
    toCatalogQuery(filter, excludedExerciseIds: excludedExerciseIds),
  );

  @override
  Future<Result<List<ExerciseModel>, Failure>> getAllExercisesResult() =>
      getExerciseSummariesResult();

  @override
  Future<Result<List<ExerciseModel>, Failure>>
  getExerciseSummariesResult() async {
    try {
      final prepared = await _ensureLocalCache();
      if (prepared case Err(:final failure)) return Err(failure);
      return Ok(await _catalog.getSummaries());
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ExerciseDetailModel>, Failure>> getFilteredExercisesResult(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    try {
      final prepared = await _ensureLocalCache();
      if (prepared case Err(:final failure)) return Err(failure);

      final summaries = await _catalog.getSummaries(
        toCatalogQuery(filter, excludedExerciseIds: excludedExerciseIds),
      );

      // I dettagli restano pigri: si restituisce solo ciò che è già stato
      // scaricato, non si scatenano N richieste per riempire una lista.
      final details = <ExerciseDetailModel>[];
      for (final summary in summaries) {
        final id = summary.id;
        if (id == null || id.isEmpty) continue;
        final detail = await _catalog.getDetail(id);
        if (detail != null) details.add(detail);
      }
      return Ok(details);
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ExerciseModel>, Failure>>
  getFilteredExerciseSummariesResult(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    try {
      final prepared = await _ensureLocalCache();
      if (prepared case Err(:final failure)) return Err(failure);
      return Ok(
        await _summariesForScope(
          filter,
          excludedExerciseIds: excludedExerciseIds,
        ),
      );
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ExerciseModel>, Failure>> getMyExercisesResult() async {
    try {
      return Ok(await _customExercises.getSummaries());
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  Future<void> _refreshCustomExercises() async {
    final remote = (await _service.fetchMyExercises()).toResult();
    if (remote case Ok(:final value)) {
      final details = <ExerciseDetailModel>[];
      for (final summary in value) {
        final id = summary.id;
        if (id == null || id.isEmpty) continue;
        final detail = (await _service.fetchExerciseDetails(id)).toResult();
        if (detail case Ok(:final value)) details.add(value);
      }
      for (final detail in details) {
        final id = detail.id;
        if (id != null &&
            await _outbox?.hasPendingForEntity(
                  entityType: 'custom_exercise',
                  entityId: id,
                ) ==
                true) {
          continue;
        }
        await _customExercises.upsert(detail);
      }
    }
  }

  /// L'elenco che l'utente vede è l'unione di due tabelle.
  ///
  /// Catalogo ed esercizi personali sono separati per una ragione di
  /// persistenza — il primo si sostituisce in blocco, il secondo no
  /// (`docs/development/04-data-layer.md`) — ma per chi guarda lo schermo sono
  /// una lista sola. La ricomposizione è compito del repository.
  Future<List<ExerciseModel>> _summariesForScope(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    final scope = filter.scope;
    final query = toCatalogQuery(
      filter,
      excludedExerciseIds: excludedExerciseIds,
    );

    if (scope == 'mine') {
      return _filterCustom(
        await _customExercises.getSummaries(),
        filter,
        excludedExerciseIds,
      );
    }

    final catalog = await _catalog.getSummaries(query);
    if (scope == 'default') return catalog;

    return [
      ...catalog,
      ..._filterCustom(
        await _customExercises.getSummaries(),
        filter,
        excludedExerciseIds,
      ),
    ];
  }

  /// I personali sono pochi: il filtro in memoria è accettabile qui, mentre sul
  /// catalogo sarebbe la scansione che lo schema Drift esiste per evitare.
  List<ExerciseModel> _filterCustom(
    List<ExerciseModel> exercises,
    ExerciseFilterModel filter,
    Set<String> excludedExerciseIds,
  ) {
    final text = filter.textFilter?.trim().toLowerCase();
    return exercises
        .where((exercise) {
          final id = exercise.id;
          if (id == null || excludedExerciseIds.contains(id)) return false;
          if (filter.difficultyLevel != null &&
              exercise.difficultyLevel != filter.difficultyLevel) {
            return false;
          }
          if (filter.mechanicsType != null &&
              exercise.mechanicsType != filter.mechanicsType) {
            return false;
          }
          if (filter.forceType != null &&
              exercise.forceType != filter.forceType) {
            return false;
          }
          if (filter.isUnilateral != null &&
              exercise.isUnilateral != filter.isUnilateral) {
            return false;
          }
          if (filter.isBodyweight != null &&
              exercise.isBodyweight != filter.isBodyweight) {
            return false;
          }
          if (text != null && text.isNotEmpty) {
            final names = exercise.nameI18n?.values ?? const <String>[];
            if (!names.any((name) => name.toLowerCase().contains(text))) {
              return false;
            }
          }
          return true;
        })
        .toList(growable: false);
  }

  @override
  Future<Result<ExerciseDetailModel, Failure>> createPersonalExerciseResult({
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  }) async {
    try {
      final ids = _ids!;
      final database = _database!;
      final outbox = _outbox!;
      final id = ids.newId();
      final body = <String, dynamic>{
        'id': id,
        'nameI18n': nameI18n,
        'descriptionI18n': descriptionI18n,
        'tipsI18n': tipsI18n,
        'difficultyLevel': difficultyLevel,
        'mechanicsType': mechanicsType,
        'forceType': forceType,
        'isUnilateral': isUnilateral,
        'isBodyweight': isBodyweight,
      };
      final local = ExerciseDetailModel(
        id: id,
        isPersonal: true,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
        tipsI18n: tipsI18n,
        difficultyLevel: difficultyLevel,
        mechanicsType: mechanicsType,
        forceType: forceType,
        isUnilateral: isUnilateral,
        isBodyweight: isBodyweight,
      );
      await database.transaction(() async {
        await _customExercises.upsert(local);
        await outbox.enqueue(
          id: ids.newIdempotencyKey(),
          entityType: 'custom_exercise',
          entityId: id,
          operation: 'create',
          payload: jsonEncode(body),
        );
      });
      final syncService = _syncService;
      if (syncService != null) {
        unawaited(syncService.syncPendingSessions(trigger: 'create_exercise'));
      }
      return Ok(local);
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<ExerciseDetailModel, Failure>> updatePersonalExerciseResult(
    String exerciseId, {
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  }) async {
    try {
      final ids = _ids!;
      final database = _database!;
      final outbox = _outbox!;
      final body = <String, dynamic>{
        'nameI18n': nameI18n,
        'descriptionI18n': descriptionI18n,
        'tipsI18n': tipsI18n,
        'difficultyLevel': difficultyLevel,
        'mechanicsType': mechanicsType,
        'forceType': forceType,
        'isUnilateral': isUnilateral,
        'isBodyweight': isBodyweight,
      };
      final current = await _customExercises.getDetail(exerciseId);
      final local = (current ?? ExerciseDetailModel(id: exerciseId)).copyWith(
        isPersonal: true,
        nameI18n: nameI18n,
        descriptionI18n: descriptionI18n,
        tipsI18n: tipsI18n,
        difficultyLevel: difficultyLevel,
        mechanicsType: mechanicsType,
        forceType: forceType,
        isUnilateral: isUnilateral,
        isBodyweight: isBodyweight,
      );
      await database.transaction(() async {
        await _customExercises.upsert(local);
        await outbox.enqueue(
          id: ids.newIdempotencyKey(),
          entityType: 'custom_exercise',
          entityId: exerciseId,
          operation: 'update',
          payload: jsonEncode(body),
        );
      });
      final syncService = _syncService;
      if (syncService != null) {
        unawaited(syncService.syncPendingSessions(trigger: 'update_exercise'));
      }
      return Ok(local);
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> deletePersonalExerciseResult(
    String exerciseId,
  ) async {
    try {
      final ids = _ids!;
      final database = _database!;
      final outbox = _outbox!;
      await database.transaction(() async {
        await _customExercises.markDeleted(exerciseId);
        await outbox.enqueue(
          id: ids.newIdempotencyKey(),
          entityType: 'custom_exercise',
          entityId: exerciseId,
          operation: 'delete',
          payload: '{}',
        );
      });
      final syncService = _syncService;
      if (syncService != null) {
        unawaited(syncService.syncPendingSessions(trigger: 'delete_exercise'));
      }
      return const Ok(null);
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ExerciseDetailModel>, Failure>>
  refreshFromRemoteResult() async {
    try {
      final summaries = (await _service.fetchAllExercises()).toResult();
      switch (summaries) {
        case Err(:final failure):
          return Err(failure);
        case Ok(:final value):
          await _catalog.upsertSummaries(value);
          await _refreshCustomExercises();
          // I dettagli restano volutamente pigri, uno esercizio alla volta.
          return const Ok([]);
      }
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  // Interni ──────────────────────────────────────────────────────────────────

  /// Popola la cache locale quando è vuota.
  ///
  /// Ritorna un `Result` invece di lanciare: il fallimento del riempimento è
  /// il fallimento della lettura che lo ha richiesto.
  Future<Result<void, Failure>> _ensureLocalCache() async {
    // Le letture non aprono mai una richiesta HTTP. Il bootstrap applicativo
    // aggiorna il catalogo esplicitamente; nel frattempo una cache vuota e'
    // uno stato locale valido, non un motivo per bloccare la UI sulla rete.
    return const Ok(null);
  }
}

/// Il filtro della presentazione → i criteri che lo schema locale sa esprimere.
///
/// Vive qui e non in `data/local/`: il DAO non deve conoscere
/// `ExerciseFilterModel`, che porta con sé `langFilter`, cioè un parametro di
/// query del backend.
ExerciseCatalogQuery toCatalogQuery(
  ExerciseFilterModel filter, {
  Set<String> excludedExerciseIds = const {},
}) {
  return ExerciseCatalogQuery(
    textFilter: filter.textFilter,
    scope: filter.scope,
    difficultyLevel: filter.difficultyLevel,
    mechanicsType: filter.mechanicsType,
    forceType: filter.forceType,
    isUnilateral: filter.isUnilateral,
    isBodyweight: filter.isBodyweight,
    muscleIds: filter.muscleIds ?? const [],
    categoryIds: filter.categoryIds ?? const [],
    excludedExerciseIds: excludedExerciseIds,
  );
}

/// La composizione del repository vive accanto al repository, non in un
/// provider di feature: e' l'unico punto autorizzato a conoscere i DAO
/// (`docs/development/01-principles.md`, dependency rule D6).
final exerciseInfoPageRepositoryProvider =
    Provider<IExerciseInfoPageRepository>(
      (ref) => ExerciseInfoPageRepositoryImpl(
        ref.watch(exerciseInfoPageServiceProvider),
        ref.watch(exerciseCatalogDaoProvider),
        ref.watch(customExerciseDaoProvider),
        outbox: ref.watch(outboxDaoProvider),
        database: ref.watch(appDatabaseProvider),
        ids: ref.watch(idGeneratorProvider),
        syncService: ref.watch(workoutSessionSyncServiceProvider),
      ),
    );
