import 'dart:async';

import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

/// Lingua dell'interfaccia.
///
/// È una **preferenza banale**: sta in `SharedPreferencesAsync`, non in Drift
/// (`docs/development/04-data-layer.md`, "Cosa non sta in Drift"). Perderla
/// significa ripartire dalla lingua di default, che è esattamente il
/// comportamento del primo avvio.
@riverpod
class Language extends _$Language {
  static const String preferenceKey = 'language';

  @visibleForTesting
  static SharedPreferencesAsync preferences = SharedPreferencesAsync();

  @override
  Locale build() {
    // La lettura delle preferenze è asincrona: si parte dalla lingua di
    // default e si riallinea appena il valore salvato è disponibile. Vedi
    // `Attriti` del task: non è una `Future.microtask` di caricamento dati,
    // è l'idratazione di una preferenza che ha un default valido.
    unawaited(_restore());
    return AppStrings.defaultLocale;
  }

  Future<void> _restore() async {
    final stored = await preferences.getString(preferenceKey);
    final parsed = _parseLocale(stored);
    if (parsed == null || !ref.mounted || parsed == state) return;
    state = parsed;
  }

  Future<void> setLanguage(Locale locale) async {
    final normalizedLocale = AppStrings.normalizeLocale(locale);
    state = normalizedLocale;
    await preferences.setString(preferenceKey, normalizedLocale.languageCode);
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

// ─── Local AI Settings ───────────────────────────────────────────────────────
