import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_hive_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';

/// Implementazione di riferimento della migrazione a `Result<T, Failure>`.
///
/// Regola che governa il file: nessuna eccezione esce da un metodo pubblico.
/// Ogni accesso a rete o cache viene racchiuso e convertito in `Failure` qui,
/// dove ci sono le informazioni per farlo
/// (`docs/development/07-errors-and-feedback.md`).
class ExerciseInfoPageRepositoryImpl implements IExerciseInfoPageRepository {
  final ExerciseInfoPageService _service;
  final ExerciseHiveService _hiveService;

  ExerciseInfoPageRepositoryImpl(this._service, this._hiveService);

  // API definitiva ───────────────────────────────────────────────────────────

  @override
  /// La deduplica delle richieste concorrenti non vive più qui: sta nel
  /// `RequestCoalescer` di `ApiClient` (`docs/development/06-networking.md`).
  /// La mappa che stava in questo repository funzionava solo finché il
  /// repository restava vivo, cioè per coincidenza.
  Future<Result<ExerciseDetailModel, Failure>> getExerciseDetailResult(
    String exerciseId,
  ) async {
    try {
      final cached = await _hiveService.getExercise(exerciseId);
      if (cached != null) return Ok(cached);

      final remote = (await _service.fetchExerciseDetails(
        exerciseId,
      )).toResult();
      if (remote case Ok(:final value)) {
        await _hiveService.saveExerciseDetail(value);
      }
      return remote;
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ExerciseModel>, Failure>> getAllExercisesResult() =>
      getExerciseSummariesResult();

  @override
  Future<Result<List<ExerciseModel>, Failure>>
  getExerciseSummariesResult() async {
    try {
      final prepared = await _ensureLocalCache();
      if (prepared case Err(:final failure)) return Err(failure);
      return Ok(await _hiveService.getExerciseSummaries());
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
      return Ok(
        await _hiveService.getFilteredExercises(
          filter,
          excludedExerciseIds: excludedExerciseIds,
        ),
      );
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
        await _hiveService.getFilteredExerciseSummaries(
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
          await _hiveService.saveExerciseSummaries(value);
          // I dettagli restano volutamente pigri, uno esercizio alla volta.
          return const Ok([]);
      }
    } catch (e) {
      return Err(exceptionToFailure(e));
    }
  }

  // Ponti di compatibilità, da rimuovere ─────────────────────────────────────

  // Interni ──────────────────────────────────────────────────────────────────

  static ExerciseModel _toSummary(ExerciseDetailModel exercise) =>
      ExerciseModel(
        id: exercise.id,
        createdBy: exercise.createdBy,
        isPersonal: exercise.isPersonal,
        nameI18n: exercise.nameI18n,
        difficultyLevel: exercise.difficultyLevel,
        mechanicsType: exercise.mechanicsType,
        forceType: exercise.forceType,
        isUnilateral: exercise.isUnilateral,
        isBodyweight: exercise.isBodyweight,
      );

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
    if (!await _hiveService.isEmpty()) return const Ok(null);

    final refreshed = await refreshFromRemoteResult();
    return refreshed.map((_) {});
  }
}
