import 'dart:convert';
import 'dart:io';

import 'package:coachly/shared/i18n/arb_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keys that exist in the ARB files but have no counterpart in the legacy
/// const map of `app_strings.dart`.
///
/// Two reasons land a key here. The first two cannot be expressed by the
/// legacy map at all (plurals). The rest are **messages born after the ARB
/// migration**: a new string has no legacy counterpart by definition, and
/// adding one to `arb_bridge.dart` just to satisfy a count would grow the
/// bridge that ADR-002 exists to delete.
const _icuOnlyKeys = <String>{
  'setsCompletedCount',
  'exercisesInWorkoutCount',
  // Mostrato invece dell'id quando il catalogo locale non ha l'esercizio.
  'exerciseNamePlaceholder',
  // Titolo di ripiego per una scheda senza titolo.
  'workoutTitlePlaceholder',
  // Metadati della scheda di oggi, in home.
  'homeTodayTrainingMetadata',
  // Conferma di uscita dall'allenamento attivo.
  'workoutActiveExitTitle',
  'workoutActiveExitBody',
  'workoutActiveSaveAndExit',
  'workoutActiveKeepTraining',
};

Map<String, String> _messages(String path) {
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final e in raw.entries)
      if (!e.key.startsWith('@')) e.key: e.value as String,
  };
}

/// I messaggi ARB che il ponte sa raggiungere.
///
/// Si leggono dal sorgente perche' `arbBridge` mappa chiavi puntate a
/// *funzioni*: a runtime i nomi dei membri generati non sono ispezionabili.
Set<String> _bridgedMessages() {
  final src = File('lib/shared/i18n/arb_bridge.dart').readAsStringSync();
  return RegExp(
    r'l10n\.([A-Za-z0-9_]+)',
  ).allMatches(src).map((m) => m.group(1)!).toSet();
}

Set<String> _legacyKeys() {
  final src = File('lib/shared/i18n/app_strings.dart').readAsStringSync();
  final body = src.substring(src.indexOf('_values = {'));
  return RegExp(
    r"^\s{4}'([a-z0-9_.]+)':",
    multiLine: true,
  ).allMatches(body).map((m) => m.group(1)!).toSet();
}

void main() {
  late Map<String, String> en;
  late Map<String, String> it;

  setUpAll(() {
    en = _messages('lib/l10n/app_en.arb');
    it = _messages('lib/l10n/app_it.arb');
  });

  test('en and it declare exactly the same keys', () {
    expect(
      en.keys.toSet().difference(it.keys.toSet()),
      isEmpty,
      reason: 'keys missing from app_it.arb',
    );
    expect(
      it.keys.toSet().difference(en.keys.toSet()),
      isEmpty,
      reason: 'keys missing from app_en.arb',
    );
  });

  test('no empty translation on either side', () {
    for (final entry in {...en, ...it}.entries) {
      expect(en[entry.key], isNotEmpty, reason: 'empty en for ${entry.key}');
      expect(it[entry.key], isNotEmpty, reason: 'empty it for ${entry.key}');
    }
  });

  test('every legacy AppStrings key is mirrored in the ARB', () {
    final legacy = _legacyKeys();
    expect(legacy, isNotEmpty);
    final missing = legacy.where((k) => !arbBridge.containsKey(k)).toList();
    expect(
      missing,
      isEmpty,
      reason: 'keys added to app_strings.dart but never migrated to ARB',
    );
  });

  test('no orphan ARB key: every message is reachable', () {
    // Confronta **insiemi**, non conteggi.
    //
    // Prima confrontava `en.length` con `arbBridge.length + icuOnly.length`, e
    // un numero non dice mai quale chiave manca: il messaggio di errore era
    // «Expected: <681> Actual: <685>», da cui si ricava che qualcosa non torna
    // e nient'altro. Con gli insiemi il test nomina i colpevoli, che e' l'unica
    // informazione con cui si corregge.
    final bridged = _bridgedMessages();
    final orphans = en.keys
        .where((key) => !bridged.contains(key) && !_icuOnlyKeys.contains(key))
        .toList();

    expect(
      orphans,
      isEmpty,
      reason:
          'Messaggi ARB che nessuno risolve: $orphans. '
          'Se la chiave e nuova (nessun corrispondente legacy) aggiungila a '
          '`_icuOnlyKeys`; se sostituisce una chiave puntata di '
          '`app_strings.dart`, aggiungi la voce in `arb_bridge.dart`.',
    );
    expect(bridged, isNotEmpty, reason: 'regex sul ponte da rivedere');
    expect(arbBridge, isNotEmpty);

    for (final k in _icuOnlyKeys) {
      expect(
        en.containsKey(k),
        isTrue,
        reason: '`$k` dichiarata nel test ma non piu presente nell ARB',
      );
    }
  });

  test('placeholders are consistent between en and it', () {
    final re = RegExp(r'\{(\w+)[,}]');
    for (final key in en.keys) {
      expect(
        re.allMatches(it[key]!).map((m) => m.group(1)).toSet(),
        re.allMatches(en[key]!).map((m) => m.group(1)).toSet(),
        reason: 'placeholder mismatch on $key',
      );
    }
  });
}
