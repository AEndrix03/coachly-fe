import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/api_client.dart' show CancelToken;
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/catalog_sync/data/local/catalog_meta_dao.dart';
import 'package:coachly/features/catalog_sync/data/repositories/catalog_sync_repository.dart';
import 'package:coachly/features/catalog_sync/data/services/catalog_delta_service.dart';
import 'package:coachly/features/catalog_sync/domain/catalog_delta.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CatalogMetaDao metaDao;
  late _FakeCatalogDeltaService deltaService;
  late _FakeExerciseRepository exerciseRepository;

  final frozenNow = DateTime.utc(2026, 3, 18, 11);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    metaDao = CatalogMetaDao(db, FixedClock(frozenNow));
    deltaService = _FakeCatalogDeltaService();
    exerciseRepository = _FakeExerciseRepository();
  });

  tearDown(() => db.close());

  CatalogSyncRepository buildRepository() => CatalogSyncRepository(
    deltaService: deltaService,
    metaDao: metaDao,
    exerciseRepository: exerciseRepository,
    logger: const SilentAppLogger(),
  );

  test('la prima volta scarica, anche se le versioni coincidono', () async {
    // Versione locale 0 significa «non ho mai applicato niente», non «ho la
    // versione 0»: senza questa distinzione una installazione nuova che trova
    // un backend a 0 non scaricherebbe mai il catalogo.
    deltaService.version = 0;

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.updated);
    expect(exerciseRepository.refreshCalls, 1);
  });

  test('versione invariata: nessun trasferimento', () async {
    // È il caso normale, ed è tutto il guadagno del canale a delta: si
    // confronta un intero invece di riscaricare il catalogo.
    deltaService.version = 42;
    await metaDao.setVersion(42);

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.alreadyCurrent);
    expect(exerciseRepository.refreshCalls, 0);
  });

  test('versione avanzata: aggiorna e registra la nuova', () async {
    deltaService.version = 43;
    await metaDao.setVersion(42);

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.updated);
    expect(exerciseRepository.refreshCalls, 1);
    expect(await metaDao.currentVersion(), 43);
  });

  test('un aggiornamento fallito non registra la versione', () async {
    // Scriverla comunque farebbe credere alla app di avere un catalogo che non
    // ha, e il disallineamento non si correggerebbe mai da solo.
    deltaService.version = 43;
    await metaDao.setVersion(42);
    exerciseRepository.fails = true;

    final result = await buildRepository().syncIfNeeded();

    expect(result.isOk, isFalse);
    expect(await metaDao.currentVersion(), 42);
  });

  test('senza rete il catalogo locale resta quello buono', () async {
    deltaService.fails = true;
    await metaDao.setVersion(42);

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.skipped);
    expect(exerciseRepository.refreshCalls, 0);
    expect(await metaDao.currentVersion(), 42);
  });
}

class _FakeCatalogDeltaService implements CatalogDeltaService {
  int version = 0;
  bool fails = false;

  @override
  Future<ApiResponse<int>> fetchVersion({CancelToken? cancelToken}) async {
    return fails
        ? ApiResponse<int>.error(message: 'offline')
        : ApiResponse<int>.success(data: version);
  }

  @override
  Future<ApiResponse<CatalogDelta>> fetchDelta({
    required int since,
    int limit = 1000,
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }
}

class _FakeExerciseRepository implements IExerciseInfoPageRepository {
  int refreshCalls = 0;
  bool fails = false;

  @override
  Future<Result<List<ExerciseDetailModel>, Failure>>
  refreshFromRemoteResult() async {
    refreshCalls++;
    return fails
        ? const Err(NetworkFailure('nope'))
        : const Ok(<ExerciseDetailModel>[]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
