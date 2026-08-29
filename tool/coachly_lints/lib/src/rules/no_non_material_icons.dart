import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Vieta i pack di icone diversi da Material.
///
/// ADR-003: tre pack per la stessa responsabilità significavano tre stili di
/// tratto nella stessa schermata e ~2 MB di font inutilizzati. La regola
/// esiste perché il quarto pack entra sempre dalla stessa porta — "solo per
/// questa icona".
class NoNonMaterialIcons extends DartLintRule {
  const NoNonMaterialIcons() : super(code: _code);

  static const _bannedPackages = <String>{
    'ionicons',
    'lucide_icons_flutter',
    'lucide_icons',
    'font_awesome_flutter',
    'cupertino_icons',
  };

  static const _code = LintCode(
    name: 'no_non_material_icons',
    problemMessage: 'Pack di icone non Material (ADR-003).',
    correctionMessage:
        'Usa Material Icons. Se manca il glifo che ti serve, la scelta giusta '
        'è un asset SVG nel design system, non un secondo pack: '
        'docs/development/12-iconography.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isGenerated(resolver.path)) return;

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      if (_bannedPackages.any((p) => uri.startsWith('package:' + p + '/'))) {
        reporter.atNode(node, _code);
      }
    });

    // `package:flutter/cupertino.dart` non e' vietato: espone anche
    // `CupertinoPage`, che e' una transizione, non un'icona. Vietato e' il
    // glifo.
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name == 'CupertinoIcons') reporter.atNode(node, _code);
    });
  }
}
