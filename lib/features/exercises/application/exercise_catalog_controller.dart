import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository_impl.dart'
    show exerciseInfoPageRepositoryProvider;
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/exercises/domain/models/exercise_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Il catalogo esercizi visto da una schermata.
///
/// Esiste per una ragione precisa: senza, ogni pagina che vuole un esercizio
/// importa `exercise_info_page_repository_impl.dart` per raggiungere il
/// provider, e la presentation finisce dentro il data layer
/// (`docs/development/01-principles.md`, dependency rule D2; il lint
/// `no_data_layer_in_presentation` lo segnala). Spostare il file non basta:
/// la composizione del repository sta giustamente accanto al repository,
/// perche' D6 lo rende l'unico autorizzato a conoscere i DAO. Serve un
/// intermediario, ed e' questo.
///
/// Non aggiunge logica. E' volutamente sottile: la sua utilita' e' *dove*
/// vive, non cosa fa. Quando una schermata avra' bisogno di stato — una
/// cache, un debounce, un ottimismo — quello stato avra' gia' un posto dove
/// stare, invece di finire in un `setState`.
class ExerciseCatalogController {
  ExerciseCatalogController(this._repository);

  final IExerciseInfoPageRepository _repository;

  /// I dettagli gia' presenti in locale: non tocca la rete, quindi una
  /// schermata puo' chiamarlo mentre l'utente e' offline (local-first,
  /// `docs/development/04-local-first.md`).
  Future<List<ExerciseDetailModel>> downloadedDetails() =>
      _repository.getDownloadedDetails();

  Future<Result<ExerciseDetailModel, Failure>> detail(String exerciseId) =>
      _repository.getExerciseDetailResult(exerciseId);

  Future<Result<List<ExerciseModel>, Failure>> myExercises() =>
      _repository.getMyExercisesResult();

  Future<Result<ExerciseDetailModel, Failure>> createPersonal({
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  }) => _repository.createPersonalExerciseResult(
    nameI18n: nameI18n,
    descriptionI18n: descriptionI18n,
    tipsI18n: tipsI18n,
    difficultyLevel: difficultyLevel,
    mechanicsType: mechanicsType,
    forceType: forceType,
    isUnilateral: isUnilateral,
    isBodyweight: isBodyweight,
  );

  Future<Result<ExerciseDetailModel, Failure>> updatePersonal(
    String exerciseId, {
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  }) => _repository.updatePersonalExerciseResult(
    exerciseId,
    nameI18n: nameI18n,
    descriptionI18n: descriptionI18n,
    tipsI18n: tipsI18n,
    difficultyLevel: difficultyLevel,
    mechanicsType: mechanicsType,
    forceType: forceType,
    isUnilateral: isUnilateral,
    isBodyweight: isBodyweight,
  );

  Future<Result<void, Failure>> deletePersonal(String exerciseId) =>
      _repository.deletePersonalExerciseResult(exerciseId);
}

final exerciseCatalogControllerProvider = Provider<ExerciseCatalogController>(
  (ref) =>
      ExerciseCatalogController(ref.watch(exerciseInfoPageRepositoryProvider)),
);
