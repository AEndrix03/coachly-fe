import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Language extends _$Language {
  @override
  Locale build() {
    final db = LocalDatabaseService();
    final storedLanguage = db.settings.get('language') as String?;
    final parsedStoredLocale = _parseLocale(storedLanguage);
    if (parsedStoredLocale != null) {
      return parsedStoredLocale;
    }
    return AppStrings.defaultLocale;
  }

  Future<void> setLanguage(Locale locale) async {
    final normalizedLocale = AppStrings.normalizeLocale(locale);
    final db = LocalDatabaseService();
    await db.settings.put('language', normalizedLocale.languageCode);
    state = normalizedLocale;
  }

  Locale? _parseLocale(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    final normalizedRaw = rawValue.trim().toLowerCase().replaceAll('-', '_');
    final languageCode = normalizedRaw.split('_').first;
    if (languageCode == 'it') {
      return const Locale('it');
    }
    if (languageCode == 'en') {
      return const Locale('en');
    }
    return null;
  }
}
