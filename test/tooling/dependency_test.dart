import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `docs/development/20-conventions-and-enforcement.md`: nessuna dipendenza
/// dichiarata e non usata.
///
/// Non è igiene: `lucide_icons_flutter`, `flutter_staggered_animations`,
/// `lottie`, `glass_kit`, `flutter_hooks`, `gap`, `collection`, `async` e
/// `flutter_ringtone_player` sono entrate una alla volta e sono rimaste per
/// mesi con zero utilizzi. Ognuna era un invito a introdurre una seconda
/// tecnologia per una responsabilità che ne aveva già una
/// (`01-principles.md`, principio 3).
///
/// Dipendenze usate solo tramite plugin di piattaforma, generatori o asset
/// non compaiono in un `import`: vanno dichiarate qui con il **motivo**, non
/// tolte dal controllo.
const _noDartImportButRequired = <String, String>{
  'flutter': 'SDK',
  'flutter_localizations': 'delegati caricati da gen_l10n',
  'flutter_appauth': 'plugin di piattaforma, usato via AppAuth in auth',
  'flutter_secure_storage': 'plugin di piattaforma',
  'shared_preferences': 'plugin di piattaforma',
};

Set<String> _declaredDependencies() {
  final lines = File('pubspec.yaml').readAsLinesSync();
  final deps = <String>{};
  var inDeps = false;
  for (final line in lines) {
    if (line.startsWith('dependencies:')) {
      inDeps = true;
      continue;
    }
    if (inDeps && line.isNotEmpty && !line.startsWith(' ')) break;
    if (!inDeps) continue;
    final match = RegExp(r'^  ([a-z0-9_]+):').firstMatch(line);
    if (match != null) deps.add(match.group(1)!);
  }
  return deps;
}

Set<String> _importedPackages() {
  final imported = <String>{};
  final pattern = RegExp(r"""import\s+'package:([a-z0-9_]+)/""");
  for (final dir in ['lib', 'test', 'tool']) {
    final root = Directory(dir);
    if (!root.existsSync()) continue;
    for (final file in root.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      for (final match in pattern.allMatches(file.readAsStringSync())) {
        imported.add(match.group(1)!);
      }
    }
  }
  return imported;
}

void main() {
  test('nessuna dipendenza dichiarata e non usata', () {
    final declared = _declaredDependencies();
    final imported = _importedPackages();
    final unused =
        declared
            .difference(imported)
            .difference(_noDartImportButRequired.keys.toSet())
            .toList()
          ..sort();

    expect(
      unused,
      isEmpty,
      reason:
          'Dipendenze in pubspec.yaml senza un solo import: $unused.\n'
          'O si usano, o si tolgono, o si aggiungono a '
          '`_noDartImportButRequired` con il motivo per cui non compaiono in '
          'un import.',
    );
  });

  test('le eccezioni dichiarate esistono ancora in pubspec', () {
    final declared = _declaredDependencies();
    final stale = _noDartImportButRequired.keys
        .where((name) => !declared.contains(name))
        .toList();

    // Impedisce che la lista delle eccezioni sopravviva alle dipendenze che
    // giustificava, diventando una spiegazione di qualcosa che non c'e' piu'.
    expect(stale, isEmpty, reason: 'Eccezioni orfane: $stale');
  });
}
