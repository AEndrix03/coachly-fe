import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta `fontSize:` letterale.
///
/// Vedi `docs/development/09-design-tokens.md`. Il codice contiene 220
/// `fontSize` su 14 dimensioni diverse (9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
/// 19, 20, 22, 24…): non è una scala, è un continuo, e ogni schermata ne sceglie
/// una a caso.
///
/// La regola **non** vieta `TextStyle(...)` in blocco: `copyWith` su un token è
/// legittimo e frequente. Vieta la dimensione arbitraria, che è la decisione
/// che il design system deve possedere.
class NoLiteralTextStyle extends DartLintRule {
  const NoLiteralTextStyle() : super(code: _code);

  static const _code = LintCode(
    name: 'no_literal_text_style',
    problemMessage: 'Dimensione del testo scelta a mano.',
    correctionMessage:
        'Parti da un token: context.text.bodyM, .titleS, .label, .displayL… '
        'e se serve adattalo con copyWith(). Vedi '
        'docs/development/09-design-tokens.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final path = resolver.path;
    if (isGenerated(path) || isTest(path) || isTokenFile(path)) return;

    context.registry.addNamedExpression((node) {
      if (node.name.label.name != 'fontSize') return;
      final value = node.expression;
      if (value is IntegerLiteral || value is DoubleLiteral) {
        reporter.atNode(node, _code);
      }
    });
  }
}
