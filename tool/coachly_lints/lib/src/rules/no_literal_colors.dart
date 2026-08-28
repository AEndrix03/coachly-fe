import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta `Color(0x…)` e `Colors.*` fuori dai file di token.
///
/// Implementa `docs/development/09-design-tokens.md`. È la regola che
/// `AGENTS.md` dichiarava obbligatoria da mesi e che il codice violava 216
/// volte: senza un lint, non era una regola.
class NoLiteralColors extends DartLintRule {
  const NoLiteralColors() : super(code: _code);

  static const _code = LintCode(
    name: 'no_literal_colors',
    problemMessage:
        'Colore letterale nel codice di prodotto. '
        'Usa un token semantico: context.colors.<ruolo>.',
    correctionMessage:
        'I colori letterali sono ammessi solo in lib/design_system/tokens/. '
        'Se il ruolo che ti serve non esiste, aggiungilo ai token: non usare '
        'un letterale "per ora". Vedi docs/development/09-design-tokens.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isTokenFile(resolver.path)) return;

    // Color(0xFF…), Color.fromARGB(1, 2, 3), …
    //
    // Solo con argomenti **letterali**: `Color(int.parse(hex))` costruisce un
    // colore da un dato, non è una scelta di design, e segnalarlo renderebbe
    // la regola inaffidabile.
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name2.lexeme != 'Color') return;
      final args = node.argumentList.arguments;
      if (args.isEmpty) return;
      final allLiteral = args.every((arg) => arg is IntegerLiteral);
      if (allLiteral) {
        reporter.atNode(node, _code);
      }
    });

    // Colors.red, Colors.grey.shade300, …
    //
    // `Colors.transparent` è escluso di proposito: non è una scelta di
    // design, è l'assenza di colore. Segnalarlo produrrebbe solo rumore e
    // spingerebbe a disattivare la regola.
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name != 'Colors') return;
      if (node.identifier.name == 'transparent') return;
      reporter.atNode(node, _code);
    });
  }
}
