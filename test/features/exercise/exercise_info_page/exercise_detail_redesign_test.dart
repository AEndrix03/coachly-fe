import 'package:coachly/features/exercise/exercise_info_page/data/fixtures/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercise/exercise_info_page/exercise_info_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_biomechanics_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_muscles_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/exercise_variants_page.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/widgets/exercise_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget overview({VoidCallback? onAdd}) => MaterialApp(
    theme: exerciseDetailTheme(ThemeData.dark()),
    home: ExerciseOverviewContent(
      data: latPulldownExerciseFixture,
      onAdd: onAdd ?? () {},
    ),
  );

  testWidgets('expands execution and common mistakes inline', (tester) async {
    await tester.pumpWidget(overview());

    expect(
      find.text('Fermati quando la barra raggiunge la parte alta del petto.'),
      findsNothing,
    );
    await tester.tap(find.text('Vedi tutti i passaggi'));
    await tester.pumpAndSettle();
    expect(
      find.text('Fermati quando la barra raggiunge la parte alta del petto.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Mostra altri 2'));
    await tester.pumpAndSettle();
    expect(
      find.text('Lasciare risalire il carico senza controllo.'),
      findsOneWidget,
    );
  });

  testWidgets('opens the Coachly information sheet', (tester) async {
    await tester.pumpWidget(overview());
    final biomechanicsTitle = find.byWidgetPredicate(
      (widget) =>
          widget is ExerciseSectionTitle && widget.title == 'Biomeccanica',
    );
    await tester.scrollUntilVisible(biomechanicsTitle, 520);
    await tester.pumpAndSettle();

    final section = find.ancestor(
      of: biomechanicsTitle,
      matching: find.byType(Row),
    );
    await tester.tap(
      find.descendant(
        of: section.first,
        matching: find.byTooltip('Informazioni'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Perché conta?'), findsOneWidget);
    expect(find.text('Ho capito'), findsOneWidget);
  });

  testWidgets('invokes add exercise callback', (tester) async {
    var additions = 0;
    await tester.pumpWidget(overview(onAdd: () => additions++));
    await tester.tap(find.byKey(const Key('exercise-add-action')));
    await tester.pump();
    expect(additions, 1);
  });

  testWidgets('muscles switches visual/table and selects a muscle', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: exerciseDetailTheme(ThemeData.dark()),
        home: const ExerciseMusclesContent(data: latPulldownExerciseFixture),
      ),
    );

    expect(find.byKey(const ValueKey('muscle-visual')), findsOneWidget);
    await tester.tap(find.byKey(const Key('muscle-mode-table')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('muscle-table')), findsOneWidget);
    await tester.tap(find.byKey(const Key('muscle-row-teres-major')));
    await tester.pumpAndSettle();
    expect(find.text('Grande rotondo'), findsOneWidget);
  });

  testWidgets('variants filters by relation axis', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: exerciseDetailTheme(ThemeData.dark()),
        home: const ExerciseVariantsContent(data: latPulldownExerciseFixture),
      ),
    );

    expect(find.byType(VariantTile), findsNWidgets(5));
    await tester.tap(find.byKey(const Key('variant-filter-Unilaterale')));
    await tester.pumpAndSettle();
    expect(find.byType(VariantTile), findsOneWidget);
    expect(find.text('Single Arm Lat Pulldown'), findsOneWidget);
  });

  testWidgets('quick navigation opens each detail and supports back', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/exercise',
      routes: [
        GoRoute(
          path: '/exercise',
          builder: (_, _) => ExerciseOverviewContent(
            data: latPulldownExerciseFixture,
            onAdd: () {},
          ),
        ),
        GoRoute(
          path: '/exercises/lat-pulldown/biomechanics',
          builder: (_, _) => const ExerciseBiomechanicsContent(
            data: latPulldownExerciseFixture,
          ),
        ),
        GoRoute(
          path: '/exercises/lat-pulldown/muscles',
          builder: (_, _) =>
              const ExerciseMusclesContent(data: latPulldownExerciseFixture),
        ),
        GoRoute(
          path: '/exercises/lat-pulldown/variants',
          builder: (_, _) =>
              const ExerciseVariantsContent(data: latPulldownExerciseFixture),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: exerciseDetailTheme(ThemeData.dark()),
        routerConfig: router,
      ),
    );

    await tester.tap(find.byKey(const Key('quick-nav-muscles')));
    await tester.pumpAndSettle();
    expect(find.text('Muscoli'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Lat Pulldown'), findsOneWidget);
  });

  testWidgets('morph navigation exposes floating bubbles after scroll', (
    tester,
  ) async {
    await tester.pumpWidget(overview());
    expect(find.byKey(const Key('floating-quick-nav-muscles')), findsNothing);

    await tester.drag(
      find.byKey(const Key('exercise-overview-scroll')),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('floating-quick-nav-muscles')), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Da ricordare'), 650);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('floating-quick-nav-variants')),
      findsOneWidget,
    );

    await tester.drag(
      find.byKey(const Key('exercise-overview-scroll')),
      const Offset(0, 4000),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('floating-quick-nav-muscles')), findsNothing);
  });

  testWidgets('bottom navigation is a vertical editorial action list', (
    tester,
  ) async {
    await tester.pumpWidget(overview());
    expect(find.text('Close Grip Lat Pulldown'), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(const Key('quick-nav-destination-biomechanics')),
      650,
    );
    await tester.pumpAndSettle();

    expect(find.text('Analizza la biomeccanica'), findsWidgets);
    expect(find.text('Esplora i muscoli'), findsWidgets);
    expect(find.text('Esplora le varianti'), findsWidgets);

    final biomechanicsTop = tester.getTopLeft(
      find.byKey(const Key('quick-nav-destination-biomechanics')),
    );
    final musclesTop = tester.getTopLeft(
      find.byKey(const Key('quick-nav-destination-muscles')),
    );
    final variantsTop = tester.getTopLeft(
      find.byKey(const Key('quick-nav-destination-variants')),
    );
    expect(musclesTop.dy, greaterThan(biomechanicsTop.dy));
    expect(variantsTop.dy, greaterThan(musclesTop.dy));
    expect(musclesTop.dx, biomechanicsTop.dx);
    expect(variantsTop.dx, biomechanicsTop.dx);
  });
}
