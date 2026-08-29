import 'package:coachly/design_system/theme/exercise_theme.dart';
import '../support/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercise/exercise_info_page/exercise_info_page.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_content.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'a11y_fixtures.dart';
import 'a11y_harness.dart';

/// `docs/development/14-accessibility.md`: nessun overflow a `textScaler` 2.0.
///
/// Prima di questo file `textScaler` aveva **zero** occorrenze nel
/// repository: la app a text scaling alto non era mai stata eseguita da
/// nessuno. Chi si allena con gli occhiali appoggiati in borsa alza il testo
/// di sistema, e lo fa proprio nel contesto in cui usa questa app.
void main() {
  for (final scale in const [1.5, 2.0]) {
    testWidgets('la struttura della scheda non va in overflow a $scale', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: WorkoutStructure(
            workout: a11yWorkout(),
            onOpenExercise: (_) {},
            onAddExercise: () {},
          ),
        ),
        textScaler: TextScaler.linear(scale),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('la scheda esercizio espansa non va in overflow a $scale', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const SingleChildScrollView(
          child: WorkoutExerciseCard(
            exercise: a11yExercise,
            indexLabel: '01',
            onOpenDetail: _noop,
          ),
        ),
        textScaler: TextScaler.linear(scale),
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('la pagina esercizio non va in overflow a $scale', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        Theme(
          data: exerciseDetailTheme(ThemeData.dark()),
          child: ExerciseOverviewContent(
            data: latPulldownExerciseFixture,
            onAdd: () {},
          ),
        ),
        textScaler: TextScaler.linear(scale),
      );

      expect(tester.takeException(), isNull);
    });
  }
}

void _noop() {}
