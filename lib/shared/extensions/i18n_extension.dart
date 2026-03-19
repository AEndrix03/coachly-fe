import 'package:flutter/material.dart';

extension I18nExtension on Map<String, String> {
  String fromI18n(Locale locale) {
    if (isEmpty) {
      return '';
    }

    final normalized = <String, String>{};
    for (final entry in entries) {
      final key = entry.key.toLowerCase().replaceAll('-', '_').trim();
      final value = entry.value.trim();
      if (value.isNotEmpty) {
        normalized[key] = value;
      }
    }

    if (normalized.isEmpty) {
      return '';
    }

    final languageCode = locale.languageCode.toLowerCase();
    final countryCode = locale.countryCode?.toLowerCase();
    final fullLocaleKey = countryCode != null && countryCode.isNotEmpty
        ? '${languageCode}_$countryCode'
        : null;

    final candidates = <String>[
      if (fullLocaleKey != null) fullLocaleKey,
      languageCode,
      'en',
      'en_us',
      'en_en',
    ];

    for (final key in candidates) {
      final resolved = normalized[key];
      if (resolved != null && resolved.isNotEmpty) {
        return resolved;
      }
    }

    return normalized.values.first;
  }
}
