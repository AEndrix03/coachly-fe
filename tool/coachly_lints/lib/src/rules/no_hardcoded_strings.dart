import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta le stringhe letterali visibili all'utente.
///
/// Vedi `docs/development/13-i18n.md`. Oggi il canale è `context.tr('chiave')`;
/// diventerà `context.l10n.chiave` con la migrazione ad ARB (ADR-002), e questa
/// regola non cambia.
class NoHardcodedStrings extends DartLintRule {
  const NoHardcodedStrings() : super(code: _code);

  static const _code = LintCode(
    name: 'no_hardcoded_strings',
    problemMessage: "Stringa visibile all'utente scritta nel codice.",
    correctionMessage:
        "Aggiungi una chiave in lib/shared/i18n/app_strings.dart per "
        "**entrambe** le lingue e usa context.tr('chiave').",
    errorSeverity: ErrorSeverity.WARNING,
  );

  /// Widget il cui primo argomento posizionale è testo mostrato all'utente.
  static const _textWidgets = {'Text', 'SelectableText'};

  /// Parametri nominati che finiscono a schermo.
  static const _textParams = {
    'label',
    'labelText',
    'hintText',
    'helperText',
    'errorText',
    'title',
    'subtitle',
    'message',
    'tooltip',
    'semanticLabel',
  };

  /// Stringhe che non sono lingua: separatori, segnaposto, unità.
  static bool _isNotLanguage(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 3) return true;
    // Nessuna lettera: trattini, punti di sospensione, numeri, simboli.
    return !RegExp(r'[a-zA-ZÀ-ÿ]{3}').hasMatch(trimmed);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final path = resolver.path;
    if (isGenerated(path) || isTest(path)) return;

    final normalized = path.replaceAll(r'\', '/');
    // Il catalogo delle traduzioni è fatto di stringhe letterali per natura.
    if (normalized.contains('/lib/shared/i18n/')) return;
    // Sotto il data layer non esiste testo per l'utente: il `message` di un
    // Failure o di una ApiResponse è diagnostico
    // (`docs/development/07-errors-and-feedback.md`). Segnalarlo renderebbe la
    // regola inaffidabile, e una regola inaffidabile viene disattivata.
    if (isDataLayer(normalized) || normalized.contains('/lib/core/network/')) {
      return;
    }

    void check(Expression? expression) {
      if (expression is! SimpleStringLiteral) return;
      if (_isNotLanguage(expression.value)) return;
      reporter.atNode(expression, _code);
    }

    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.name2.lexeme;
      final args = node.argumentList.arguments;

      if (_textWidgets.contains(typeName)) {
        final positional = args.where((a) => a is! NamedExpression).firstOrNull;
        check(positional);
      }

      for (final arg in args) {
        if (arg is NamedExpression &&
            _textParams.contains(arg.name.label.name)) {
          check(arg.expression);
        }
      }
    });
  }
}
