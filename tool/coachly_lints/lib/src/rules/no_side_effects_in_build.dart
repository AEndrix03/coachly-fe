import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta i side effect nel `build()` di un Notifier.
///
/// `Future.microtask(load)` dentro `build()` è l'anti-pattern che
/// `docs/development/03-state-riverpod.md` vieta: `AsyncNotifier` esiste
/// esattamente per questo e gestisce loading ed errore senza modellarli a mano.
class NoSideEffectsInBuild extends DartLintRule {
  const NoSideEffectsInBuild() : super(code: _code);

  static const _code = LintCode(
    name: 'no_side_effects_in_build',
    problemMessage:
        'Side effect nella costruzione dello stato di un Notifier.',
    correctionMessage:
        'Usa AsyncNotifier: espone AsyncLoading/AsyncData/AsyncError senza '
        'flag scritti a mano. Vedi docs/development/03-state-riverpod.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isGenerated(resolver.path) || isTest(resolver.path)) return;

    context.registry.addMethodDeclaration((node) {
      if (node.name.lexeme != 'build') return;

      node.body.visitChildren(_SideEffectVisitor(reporter, _code));
    });
  }
}

class _SideEffectVisitor extends RecursiveAstVisitor<void> {
  _SideEffectVisitor(this._reporter, this._code);

  final ErrorReporter _reporter;
  final LintCode _code;

  static const _forbidden = {'microtask', 'delayed', 'unawaited'};

  /// Non si scende nelle closure: un `unawaited(...)` dentro un callback di
  /// `ref.listen` è legittimo, il divieto riguarda i side effect **diretti**
  /// della costruzione dello stato.
  @override
  void visitFunctionExpression(FunctionExpression node) {}

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final name = node.methodName.name;
    final target = node.target;

    final isFutureSideEffect =
        _forbidden.contains(name) &&
        (target is SimpleIdentifier && target.name == 'Future' ||
            name == 'unawaited');

    if (isFutureSideEffect) {
      _reporter.atNode(node, _code);
    }
    super.visitMethodInvocation(node);
  }
}
