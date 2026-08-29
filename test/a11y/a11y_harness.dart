import 'package:coachly/l10n/app_localizations.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Harness condiviso dei test di accessibilità.
///
/// `docs/development/14-accessibility.md` è Costituzione e finora non aveva
/// nessuna verifica: `textScaler` non compariva nel codice, quindi la app a
/// text scaling alto non era mai stata provata da nessuno.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  Size surface = const Size(390, 844),
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  await tester.binding.setSurfaceSize(surface);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('it'),
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: CoachlyAthleteTheme.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CoachlyAthleteTheme.primary,
          brightness: Brightness.dark,
          surface: CoachlyAthleteTheme.surface,
        ),
      ),
      home: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
