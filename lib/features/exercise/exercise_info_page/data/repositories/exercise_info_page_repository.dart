import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';

/// Repository del catalogo esercizi.
///
/// Migrazione di riferimento a `Result<T, Failure>`
/// (`docs/development/07-errors-and-feedback.md`): nessuna eccezione esce da
/// qui e nessun `Failure` contiene testo destinato all'utente.
///
/// I metodi con suffisso `Result` sono l'API definitiva. I metodi senza
/// suffisso sono **ponti temporanei** che ritornano ancora `ApiResponse`, per
/// non rompere i chiamanti non ancora migrati: quando l'ultimo chiamante sarà
/// migrato i ponti spariscono e il suffisso `Result` si toglie.
abstract class IExerciseInfoPageRepository {
  // ── API definitiva ────────────────────────────────────────────────────────

  Future<Result<ExerciseDetailModel, Failure>> getExerciseDetailResult(
    String exerciseId,
  );

  Future<Result<List<ExerciseModel>, Failure>> getAllExercisesResult();

  Future<Result<List<ExerciseModel>, Failure>> getExerciseSummariesResult();

  Future<Result<List<ExerciseDetailModel>, Failure>> getFilteredExercisesResult(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  });

  Future<Result<List<ExerciseModel>, Failure>>
  getFilteredExerciseSummariesResult(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  });

  Future<Result<List<ExerciseModel>, Failure>> getMyExercisesResult();

  Future<Result<ExerciseDetailModel, Failure>> createPersonalExerciseResult({
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  });

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
  });

  Future<Result<void, Failure>> deletePersonalExerciseResult(String exerciseId);

  Future<Result<List<ExerciseDetailModel>, Failure>> refreshFromRemoteResult();

  // ── Ponti di compatibilità (da rimuovere) ─────────────────────────────────

  @Deprecated('Use getExerciseDetailResult')
  Future<ApiResponse<ExerciseDetailModel>> getExerciseDetail(String exerciseId);

  @Deprecated('Use getAllExercisesResult')
  Future<ApiResponse<List<ExerciseModel>>> getAllExercises();

  @Deprecated('Use getExerciseSummariesResult')
  Future<ApiResponse<List<ExerciseModel>>> getExerciseSummaries();

  @Deprecated('Use getFilteredExercisesResult')
  Future<ApiResponse<List<ExerciseDetailModel>>> getFilteredExercises(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  });

  @Deprecated('Use getFilteredExerciseSummariesResult')
  Future<ApiResponse<List<ExerciseModel>>> getFilteredExerciseSummaries(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  });

  @Deprecated('Use getMyExercisesResult')
  Future<ApiResponse<List<ExerciseModel>>> getMyExercises();

  @Deprecated('Use createPersonalExerciseResult')
  Future<ApiResponse<ExerciseDetailModel>> createPersonalExercise({
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  });

  @Deprecated('Use updatePersonalExerciseResult')
  Future<ApiResponse<ExerciseDetailModel>> updatePersonalExercise(
    String exerciseId, {
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  });

  @Deprecated('Use deletePersonalExerciseResult')
  Future<ApiResponse<void>> deletePersonalExercise(String exerciseId);

  @Deprecated('Use refreshFromRemoteResult')
  Future<ApiResponse<List<ExerciseDetailModel>>> refreshFromRemote();
}
