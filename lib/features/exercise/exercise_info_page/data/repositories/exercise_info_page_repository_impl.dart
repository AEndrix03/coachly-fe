import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/local/exercise_catalog_dao.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/local/exercise_catalog_query.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';

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

  ExerciseInfoPageRepositoryImpl(this._service, this._catalog);

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
        await _catalog.getSummaries(
          toCatalogQuery(filter, excludedExerciseIds: excludedExerciseIds),
        ),
      );
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ExerciseModel>, Failure>> getMyExercisesResult() async {
    try {
      return (await _service.fetchMyExercises()).toResult();
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
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
      final result = (await _service.createPersonalExercise({
        'nameI18n': nameI18n,
        'descriptionI18n': descriptionI18n,
        'tipsI18n': tipsI18n,
        'difficultyLevel': difficultyLevel,
        'mechanicsType': mechanicsType,
        'forceType': forceType,
        'isUnilateral': isUnilateral,
        'isBodyweight': isBodyweight,
      })).toResult();
      await _refreshCacheAfterWrite(result);
      return result;
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
      final result = (await _service.updatePersonalExercise(exerciseId, {
        'nameI18n': nameI18n,
        'descriptionI18n': descriptionI18n,
        'tipsI18n': tipsI18n,
        'difficultyLevel': difficultyLevel,
        'mechanicsType': mechanicsType,
        'forceType': forceType,
        'isUnilateral': isUnilateral,
        'isBodyweight': isBodyweight,
      })).toResult();
      await _refreshCacheAfterWrite(result);
      return result;
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> deletePersonalExerciseResult(
    String exerciseId,
  ) async {
    try {
      final result = (await _service.deletePersonalExercise(
        exerciseId,
      )).toVoidResult();
      await _refreshCacheAfterWrite(result);
      return result;
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
          // I dettagli restano volutamente pigri, uno esercizio alla volta.
          return const Ok([]);
      }
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  // Interni ──────────────────────────────────────────────────────────────────

  Future<void> _refreshCacheAfterWrite(Result<Object?, Failure> result) async {
    if (result.isOk) {
      await refreshFromRemoteResult();
    }
  }

  /// Popola la cache locale quando è vuota.
  ///
  /// Ritorna un `Result` invece di lanciare: il fallimento del riempimento è
  /// il fallimento della lettura che lo ha richiesto.
  Future<Result<void, Failure>> _ensureLocalCache() async {
    if (!await _catalog.isEmpty()) return const Ok(null);

    final refreshed = await refreshFromRemoteResult();
    return refreshed.map((_) {});
  }
}

/// Il filtro della presentazione → i criteri che lo schema locale sa esprimere.
///
/// Vive qui e non in `data/local/`: il DAO non deve conoscere
/// `ExerciseFilterModel`, che porta con sé `langFilter` e `categoryIds`, cioè
/// parametri di query del backend.
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
    excludedExerciseIds: excludedExerciseIds,
  );
}
