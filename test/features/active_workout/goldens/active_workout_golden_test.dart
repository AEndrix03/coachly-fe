@Tags(['golden'])
library;

import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/application/rest_timer_provider.dart';
import 'package:coachly/features/active_workout/presentation/widgets/adaptive_workout_workspace.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:coachly/features/workouts/domain/models/workout_exercise_model.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Baseline visiva dell'allenamento attivo.
///
/// Nasce per una ragione precisa: `adaptive_workout_workspace.dart` è un file
/// da 3900 righe con 46 classi, va diviso, e **dividere senza una baseline è
/// un rifacimento a occhio**. Questi golden non descrivono il disegno
/// giusto — descrivono il disegno *attuale*, così che uno spostamento di file
/// che cambia un pixel si veda invece di passare.
///
/// Coprono i tre stati che il piano di lavoro deve reggere: l'esercizio
/// singolo con la serie attiva aperta, il recupero in corso, e un blocco
/// raggruppato. Sono i tre casi in cui la struttura del widget cambia forma,
/// non tre varianti dello stesso layout.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('allenamento attivo — serie corrente aperta', (tester) async {
    await _pump(tester, state: _singleExercise());
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('active_workout_current_set.png'),
    );
  });

  testWidgets('allenamento attivo — recupero in corso', (tester) async {
    await _pump(
      tester,
      state: _singleExercise(),
      rest: const RestTimerState(
        remainingSeconds: 75,
        isActive: true,
        initialSeconds: 90,
        isBellEnabled: true,
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('active_workout_resting.png'),
    );
  });

  testWidgets('allenamento attivo — blocco raggruppato', (tester) async {
    await _pump(tester, state: _superset());
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('active_workout_superset.png'),
    );
  });
}

// ─── Costruzione dello stato ─────────────────────────────────────────────────

ExerciseDetailModel _exercise(String id, String name) =>
    ExerciseDetailModel(id: id, nameI18n: {'it': name, 'en': name});

ActiveExerciseState _activeExercise({
  required String id,
  required String name,
  required String blockId,
  bool firstSetCompleted = true,
}) {
  final detail = _exercise(id, name);
  return ActiveExerciseState(
    executionBlockId: blockId,
    exercise: WorkoutExerciseModel(
      // `ActiveWorkoutState.currentExercise` risolve il bersaglio su questo
      // id, non su quello del dettaglio: tenerli uguali è ciò che fa il
      // resolver in produzione.
      id: id,
      exercise: detail,
      sets: '3',
      rest: '90s',
      weight: '80 kg',
      progress: 0,
    ),
    displayName: name,
    sets: [
      ActiveSetState(
        id: '$id:set:1',
        position: 0,
        setType: 'working',
        weight: 80,
        reps: 8,
        completed: firstSetCompleted,
        rir: 2,
      ),
      ActiveSetState(
        id: '$id:set:2',
        position: 1,
        setType: 'working',
        weight: 82.5,
        reps: 8,
        completed: false,
      ),
      ActiveSetState(
        id: '$id:set:3',
        position: 2,
        setType: 'working',
        weight: 85,
        reps: 6,
        completed: false,
      ),
    ],
  );
}

ActiveWorkoutState _singleExercise() {
  final exercise = _activeExercise(
    id: 'squat',
    name: 'Squat con bilanciere',
    blockId: 'block-1',
  );
  return ActiveWorkoutState(
    sessionId: 'session-golden',
    status: ActiveWorkoutStatus.active,
    sessionStatus: WorkoutSessionStatus.active,
    phase: WorkoutPhase.exercising,
    exercises: [exercise],
    currentTarget: const WorkoutExecutionTarget(
      blockId: 'block-1',
      exerciseId: 'squat',
      setId: 'squat:set:2',
    ),
  );
}

ActiveWorkoutState _superset() {
  final first = _activeExercise(
    id: 'panca',
    name: 'Panca piana',
    blockId: 'block-super',
  );
  final second = _activeExercise(
    id: 'rematore',
    name: 'Rematore',
    blockId: 'block-super',
    firstSetCompleted: false,
  );
  return ActiveWorkoutState(
    sessionId: 'session-golden',
    status: ActiveWorkoutStatus.active,
    sessionStatus: WorkoutSessionStatus.active,
    phase: WorkoutPhase.exercising,
    exercises: [first, second],
    groups: const [
      ActiveExerciseGroup(
        id: 'block-super',
        type: ExerciseGroupType.superset,
        exerciseIds: ['panca', 'rematore'],
        restAfterRoundSeconds: 120,
      ),
    ],
    currentTarget: const WorkoutExecutionTarget(
      blockId: 'block-super',
      exerciseId: 'panca',
      setId: 'panca:set:2',
    ),
  );
}

// ─── Pump ────────────────────────────────────────────────────────────────────

Future<void> _pump(
  WidgetTester tester, {
  required ActiveWorkoutState state,
  RestTimerState rest = const RestTimerState(
    remainingSeconds: 0,
    isActive: false,
    initialSeconds: 90,
    isBellEnabled: true,
  ),
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: exerciseDetailTheme(
        ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: CoachlyAthleteTheme.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: CoachlyAthleteTheme.primary,
            brightness: Brightness.dark,
            surface: CoachlyAthleteTheme.surface,
          ),
        ),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.exerciseTheme.background,
          body: SafeArea(
            child: AdaptiveWorkoutWorkspace(
              state: state,
              title: 'Allenamento A',
              elapsed: const Duration(minutes: 12, seconds: 30),
              rest: rest,
              loadUnit: 'kg',
              // I callback non partecipano al disegno: il golden fissa la
              // forma, non il comportamento — quello ha i suoi test.
              onBack: () {},
              onMenu: () {},
              onExercise: (_) {},
              onSet: (_) {},
              onWeight: (_, _) {},
              onReps: (_, _) {},
              onRir: (_) {},
              onComplete: (_) {},
              onAddSet: (_) {},
              onTechnique: (_) {},
              onRole: (_) {},
              onAddDrop: (_) {},
              onDropWeight: (_, _, _) {},
              onDropReps: (_, _, _) {},
              onDropRemoved: (_, _) {},
              onExerciseInfo: (_) {},
              onCreateGroup: (_, _) {},
              onAddExercise: () {},
              onAddBlockExercise: () async => null,
              onUngroup: (_) {},
              onCompleteWorkout: () {},
              onSkipRest: () {},
              onRestAdjust: (_) {},
              onRestTogglePause: () {},
              onRestToggleBell: () {},
              onNote: (_, _, _) {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
