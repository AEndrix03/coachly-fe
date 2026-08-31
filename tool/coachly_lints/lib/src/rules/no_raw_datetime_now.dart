import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta `DateTime.now()` fuori da `core/time/`.
///
/// Non è pulizia: streak, conteggi settimanali e backoff sono **correttezza di
/// dominio**, e con `DateTime.now()` sparso in 60 punti non sono testabili.
/// Vedi `docs/development/19-testing.md`.
class NoRawDateTimeNow extends DartLintRule {
  const NoRawDateTimeNow() : super(code: _code);

  static const _code = LintCode(
    name: 'no_raw_datetime_now',
    problemMessage:
        'DateTime.now() rende il codice non testabile e dipendente '
        "dall'orologio di sistema.",
    correctionMessage:
        'Usa il Clock iniettabile di core/time. Casi che devono restare '
        'testabili: allenamento a cavallo della mezzanotte, cambio di fuso, '
        'ora legale, streak interrotto.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final path = resolver.path;
    if (isGenerated(path) || isTest(path)) return;
    if (path.replaceAll(r'\', '/').contains('/lib/core/time/')) return;

    // `DateTime.now()` e' un costruttore con nome, non una chiamata di
    // metodo: nell'AST e' una `InstanceCreationExpression`. Ascoltare solo
    // `addMethodInvocation` — come faceva la prima versione di questa regola —
    // significa non trovare mai niente, ed e' esattamente quello che e'
    // successo: il lint riportava zero violazioni con venti `DateTime.now()`
    // nel codice. Una regola che non puo' fallire non e' una regola.
    context.registry.addInstanceCreationExpression((node) {
      final type = node.constructorName.type.name2.lexeme;
      final name = node.constructorName.name?.name;
      if (type == 'DateTime' && name == 'now') {
        reporter.atNode(node, _code);
      }
    });

    // Resta per i casi in cui `now` arriva da un alias o da un'estensione.
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'now') return;
      final target = node.target;
      if (target is SimpleIdentifier && target.name == 'DateTime') {
        reporter.atNode(node, _code);
      }
    });
  }
}
