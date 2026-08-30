import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/exercise/data/local/exercise_catalog_dao.dart';
import 'package:coachly/features/exercise/data/local/exercise_catalog_query.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/data/models/new/equipment_model/equipment_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_equipment_model/exercise_equipment_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_muscle_model/exercise_muscle_model.dart';
import 'package:coachly/features/exercise/data/models/new/muscle_model/muscle_model.dart';
import 'package:coachly/features/exercise/data/models/new/exercise_model/exercise_model.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Il DAO del catalogo su un database vero, in memoria: nessun mock, nessun
/// filesystem (`docs/development/19-testing.md`).
///
/// Il caso che questi test esistono per bloccare è la regressione della cache
/// Hive: tre campi persistiti, nove interrogati, quindi zero risultati per
/// qualsiasi filtro diverso dal testo.
void main() {
  late AppDatabase db;
  late ExerciseCatalogDao dao;

  final clock = FixedClock(DateTime.utc(2026, 1, 1));

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = ExerciseCatalogDao(db, clock);
  });

  tearDown(() => db.close());

  const squat = ExerciseModel(
    id: 'squat',
    nameI18n: {'it': 'Squat con bilanciere', 'en': 'Barbell squat'},
    difficultyLevel: 'advanced',
    mechanicsType: 'compound',
    forceType: 'push',
    isUnilateral: false,
    isBodyweight: false,
  );

  const lunge = ExerciseModel(
    id: 'lunge',
    nameI18n: {'it': 'Affondo', 'en': 'Lunge'},
    difficultyLevel: 'beginner',
    mechanicsType: 'compound',
    forceType: 'push',
    isUnilateral: true,
    isBodyweight: true,
  );

  const pushUp = ExerciseModel(
    id: 'push-up',
    nameI18n: {'it': 'Piegamenti', 'en': 'Push up'},
    difficultyLevel: 'beginner',
    mechanicsType: 'compound',
    forceType: 'push',
    isUnilateral: false,
    isBodyweight: true,
  );

  const catalogue = [squat, lunge, pushUp];

  Future<List<String>> ids(ExerciseCatalogQuery query) async {
    final summaries = await dao.getSummaries(query);
    return summaries.map((exercise) => exercise.id!).toList();
  }

  group('upsertSummaries', () {
    test('il catalogo vuoto si riconosce prima e dopo', () async {
      expect(await dao.isEmpty(), isTrue);
      await dao.upsertSummaries(catalogue);
      expect(await dao.isEmpty(), isFalse);
    });

    test('persiste ogni campo filtrabile, non solo il nome', () async {
      await dao.upsertSummaries(catalogue);

      final stored = await dao.getSummaries();
      final restored = stored.firstWhere((e) => e.id == 'squat');

      expect(restored.difficultyLevel, 'advanced');
      expect(restored.mechanicsType, 'compound');
      expect(restored.forceType, 'push');
      expect(restored.isUnilateral, isFalse);
      expect(restored.isBodyweight, isFalse);
      expect(restored.nameI18n, {
        'it': 'Squat con bilanciere',
        'en': 'Barbell squat',
      });
    });

    test('un esercizio sparito dal backend sparisce dal catalogo', () async {
      await dao.upsertSummaries(catalogue);
      await dao.upsertSummaries(const [squat]);

      expect(await ids(const ExerciseCatalogQuery()), ['squat']);
    });

    test('un riepilogo non cancella il dettaglio già scaricato', () async {
      await dao.upsertSummaries(catalogue);
      await dao.upsertDetail(
        const ExerciseDetailModel(id: 'squat', kineticChain: 'closed'),
      );

      await dao.upsertSummaries(catalogue);

      final detail = await dao.getDetail('squat');
      expect(detail?.kineticChain, 'closed');
    });

    test('gli esercizi senza id vengono scartati', () async {
      await dao.upsertSummaries(const [ExerciseModel(), squat]);
      expect(await ids(const ExerciseCatalogQuery()), ['squat']);
    });
  });

  group('filtri', () {
    setUp(() => dao.upsertSummaries(catalogue));

    test('per difficoltà', () async {
      expect(
        await ids(const ExerciseCatalogQuery(difficultyLevel: 'beginner')),
        ['lunge', 'push-up'],
      );
    });

    test('per meccanica', () async {
      expect(
        await ids(const ExerciseCatalogQuery(mechanicsType: 'isolation')),
        isEmpty,
      );
      expect(
        await ids(const ExerciseCatalogQuery(mechanicsType: 'compound')),
        hasLength(3),
      );
    });

    test('per bodyweight', () async {
      expect(await ids(const ExerciseCatalogQuery(isBodyweight: true)), [
        'lunge',
        'push-up',
      ]);
      expect(await ids(const ExerciseCatalogQuery(isBodyweight: false)), [
        'squat',
      ]);
    });

    test('per unilaterale', () async {
      expect(await ids(const ExerciseCatalogQuery(isUnilateral: true)), [
        'lunge',
      ]);
    });

    test(
      'per testo, in qualsiasi lingua e senza distinzione di maiuscole',
      () async {
        expect(
          await ids(const ExerciseCatalogQuery(textFilter: 'BILANCIERE')),
          ['squat'],
        );
        expect(await ids(const ExerciseCatalogQuery(textFilter: 'push')), [
          'push-up',
        ]);
      },
    );

    test('i criteri si sommano in AND', () async {
      expect(
        await ids(
          const ExerciseCatalogQuery(
            difficultyLevel: 'beginner',
            isUnilateral: true,
          ),
        ),
        ['lunge'],
      );
    });

    test('gli id esclusi non compaiono', () async {
      expect(
        await ids(const ExerciseCatalogQuery(excludedExerciseIds: {'squat'})),
        ['lunge', 'push-up'],
      );
    });

    test('lo scope `mine` non pesca nel catalogo Coachly', () async {
      expect(await ids(const ExerciseCatalogQuery(scope: 'mine')), isEmpty);
    });
  });

  group('tabelle ponte', () {
    const detail = ExerciseDetailModel(
      id: 'squat',
      nameI18n: {'it': 'Squat con bilanciere'},
      difficultyLevel: 'advanced',
      muscles: [
        ExerciseMuscleModel(
          muscle: MuscleModel(
            id: 'quadriceps',
            code: 'QUAD',
            nameI18n: {'it': 'Quadricipite'},
            descriptionI18n: {},
          ),
          activationPercentage: 80,
        ),
      ],
      equipments: [
        ExerciseEquipmentModel(
          equipment: EquipmentModel(
            id: 'barbell',
            code: 'BARBELL',
            nameI18n: {'it': 'Bilanciere'},
            descriptionI18n: {},
          ),
          isRequired: true,
        ),
      ],
    );

    setUp(() async {
      await dao.upsertSummaries(catalogue);
      await dao.upsertDetail(detail);
    });

    test('filtro per muscolo', () async {
      expect(await ids(const ExerciseCatalogQuery(muscleIds: ['quadriceps'])), [
        'squat',
      ]);
      expect(
        await ids(const ExerciseCatalogQuery(muscleIds: ['deltoid'])),
        isEmpty,
      );
    });

    test('filtro per attrezzo', () async {
      expect(await ids(const ExerciseCatalogQuery(equipmentIds: ['barbell'])), [
        'squat',
      ]);
      expect(
        await ids(const ExerciseCatalogQuery(equipmentIds: ['machine'])),
        isEmpty,
      );
    });

    test('un secondo salvataggio non duplica le righe ponte', () async {
      await dao.upsertDetail(detail);
      final muscles = await db.select(db.exerciseMuscles).get();
      expect(muscles, hasLength(1));
      expect(muscles.single.involvement, 'primary');
    });
  });

  group('round trip JSON → riga → modello', () {
    test('il dettaglio torna identico a come è arrivato', () async {
      final json = {
        'id': 'squat',
        'nameI18n': {'it': 'Squat con bilanciere'},
        'difficultyLevel': 'advanced',
        'mechanicsType': 'compound',
        'forceType': 'push',
        'unilateral': false,
        'bodyweight': false,
        'kineticChain': 'closed',
        'muscles': [
          {
            'muscle': {
              'id': 'quadriceps',
              'code': 'QUAD',
              'nameI18n': {'it': 'Quadricipite'},
              'descriptionI18n': <String, String>{},
            },
            'activationPercentage': 80,
          },
        ],
      };
      final parsed = ExerciseDetailModel.fromJson(json);

      await dao.upsertDetail(parsed);

      expect(await dao.getDetail('squat'), parsed);
    });

    test('un payload illeggibile è una cache miss, non un crash', () async {
      await dao.upsertSummaries(const [squat]);
      await (db.update(db.catalogExercises)
            ..where((table) => table.id.equals('squat')))
          .write(const CatalogExercisesCompanion(payload: Value('{')));

      expect(await dao.getDetail('squat'), isNull);
    });

    test('il dettaglio mancante è null, non un errore', () async {
      expect(await dao.getDetail('sconosciuto'), isNull);
    });
  });

  group('watchSummaries', () {
    test('emette di nuovo dopo una scrittura, senza invalidazioni', () async {
      final emissions = <List<String>>[];
      final subscription = dao.watchSummaries().listen(
        (summaries) =>
            emissions.add(summaries.map((exercise) => exercise.id!).toList()),
      );

      await pumpEventQueue();
      await dao.upsertSummaries(const [squat]);
      await pumpEventQueue();
      await dao.upsertSummaries(catalogue);
      await pumpEventQueue();

      await subscription.cancel();

      expect(emissions.first, isEmpty);
      expect(emissions, contains(equals(['squat'])));
      expect(emissions.last, ['lunge', 'push-up', 'squat']);
    });

    test('lo stream filtrato reagisce solo a ciò che lo riguarda', () async {
      final emissions = <List<String>>[];
      final subscription = dao
          .watchSummaries(const ExerciseCatalogQuery(isUnilateral: true))
          .listen(
            (summaries) => emissions.add(
              summaries.map((exercise) => exercise.id!).toList(),
            ),
          );

      await pumpEventQueue();
      await dao.upsertSummaries(catalogue);
      await pumpEventQueue();

      await subscription.cancel();

      expect(emissions.last, ['lunge']);
    });
  });
}
