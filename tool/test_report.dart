import 'dart:convert';
import 'dart:io';

/// Estrae dal reporter JSON di `flutter test` i nomi dei test in un dato esito.
///
/// Serve a `tool/check_tests.sh`: il reporter testuale non è parsabile in modo
/// affidabile (i messaggi di errore contengono righe che sembrano risultati),
/// mentre quello JSON lo è. Vedi `docs/development/20-conventions-and-enforcement.md`.
void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('uso: dart run tool/test_report.dart <file.json> <esito>');
    exit(64);
  }
  final wanted = args[1];
  final names = <int, String>{};
  final suites = <int, String>{};
  final testSuite = <int, int>{};
  final out = <String>{};

  for (final line in File(args[0]).readAsLinesSync()) {
    if (!line.startsWith('{')) continue;
    final Object? decoded;
    try {
      decoded = jsonDecode(line);
    } on FormatException {
      continue;
    }
    if (decoded is! Map<String, dynamic>) continue;

    switch (decoded['type']) {
      case 'suite':
        final suite = decoded['suite'] as Map<String, dynamic>;
        suites[suite['id'] as int] = _relative(suite['path'] as String);
      case 'testStart':
        final test = decoded['test'] as Map<String, dynamic>;
        final id = test['id'] as int;
        names[id] = test['name'] as String;
        testSuite[id] = test['suiteID'] as int;
      case 'testDone':
        if (decoded['hidden'] == true) break;
        final id = decoded['testID'] as int;
        final result = decoded['result'] as String;
        final outcome = result == 'success' ? 'passed' : 'failed';
        if (outcome != wanted) break;
        final suite = suites[testSuite[id]] ?? '?';
        out.add('$suite :: ${names[id]}');
    }
  }

  final sorted = out.toList()..sort();
  stdout.writeln(sorted.join('\n'));
}

String _relative(String path) {
  final normalized = path.replaceAll(r'\', '/');
  final index = normalized.indexOf('/test/');
  return index < 0 ? normalized : normalized.substring(index + 1);
}
