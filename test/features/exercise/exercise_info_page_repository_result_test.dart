import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/features/exercise/data/local/custom_exercise_dao.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercise/data/local/exercise_catalog_dao.dart';
import 'package:coachly/features/exercise/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/features/exercise/data/services/exercise_info_page_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Servizio di rete finto: nessuna `ApiClient`, nessuna socket.
class _FakeService implements ExerciseInfoPageService {
  ApiResponse<ExerciseDetailModel> detailResponse = ApiResponse.error(
    message: 'not stubbed',
    statusCode: 404,
  );
  ApiResponse<List<ExerciseModel>> allExercisesResponse = ApiResponse.success(
    data: const [],
  );
  Object? detailThrows;

  int detailCalls = 0;
  int allExercisesCalls = 0;

  @override
  Future<ApiResponse<ExerciseDetailModel>> fetchExerciseDetails(
    String exerciseId,
  ) async {
    detailCalls++;
    // Cede il turno: due chiamate concorrenti devono trovare la stessa Future.
    await Future<void>.delayed(Duration.zero);
    final error = detailThrows;
    if (error != null) throw error;
    return detailResponse;
  }

  @override
  Future<ApiResponse<List<ExerciseModel>>> fetchAllExercises() async {
    allExercisesCalls++;
    return allExercisesResponse;
  }

  @override
  Future<ApiResponse<List<ExerciseDetailModel>>> fetchFilteredExercises(
    ExerciseFilterModel filter,
  ) async => ApiResponse.success(data: const []);

  @override
  Future<ApiResponse<List<ExerciseModel>>> fetchMyExercises() async =>
      ApiResponse.success(data: const []);

  @override
  Future<ApiResponse<ExerciseDetailModel>> createPersonalExercise(
    Map<String, dynamic> body,
  ) async => detailResponse;

  @override
  Future<ApiResponse<ExerciseDetailModel>> updatePersonalExercise(
    String exerciseId,
    Map<String, dynamic> body,
  ) async => detailResponse;

  @override
  Future<ApiResponse<void>> deletePersonalExercise(String exerciseId) async =>
      ApiResponse<void>.success();
}

void main() {
  late _FakeService service;
  late AppDatabase db;
  late ExerciseCatalogDao catalog;
  late ExerciseInfoPageRepositoryImpl repository;

  const detail = ExerciseDetailModel(id: 'squat');
  const summary = ExerciseModel(id: 'squat');

  /// Ciò che il catalogo restituisce dopo un giro dal database: i campi
  /// booleani filtrabili hanno un default di colonna, non restano `null`.
  const storedSummary = ExerciseModel(
    id: 'squat',
    isUnilateral: false,
    isBodyweight: false,
  );

  setUp(() {
    service = _FakeService();
    db = AppDatabase(NativeDatabase.memory());
    catalog = ExerciseCatalogDao(db, FixedClock(DateTime.utc(2026, 1, 1)));
    repository = ExerciseInfoPageRepositoryImpl(
      service,
      catalog,
      CustomExerciseDao(
        db,
        FixedClock(DateTime.utc(2026, 1, 1)),
        const SilentAppLogger(),
      ),
    );
  });

  tearDown(() => db.close());

  group('getExerciseDetailResult', () {
    test('la cache locale risponde senza toccare la rete', () async {
      await catalog.upsertDetail(detail);

      final result = await repository.getExerciseDetailResult('squat');

      expect(result.valueOrNull, detail);
      expect(service.detailCalls, 0);
    });

    test('la risposta remota viene salvata in cache', () async {
      service.detailResponse = ApiResponse.success(data: detail);

      final result = await repository.getExerciseDetailResult('squat');

      expect(result.isOk, isTrue);
      expect(await catalog.getDetail('squat'), detail);
    });

    test('uno status code diventa il Failure corrispondente', () async {
      service.detailResponse = ApiResponse.error(
        message: 'missing',
        statusCode: 404,
      );

      final result = await repository.getExerciseDetailResult('squat');

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });

    test('nessuna eccezione attraversa il confine del data layer', () async {
      service.detailThrows = StateError('boom');

      final result = await repository.getExerciseDetailResult('squat');

      expect(result.failureOrNull, isA<UnexpectedFailure>());
    });

    test('un errore del database locale diventa un Failure', () async {
      await db.close();

      final result = await repository.getExerciseDetailResult('squat');

      expect(result, isA<Err<ExerciseDetailModel, Failure>>());
    });

    test('due richieste concorrenti riescono entrambe', () async {
      service.detailResponse = ApiResponse.success(data: detail);

      final results = await Future.wait([
        repository.getExerciseDetailResult('squat'),
        repository.getExerciseDetailResult('squat'),
      ]);

      expect(results.every((result) => result.isOk), isTrue);
      // La deduplica NON e' piu' qui: sta nel RequestCoalescer di ApiClient
      // (docs/development/06-networking.md), quindi con un service finto le
      // chiamate arrivano entrambe. Sul percorso reale producono una sola
      // richiesta HTTP; il comportamento e' verificato in
      // test/core/network/request_coalescer_test.dart.
      // Le due scritture in cache sono idempotenti.
      expect(service.detailCalls, 2);
    });
  });

  group('letture di catalogo', () {
    test('la cache vuota viene popolata dalla rete', () async {
      service.allExercisesResponse = ApiResponse.success(data: [summary]);

      final result = await repository.getExerciseSummariesResult();

      expect(result.valueOrNull, [storedSummary]);
      expect(service.allExercisesCalls, 1);
    });

    test(
      'il fallimento del riempimento e il fallimento della lettura',
      () async {
        service.allExercisesResponse = ApiResponse.error(
          message: 'down',
          statusCode: 503,
        );

        final result = await repository.getExerciseSummariesResult();

        expect(result.failureOrNull, isA<ServerFailure>());
      },
    );

    test('refreshFromRemoteResult propaga il Failure di rete', () async {
      service.allExercisesResponse = ApiResponse.error(
        message: 'offline',
        statusCode: 0,
      );

      final result = await repository.refreshFromRemoteResult();

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('filtri sulla cache locale', () {
    const barbellRow = ExerciseModel(
      id: 'squat',
      nameI18n: {'it': 'Squat con bilanciere'},
      difficultyLevel: 'advanced',
      mechanicsType: 'compound',
      isUnilateral: false,
      isBodyweight: false,
    );
    const bodyweightRow = ExerciseModel(
      id: 'push-up',
      nameI18n: {'it': 'Piegamenti'},
      difficultyLevel: 'beginner',
      mechanicsType: 'compound',
      isUnilateral: false,
      isBodyweight: true,
    );

    setUp(() {
      service.allExercisesResponse = ApiResponse.success(
        data: const [barbellRow, bodyweightRow],
      );
    });

    test('con la cache attiva un filtro non testuale trova comunque', () async {
      // La regressione storica: con Hive questa lista era vuota, perché la
      // cache persisteva tre campi e il filtro ne interrogava nove.
      final result = await repository.getFilteredExerciseSummariesResult(
        const ExerciseFilterModel(isBodyweight: true),
      );

      expect(result.valueOrNull?.map((exercise) => exercise.id), ['push-up']);
      // La rete è stata toccata una volta sola, per riempire la cache vuota.
      expect(service.allExercisesCalls, 1);
    });

    test('il filtro per difficoltà restringe la lista', () async {
      final result = await repository.getFilteredExerciseSummariesResult(
        const ExerciseFilterModel(difficultyLevel: 'advanced'),
      );

      expect(result.valueOrNull?.map((exercise) => exercise.id), ['squat']);
    });

    test('lo stream emette dopo una scrittura locale', () async {
      final emissions = <List<String?>>[];
      final subscription = repository
          .watchExerciseSummaries(const ExerciseFilterModel())
          .listen(
            (summaries) => emissions.add(
              summaries.map((exercise) => exercise.id).toList(),
            ),
          );

      await pumpEventQueue();
      await repository.refreshFromRemoteResult();
      await pumpEventQueue();

      await subscription.cancel();

      expect(emissions.first, isEmpty);
      expect(emissions.last, ['push-up', 'squat']);
    });
  });
}
