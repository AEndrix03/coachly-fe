import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/api_client.dart' show CancelToken;
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/catalog_sync/data/local/catalog_meta_dao.dart';
import 'package:coachly/features/catalog_sync/data/repositories/catalog_sync_repository.dart';
import 'package:coachly/features/catalog_sync/data/services/catalog_delta_service.dart';
import 'package:coachly/features/catalog_sync/domain/catalog_delta.dart';
import 'package:coachly/features/exercises/data/local/exercise_catalog_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CatalogMetaDao metaDao;
  late ExerciseCatalogDao catalogDao;
  late _FakeCatalogDeltaService deltaService;

  final frozenNow = DateTime.utc(2026, 3, 18, 11);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final clock = FixedClock(frozenNow);
    metaDao = CatalogMetaDao(db, clock);
    catalogDao = ExerciseCatalogDao(db, clock);
    deltaService = _FakeCatalogDeltaService();
  });

  tearDown(() => db.close());

  CatalogSyncRepository buildRepository() => CatalogSyncRepository(
    deltaService: deltaService,
    metaDao: metaDao,
    catalogDao: catalogDao,
    logger: const SilentAppLogger(),
  );

  Map<String, dynamic> exercisePayload(String id, String name) => {
    'id': id,
    'code': id,
    'nameI18n': {'it': name, 'en': name},
    'unilateral': false,
    'bodyweight': false,
  };

  CatalogDelta page({
    required int version,
    required bool complete,
    List<CatalogExerciseChange> exercises = const [],
    int since = 0,
  }) => CatalogDelta(
    since: since,
    version: version,
    complete: complete,
    exercises: exercises,
  );

  Future<List<String?>> localIds() async {
    final rows = await db.select(db.catalogExercises).get();
    return (rows.map((row) => row.id).toList()..sort());
  }

  test('versione invariata: nessun delta viene nemmeno chiesto', () async {
    // È il caso normale, ed è tutto il guadagno: si confronta un intero.
    deltaService.version = 42;
    await metaDao.setVersion(42);

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.alreadyCurrent);
    expect(deltaService.deltaCalls, isEmpty);
  });

  test('applica gli esercizi cambiati e registra il watermark', () async {
    deltaService.version = 7;
    deltaService.pages = [
      page(
        version: 7,
        complete: true,
        exercises: [
          CatalogExerciseChange(
            id: 'squat',
            sha: 'sha-squat',
            deleted: false,
            payload: exercisePayload('squat', 'Squat'),
          ),
        ],
      ),
    ];

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.updated);
    expect(await localIds(), ['squat']);
    expect(await metaDao.currentVersion(), 7);
  });

  test('conserva l impronta accanto all esercizio', () async {
    // Serve a sapere se il locale è davvero ciò che il server crede che sia,
    // senza riscaricare il payload per confrontarlo.
    deltaService.version = 7;
    deltaService.pages = [
      page(
        version: 7,
        complete: true,
        exercises: [
          CatalogExerciseChange(
            id: 'squat',
            sha: 'sha-squat',
            deleted: false,
            payload: exercisePayload('squat', 'Squat'),
          ),
        ],
      ),
    ];

    await buildRepository().syncIfNeeded();

    final row = await (db.select(
      db.catalogExercises,
    )..where((table) => table.id.equals('squat'))).getSingle();
    expect(row.sha, 'sha-squat');
  });

  test('un esercizio ritirato viene rimosso dal locale', () async {
    deltaService.version = 9;
    deltaService.pages = [
      page(
        version: 8,
        complete: false,
        exercises: [
          CatalogExerciseChange(
            id: 'squat',
            sha: 'a',
            deleted: false,
            payload: exercisePayload('squat', 'Squat'),
          ),
        ],
      ),
      page(
        since: 8,
        version: 9,
        complete: true,
        exercises: const [
          CatalogExerciseChange(
            id: 'squat',
            sha: '',
            deleted: true,
            payload: {},
          ),
        ],
      ),
    ];

    await buildRepository().syncIfNeeded();

    expect(await localIds(), isEmpty);
  });

  test('un delta troncato continua dalla pagina successiva', () async {
    deltaService.version = 2;
    deltaService.pages = [
      page(
        version: 1,
        complete: false,
        exercises: [
          CatalogExerciseChange(
            id: 'a',
            sha: 'a',
            deleted: false,
            payload: exercisePayload('a', 'A'),
          ),
        ],
      ),
      page(
        since: 1,
        version: 2,
        complete: true,
        exercises: [
          CatalogExerciseChange(
            id: 'b',
            sha: 'b',
            deleted: false,
            payload: exercisePayload('b', 'B'),
          ),
        ],
      ),
    ];

    await buildRepository().syncIfNeeded();

    expect(await localIds(), ['a', 'b']);
    expect(deltaService.deltaCalls, [0, 1], reason: 'riparte dal watermark');
    expect(await metaDao.currentVersion(), 2);
  });

  test('il delta popola i dettagli che il selettore di esercizi legge', () async {
    // È la regressione vista in «Edit workout»: il selettore legge i dettagli
    // *scaricati* (`payload` non nullo), e finché la sync portava solo i
    // riepiloghi vedeva un esercizio solo — quello che l'utente aveva aperto a
    // mano. Il delta porta il dettaglio completo, quindi li deve vedere tutti.
    deltaService.version = 3;
    deltaService.pages = [
      page(
        version: 3,
        complete: true,
        exercises: [
          CatalogExerciseChange(
            id: 'squat',
            sha: 'a',
            deleted: false,
            payload: exercisePayload('squat', 'Squat'),
          ),
          CatalogExerciseChange(
            id: 'panca',
            sha: 'b',
            deleted: false,
            payload: exercisePayload('panca', 'Panca'),
          ),
        ],
      ),
    ];

    await buildRepository().syncIfNeeded();

    final details = await catalogDao.getAllDetails();
    expect(
      details.map((detail) => detail.id).toList()..sort(),
      ['panca', 'squat'],
    );
  });

  test('senza rete il catalogo locale resta quello buono', () async {
    deltaService.fails = true;
    await metaDao.setVersion(42);

    final result = await buildRepository().syncIfNeeded();

    expect(result.valueOrNull, CatalogSyncOutcome.skipped);
    expect(await metaDao.currentVersion(), 42);
  });
}

class _FakeCatalogDeltaService implements CatalogDeltaService {
  int version = 0;
  bool fails = false;
  List<CatalogDelta> pages = const [];

  /// I `since` con cui il delta è stato richiesto, in ordine.
  final List<int> deltaCalls = [];

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
  }) async {
    deltaCalls.add(since);
    final next = pages.isEmpty ? null : pages.removeAt(0);
    return next == null
        ? ApiResponse<CatalogDelta>.error(message: 'no page')
        : ApiResponse<CatalogDelta>.success(data: next);
  }
}
