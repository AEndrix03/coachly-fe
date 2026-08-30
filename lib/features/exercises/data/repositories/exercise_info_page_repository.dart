import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercises/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercises/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercises/data/models/new/exercise_model/exercise_model.dart';

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
  /// I dettagli gia' scaricati in locale.
  ///
  /// Esiste perche' il catalogo vocale e il controllo scheda ne hanno bisogno:
  /// senza, importerebbero il DAO e violerebbero la dependency rule D6
  /// (`docs/development/01-principles.md`).
  Future<List<ExerciseDetailModel>> getDownloadedDetails();

  /// Il dettaglio locale, senza toccare la rete.
  Future<ExerciseDetailModel?> getCachedDetail(String exerciseId);

  // ── API definitiva ────────────────────────────────────────────────────────

  Future<Result<ExerciseDetailModel, Failure>> getExerciseDetailResult(
    String exerciseId,
  );

  /// I riepiloghi del catalogo, ricalcolati a ogni scrittura locale.
  ///
  /// È la forma canonica della lettura (`docs/development/04-data-layer.md`,
  /// regola 4): la UI si aggiorna perché il database notifica, non perché
  /// qualcuno ha chiamato `ref.invalidate`. Non ritorna `Result` perché una
  /// query locale che fallisce è un errore di programmazione, non un esito.
  Stream<List<ExerciseModel>> watchExerciseSummaries(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  });

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
}
