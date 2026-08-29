import 'dart:convert';
import 'dart:io';

import 'package:coachly/shared/i18n/arb_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keys that exist in the ARB files but have no counterpart in the legacy
/// const map of `app_strings.dart`, because the map cannot express them.
const _icuOnlyKeys = <String>{'setsCompletedCount', 'exercisesInWorkoutCount'};

Map<String, String> _messages(String path) {
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final e in raw.entries)
      if (!e.key.startsWith('@')) e.key: e.value as String,
  };
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
    // arbBridge maps every legacy dotted key to the generated member of the
    // same message, so the ARB may only hold as many messages as the bridge
    // resolves, plus the ICU-only additions declared above.
    expect(
      en.length,
      arbBridge.length + _icuOnlyKeys.length,
      reason: 'ARB contains messages that nothing resolves',
    );
    for (final k in _icuOnlyKeys) {
      expect(en.containsKey(k), isTrue);
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
