import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_hive_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';
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

/// Cache locale finta: nessun Hive aperto.
class _FakeHiveService implements ExerciseHiveService {
  final Map<String, ExerciseDetailModel> details = {};
  List<ExerciseModel> summaries = [];
  Object? readThrows;

  @override
  Future<ExerciseDetailModel?> getExercise(String exerciseId) async {
    final error = readThrows;
    if (error != null) throw error;
    return details[exerciseId];
  }

  @override
  Future<List<ExerciseDetailModel>> getExercises() async =>
      details.values.toList();

  @override
  Future<void> saveExerciseDetail(ExerciseDetailModel exercise) async {
    details[exercise.id ?? ''] = exercise;
  }

  @override
  Future<void> saveExerciseSummaries(List<ExerciseModel> exercises) async {
    summaries = exercises;
  }

  @override
  Future<bool> isEmpty() async => summaries.isEmpty;

  @override
  Future<List<ExerciseModel>> getExerciseSummaries() async => summaries;

  @override
  Future<List<ExerciseModel>> getFilteredExerciseSummaries(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async => summaries
      .where((exercise) => !excludedExerciseIds.contains(exercise.id))
      .toList();

  @override
  Future<List<ExerciseDetailModel>> getFilteredExercises(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async => details.values
      .where((exercise) => !excludedExerciseIds.contains(exercise.id))
      .toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeService service;
  late _FakeHiveService hive;
  late ExerciseInfoPageRepositoryImpl repository;

  const detail = ExerciseDetailModel(id: 'squat');
  const summary = ExerciseModel(id: 'squat');

  setUp(() {
    service = _FakeService();
    hive = _FakeHiveService();
    repository = ExerciseInfoPageRepositoryImpl(service, hive);
  });

  group('getExerciseDetailResult', () {
    test('la cache locale risponde senza toccare la rete', () async {
      hive.details['squat'] = detail;

      final result = await repository.getExerciseDetailResult('squat');

      expect(result.valueOrNull, detail);
      expect(service.detailCalls, 0);
    });

    test('la risposta remota viene salvata in cache', () async {
      service.detailResponse = ApiResponse.success(data: detail);

      final result = await repository.getExerciseDetailResult('squat');

      expect(result.isOk, isTrue);
      expect(hive.details['squat'], detail);
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

    test('un errore della cache locale diventa un Failure', () async {
      hive.readThrows = Exception('hive closed');

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

      expect(result.valueOrNull, [summary]);
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
}
