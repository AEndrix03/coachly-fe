import 'package:coachly/l10n/app_localizations.dart';
import 'package:coachly/l10n/app_localizations_en.dart';
import 'package:coachly/l10n/app_localizations_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('both locales are supported', () {
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const [Locale('en'), Locale('it')]),
    );
  });

  test('ICU plural resolves in english', () {
    final l10n = AppLocalizationsEn();
    expect(l10n.setsCompletedCount(0), 'No sets completed');
    expect(l10n.setsCompletedCount(1), '1 set completed');
    expect(l10n.setsCompletedCount(4), '4 sets completed');
  });

  test('ICU plural resolves in italian', () {
    final l10n = AppLocalizationsIt();
    expect(l10n.exercisesInWorkoutCount(0), 'Nessun esercizio');
    expect(l10n.exercisesInWorkoutCount(1), '1 esercizio');
    expect(l10n.exercisesInWorkoutCount(7), '7 esercizi');
  });

  test('a migrated key keeps its legacy text', () {
    expect(AppLocalizationsEn().commonAppName, 'Coachly');
  });
}
