import 'package:flutter/material.dart';

extension I18nExtension on Map<String, String> {
  String fromI18n(Locale locale) {
    final languageCodeWithCountry =
        '${locale.languageCode}_${locale.countryCode}';
    if (this[languageCodeWithCountry] != null) {
      return this[languageCodeWithCountry]!;
    }
    if (this['en_EN'] != null) {
      return this['en_EN']!;
    }
    if (this['en_US'] != null) {
      return this['en_US']!;
    }
    if (values.isNotEmpty) {
      return values.first;
    }
    return ''; // Fallback to an empty string if map is empty
  }
}
