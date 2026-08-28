import 'package:coachly/features/exercise/exercise_info_page/data/fixtures/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercise/exercise_info_page/exercise_info_page.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_biomechanics_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_muscles_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_variants_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _runGoldens = bool.fromEnvironment('UPDATE_COACHLY_GOLDENS');

void main() {
  Future<void> pumpSized(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(390, 844),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: exerciseDetailTheme(ThemeData.dark()),
        home: child,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('exercise overview iPhone viewport', (tester) async {
    await pumpSized(
      tester,
      ExerciseOverviewContent(data: latPulldownExerciseFixture, onAdd: () {}),
    );
    await expectLater(
      find.byType(ExerciseOverviewContent),
      matchesGoldenFile('goldens/exercise_overview_390x844.png'),
    );
  }, skip: !_runGoldens);

  testWidgets('muscles visual and table', (tester) async {
    await pumpSized(
      tester,
      const ExerciseMusclesContent(data: latPulldownExerciseFixture),
    );
    await expectLater(
      find.byType(ExerciseMusclesContent),
      matchesGoldenFile('goldens/exercise_muscles_visual_390x844.png'),
    );
    await tester.tap(find.byKey(const Key('muscle-mode-table')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(ExerciseMusclesContent),
      matchesGoldenFile('goldens/exercise_muscles_table_390x844.png'),
    );
  }, skip: !_runGoldens);

  testWidgets('biomechanics iPhone viewport', (tester) async {
    await pumpSized(
      tester,
      const ExerciseBiomechanicsContent(data: latPulldownExerciseFixture),
    );
    await expectLater(
      find.byType(ExerciseBiomechanicsContent),
      matchesGoldenFile('goldens/exercise_biomechanics_390x844.png'),
    );
  }, skip: !_runGoldens);

  testWidgets('variants narrow Android viewport', (tester) async {
    await pumpSized(
      tester,
      const ExerciseVariantsContent(data: latPulldownExerciseFixture),
      size: const Size(360, 800),
    );
    await expectLater(
      find.byType(ExerciseVariantsContent),
      matchesGoldenFile('goldens/exercise_variants_360x800.png'),
    );
  }, skip: !_runGoldens);
}
