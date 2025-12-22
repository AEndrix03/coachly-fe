import 'package:coachly/core/sync/local_database_service.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Language extends _$Language {
  @override
  Locale build() {
    final db = LocalDatabaseService();
    String? languageCode = db.settings.get('language');

    if (languageCode == null) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      languageCode = '${deviceLocale.languageCode}_${deviceLocale.countryCode}';
      if (languageCode == 'en_US') {
        languageCode = 'en_EN'; // Use en_EN instead of en_US as default fallback for consistency
      } else if (languageCode == 'it_IT') {
        // Keep it_IT
      } else {
        languageCode = 'it_IT'; // Default to it_IT if device locale is neither en_US nor it_IT
      }
    }

    final parts = languageCode.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    // Fallback to default if languageCode format is invalid
    return const Locale('it', 'IT');
  }

  Future<void> setLanguage(Locale locale) async {
    final db = LocalDatabaseService();
    await db.settings.put('language', '${locale.languageCode}_${locale.countryCode}');
    state = locale;
  }
}
