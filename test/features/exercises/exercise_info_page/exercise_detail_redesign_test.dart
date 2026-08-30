import '../../../support/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercises/presentation/pages/exercise_info_page.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercises/presentation/pages/coachly_concept_guide_page.dart';
import 'package:coachly/features/exercises/presentation/pages/exercise_biomechanics_page.dart';
import 'package:coachly/features/exercises/presentation/pages/exercise_muscles_page.dart';
import 'package:coachly/features/exercises/presentation/pages/exercise_variants_page.dart';
import 'package:coachly/features/exercises/presentation/widgets/exercise_detail_widgets.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Le schermate sono passate da stringhe italiane inline a `context.tr`: senza
/// locale il fallback e' l'inglese e le asserzioni italiane non trovano nulla.
/// L'harness dichiara la lingua invece di far dipendere il test dal default.
///
/// `AppLocalizations.delegate` deve essere qui: le schermate migrate a
/// `context.l10n` risolvono le chiavi tramite `Localizations.of<AppLocalizations>`
/// e senza questo delegate quella lookup lancia, a differenza di `context.tr`
/// che ha un fallback su `AppStrings`.
const _locale = Locale('it');
const _delegates = <LocalizationsDelegate<Object?>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

void main() {
  Widget overview({VoidCallback? onAdd}) => MaterialApp(
    locale: _locale,
    supportedLocales: AppStrings.supportedLocales,
    localizationsDelegates: _delegates,
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
    // La pagina e' una lista pigra: il blocco esecuzione non e' costruito
    // finche' non entra nel viewport.
    await tester.scrollUntilVisible(find.text('Vedi tutti i passaggi'), 400);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vedi tutti i passaggi'));
    await tester.pumpAndSettle();
    expect(
      find.text('Fermati quando la barra raggiunge la parte alta del petto.'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(find.text('Mostra altri 2'), 400);
    await tester.pumpAndSettle();
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

    // Il bottone info vive dentro `ExerciseSectionTitle`, non in una Row che
    // lo avvolge: cercarlo fra gli antenati dipendeva da un dettaglio di
    // layout che nel frattempo e' cambiato.
    final infoButton = find.descendant(
      of: biomechanicsTitle,
      matching: find.byType(IconButton),
    );
    await tester.ensureVisible(infoButton);
    await tester.pumpAndSettle();
    await tester.tap(infoButton);
    await tester.pumpAndSettle();
    expect(find.text('Perché conta?'), findsOneWidget);
    expect(find.text('Ho capito'), findsOneWidget);
  });

  testWidgets('biomechanics explains grouped and resistance concepts', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: _locale,
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: _delegates,
        theme: exerciseDetailTheme(ThemeData.dark()),
        home: const ExerciseBiomechanicsContent(
          data: latPulldownExerciseFixture,
        ),
      ),
    );

    Future<void> openInfo(String title) async {
      final sectionTitle = find.byWidgetPredicate(
        (widget) => widget is ExerciseSectionTitle && widget.title == title,
      );
      await tester.scrollUntilVisible(
        sectionTitle,
        320,
        // La chiave sta sul CustomScrollView, non sullo Scrollable interno:
        // `scrollable:` vuole il secondo.
        scrollable: find.descendant(
          of: find.byKey(const Key('biomechanics-page-scroll')),
          matching: find.byType(Scrollable),
        ),
      );
      // Il bottone, non il RawTooltip che lo avvolge: quest'ultimo ha un
      // surrogate box fuori dal viewport e il tap non lo colpisce.
      final infoButton = find.descendant(
        of: sectionTitle,
        matching: find.byType(IconButton),
      );
      await tester.ensureVisible(infoButton);
      await tester.pumpAndSettle();
      await tester.tap(infoButton);
      await tester.pumpAndSettle();
    }

    await openInfo('Caratteristiche di allenamento');
    expect(find.textContaining('tre aspetti distinti'), findsOneWidget);
    expect(find.text('Caratteristiche di allenamento'), findsNWidgets(2));
    await tester.tap(find.text('Ho capito'));
    await tester.pumpAndSettle();

    await openInfo('Fonte di resistenza');
    expect(find.textContaining('cavo, un peso libero'), findsOneWidget);
    await tester.tap(find.text('Ho capito'));
    await tester.pumpAndSettle();

    await openInfo('Profilo di resistenza');
    expect(find.textContaining('range di movimento'), findsOneWidget);
    expect(find.textContaining('profilo qualitativo'), findsOneWidget);
    await tester.tap(find.textContaining('Approfondisci'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('coachly-guide-resistanceProfile')),
      findsOneWidget,
    );
    expect(find.text('Come si legge il grafico'), findsOneWidget);
  });

  testWidgets('renders every Coachly concept guide', (tester) async {
    for (final topic in CoachlyGuideTopic.values) {
      await tester.pumpWidget(
        MaterialApp(
          locale: _locale,
          supportedLocales: AppStrings.supportedLocales,
          localizationsDelegates: _delegates,
          theme: exerciseDetailTheme(ThemeData.dark()),
          home: CoachlyConceptGuidePage(topic: topic),
        ),
      );
      expect(find.byKey(Key('coachly-guide-${topic.name}')), findsOneWidget);
      expect(find.text(topic.title), findsOneWidget);
      expect(find.text(topic.intro), findsOneWidget);
    }
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
        locale: _locale,
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: _delegates,
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
    // La lista e' pigra: su un viewport da 600px solo quattro tile vengono
    // costruite e il conteggio misurerebbe l'altezza dello schermo, non il
    // filtro. Il viewport alto rende l'asserzione deterministica.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: _locale,
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: _delegates,
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
        locale: _locale,
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: _delegates,
        theme: exerciseDetailTheme(ThemeData.dark()),
        routerConfig: router,
      ),
    );

    // La barra di quick nav e' dentro la lista pigra: va portata nel viewport
    // prima di poterla toccare.
    await tester.scrollUntilVisible(
      find.byKey(const Key('quick-nav-muscles')),
      300,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-nav-muscles')));
    await tester.pumpAndSettle();
    expect(find.text('Muscoli'), findsWidgets);
    // Le pagine di dettaglio non hanno l'AppBar di sistema: `pageBack()`
    // cerca un pulsante che questo design non usa. Il ritorno passa dal
    // router, che e' il meccanismo reale.
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Lat Pulldown'), findsOneWidget);
  });

  testWidgets('morph navigation exposes floating bubbles after scroll', (
    tester,
  ) async {
    await tester.pumpWidget(overview());
    expect(find.byKey(const Key('floating-quick-nav-muscles')), findsNothing);

    // La sezione che porta il gutter e' costruita pigramente: a offset 0 non
    // esiste ancora. Uno scroll breve la costruisce restando sotto la soglia
    // di deploy del rail (0.82 del viewport), cosi' lo stato "prima" resta
    // osservabile.
    await tester.drag(
      find.byKey(const Key('exercise-overview-scroll')),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();

    expect(
      (tester
                  .widget<Padding>(
                    find.byKey(const Key('quick-nav-dynamic-gutter')),
                  )
                  .padding
              as EdgeInsets)
          .right,
      0,
    );
    expect(
      tester
          .widget<Opacity>(
            find.byKey(const Key('quick-nav-static-source-opacity')),
          )
          .opacity,
      1,
    );

    await tester.drag(
      find.byKey(const Key('exercise-overview-scroll')),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('floating-quick-nav-muscles')), findsOneWidget);
    expect(
      (tester
                  .widget<Padding>(
                    find.byKey(const Key('quick-nav-dynamic-gutter')),
                  )
                  .padding
              as EdgeInsets)
          .right,
      closeTo(54, 0.1),
    );

    // Dopo il deploy la sorgente statica e' fuori dal viewport, quindi la
    // lista pigra puo' averla gia' smontata. Se e' ancora costruita deve pero'
    // essere invisibile: e' la meta' del morph che il test verifica.
    final staticSource = find.byKey(
      const Key('quick-nav-static-source-opacity'),
    );
    if (staticSource.evaluate().isNotEmpty) {
      expect(tester.widget<Opacity>(staticSource).opacity, 0);
    }

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
    await tester.drag(
      find.byKey(const Key('exercise-overview-scroll')),
      const Offset(0, -1000),
    );
    await tester.pumpAndSettle();

    expect(
      (tester
                  .widget<Padding>(
                    find.byKey(const Key('quick-nav-bottom-gutter')),
                  )
                  .padding
              as EdgeInsets)
          .right,
      0,
    );
    final destinationBeforeOverlayDrag = tester.getTopLeft(
      find.byKey(const Key('quick-nav-destination-biomechanics')),
    );
    await tester.drag(
      find.byKey(const Key('floating-quick-nav-biomechanics')),
      const Offset(0, 180),
    );
    await tester.pumpAndSettle();
    final destinationAfterOverlayDrag = tester.getTopLeft(
      find.byKey(const Key('quick-nav-destination-biomechanics')),
    );
    expect(
      destinationAfterOverlayDrag.dy,
      greaterThan(destinationBeforeOverlayDrag.dy),
    );
    expect(
      tester
          .widget<Opacity>(
            find.byKey(const Key('quick-nav-static-destination-opacity')),
          )
          .opacity,
      0,
    );
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

  testWidgets('overview keeps ballistic motion after finger release', (
    tester,
  ) async {
    await tester.pumpWidget(overview());
    final scrollView = find.byKey(const Key('exercise-overview-scroll'));
    await tester.fling(scrollView, const Offset(0, -520), 1500);
    await tester.pump();
    final positionAfterRelease = tester.getTopLeft(find.text('Come eseguirlo'));
    await tester.pump(const Duration(milliseconds: 80));
    final positionDuringBallistic = tester.getTopLeft(
      find.text('Come eseguirlo'),
    );
    expect(positionDuringBallistic.dy, lessThan(positionAfterRelease.dy));
  });
}
