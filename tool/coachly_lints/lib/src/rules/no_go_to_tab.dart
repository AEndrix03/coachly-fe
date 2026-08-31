import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// R1 — un tab si cambia con `goBranch`, non con `go`.
///
/// La differenza non si vede provando la app una volta: `context.go('/profile')`
/// porta sul tab giusto. Si vede al ritorno, perche' con uno
/// `StatefulShellRoute` quel `go` **azzera lo stack del ramo**: chi era in
/// fondo a tre schermate del tab schede, passa al profilo e torna indietro,
/// ritrova la radice invece del punto in cui stava.
///
/// E' il divieto 14 di `.claude/rules/development.md`, ed era enunciato senza
/// che niente lo controllasse: una schermata lo aggirava gia'.
/// Vedi `docs/development/08-routing-navigation.md`.
class NoGoToTab extends DartLintRule {
  const NoGoToTab() : super(code: _code);

  /// Le radici dei rami. Sono anche in `AppTab`, ma un lint non puo'
  /// leggere l'enum del progetto che analizza: se un tab si aggiunge, si
  /// aggiunge anche qui, ed e' il motivo per cui l'elenco e' corto e visibile.
  static const _tabPaths = {'/community', '/workouts', '/profile'};

  static const _code = LintCode(
    name: 'no_go_to_tab',
    problemMessage:
        'Cambio di tab con `go`: azzera lo stack di navigazione del ramo.',
    correctionMessage:
        'Usa `context.goToTab(AppTab.<tab>)`, che passa da `goBranch`. '
        'Vedi R1 in docs/development/08-routing-navigation.md.',
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
    // Il router dichiara quei percorsi: e' il posto in cui devono comparire.
    if (path.replaceAll(r'\', '/').contains('/lib/app/')) return;

    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'go') return;
      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) return;
      final first = arguments.first;
      if (first is! SimpleStringLiteral) return;
      if (_tabPaths.contains(first.value)) reporter.atNode(node, _code);
    });
  }
}
