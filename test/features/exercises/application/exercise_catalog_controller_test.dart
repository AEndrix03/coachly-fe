import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercises/application/exercise_catalog_controller.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Il controller e' sottile per scelta, quindi il test non verifica logica:
/// verifica il *contratto*. Se qualcuno gli aggiunge una trasformazione
/// silenziosa — normalizza un nome, inghiotte un `Err`, riordina una lista —
/// la presentation smette di vedere quello che il repository ha detto, e
/// questi test lo dicono subito.
void main() {
  test('inoltra la lettura locale senza toccarla', () async {
    final detail = ExerciseDetailModel(
      id: 'e1',
      nameI18n: const {'it': 'Squat'},
    );
    final repository = _RecordingRepository(downloaded: [detail]);
    final controller = ExerciseCatalogController(repository);

    expect(await controller.downloadedDetails(), [detail]);
    expect(repository.calls, ['getDownloadedDetails']);
  });

  test('propaga il Failure invece di convertirlo in un valore vuoto', () async {
    final repository = _RecordingRepository(
      detail: const Err(NotFoundFailure()),
    );
    final controller = ExerciseCatalogController(repository);

    final result = await controller.detail('mancante');

    // Il punto: un `Err` che diventa `null` a questo livello toglierebbe alla
    // schermata l'unica informazione con cui distinguere "non esiste" da
    // "non l'ho ancora scaricato" (docs/development/07-errors-and-feedback.md).
    expect(result, isA<Err<ExerciseDetailModel, Failure>>());
  });

  test('passa al repository tutti i campi della scheda personale', () async {
    final repository = _RecordingRepository();
    final controller = ExerciseCatalogController(repository);

    await controller.createPersonal(
      nameI18n: const {'it': 'Rematore'},
      difficultyLevel: 'beginner',
      isBodyweight: true,
    );

    // Un parametro dimenticato nell'inoltro non fa fallire la compilazione:
    // e' opzionale. Diventa un esercizio salvato senza difficolta'.
    expect(repository.lastCreate, {
      'nameI18n': {'it': 'Rematore'},
      'difficultyLevel': 'beginner',
      'isBodyweight': true,
    });
  });
}

class _RecordingRepository implements IExerciseInfoPageRepository {
  _RecordingRepository({
    this.downloaded = const [],
    Result<ExerciseDetailModel, Failure>? detail,
  }) : _detail =
           detail ??
           Ok(ExerciseDetailModel(id: 'e1', nameI18n: const {'it': 'Squat'}));

  final List<ExerciseDetailModel> downloaded;
  final Result<ExerciseDetailModel, Failure> _detail;
  final List<String> calls = <String>[];
  Map<String, Object?>? lastCreate;

  @override
  Future<List<ExerciseDetailModel>> getDownloadedDetails() async {
    calls.add('getDownloadedDetails');
    return downloaded;
  }

  @override
  Future<Result<ExerciseDetailModel, Failure>> getExerciseDetailResult(
    String exerciseId,
  ) async {
    calls.add('getExerciseDetailResult');
    return _detail;
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
    lastCreate = <String, Object?>{
      'nameI18n': nameI18n,
      if (descriptionI18n != null) 'descriptionI18n': descriptionI18n,
      if (tipsI18n != null) 'tipsI18n': tipsI18n,
      if (difficultyLevel != null) 'difficultyLevel': difficultyLevel,
      if (mechanicsType != null) 'mechanicsType': mechanicsType,
      if (forceType != null) 'forceType': forceType,
      if (isUnilateral != null) 'isUnilateral': isUnilateral,
      if (isBodyweight != null) 'isBodyweight': isBodyweight,
    };
    return _detail;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
