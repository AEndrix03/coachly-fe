import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta la generazione di identificatori fuori da `core/ids/`.
///
/// Gli id di outbox viaggiano come `Idempotency-Key`: un reinvio dopo un
/// timeout ambiguo è sicuro **solo** se l'id è davvero unico e stabile. Il
/// repository ha già avuto un `_generateUuidV4()` scritto a mano con
/// `Random.secure()` mentre `uuid` era già una dipendenza.
/// Vedi `docs/development/05-sync-and-offline.md`.
class NoManualUuid extends DartLintRule {
  const NoManualUuid() : super(code: _code);

  static const _code = LintCode(
    name: 'no_manual_uuid',
    problemMessage: 'Generazione di id fuori da core/ids/.',
    correctionMessage:
        'Usa IdGenerator di core/ids. Gli id di outbox sono chiavi di '
        'idempotenza: due implementazioni significano due garanzie diverse.',
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
    if (path.replaceAll(r'\', '/').contains('/lib/core/ids/')) return;

    // `import 'package:uuid/uuid.dart'` fuori da core/ids.
    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri != null && uri.startsWith('package:uuid/')) {
        reporter.atNode(node, _code);
      }
    });

    // `Random.secure()` usato per costruire un identificatore a mano.
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name2.lexeme == 'Random' &&
          node.constructorName.name?.name == 'secure') {
        reporter.atNode(node, _code);
      }
    });
  }
}
