import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../paths.dart';

/// Base delle regole sugli import: quasi tutte le dependency rules di
/// `docs/development/01-principles.md` si riducono a "chi sono io" e
/// "chi sto importando".
abstract class _ImportRule extends DartLintRule {
  const _ImportRule(LintCode code) : super(code: code);

  /// `true` se il file va analizzato.
  bool appliesTo(String path);

  /// `true` se l'import è vietato per questo file.
  bool isForbidden(String importUri, String path);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final path = resolver.path;
    if (isGenerated(path) || isTest(path) || !appliesTo(path)) return;

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      if (isForbidden(uri, path)) {
        reporter.atNode(node, code);
      }
    });
  }
}

/// D1 — la presentazione non conosce database, rete né repository.
class NoDataLayerInPresentation extends _ImportRule {
  const NoDataLayerInPresentation() : super(_code);

  static const _code = LintCode(
    name: 'no_data_layer_in_presentation',
    problemMessage:
        'Un widget non accede a rete, database o repository direttamente.',
    correctionMessage:
        'Passa da un controller in application/. '
        'Vedi la dependency rule D1 in docs/development/01-principles.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  bool appliesTo(String path) => isPresentation(path);

  @override
  bool isForbidden(String uri, String path) =>
      uri.contains('core/network/') ||
      uri.contains('core/database/') ||
      uri.contains('/data/') ||
      uri.startsWith('package:drift') ||
      uri.startsWith('package:dio') ||
      uri.startsWith('package:http');
}

/// D2 — sotto la presentazione, Flutter non esiste.
///
/// La regola nasce sui controller, ma il confine e' piu' largo: valeva gia'
/// per `data/` e `domain/`, e non era controllata li'. Il risultato era che
/// tre file del data layer importavano tutto Material per usare `Locale`, che
/// vive in `dart:ui` — un import da mezzo framework per un tipo di venti
/// righe, in codice che deve poter girare in un test senza binding Flutter.
class NoMaterialInApplication extends _ImportRule {
  const NoMaterialInApplication() : super(_code);

  static const _code = LintCode(
    name: 'no_material_in_application',
    problemMessage: 'Sotto la presentazione non si importa Flutter Material.',
    correctionMessage:
        'Se ti serve solo Locale, importa `dart:ui` show Locale. Se ti serve '
        'altro (Color, Widget), o appartiene alla presentazione o va '
        'modellato nel dominio. '
        'Vedi la dependency rule D2 in docs/development/01-principles.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  bool appliesTo(String path) =>
      isApplication(path) || isDataLayer(path) || isInLayer(path, 'domain');

  @override
  bool isForbidden(String uri, String path) =>
      uri == 'package:flutter/material.dart' ||
      uri == 'package:flutter/cupertino.dart';
}

/// D4 — nessuna feature entra nella presentazione di un'altra.
class NoCrossFeaturePresentation extends _ImportRule {
  const NoCrossFeaturePresentation() : super(_code);

  static const _code = LintCode(
    name: 'no_cross_feature_presentation',
    problemMessage:
        "Import della presentazione di un'altra feature: le feature si "
        'accoppiano solo attraverso il design system o il data layer.',
    correctionMessage:
        'Se il widget serve a due feature, sale in design_system/components/. '
        'Vedi la dependency rule D4 in docs/development/01-principles.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  bool appliesTo(String path) => featureOf(path) != null;

  @override
  bool isForbidden(String uri, String path) {
    final marker = 'features/';
    final index = uri.indexOf(marker);
    if (index == -1) return false;
    final rest = uri.substring(index + marker.length);
    final slash = rest.indexOf('/');
    if (slash == -1) return false;
    final importedFeature = rest.substring(0, slash);
    if (importedFeature == featureOf(path)) return false;
    return rest.contains('/presentation/') ||
        rest.contains('/widgets/') ||
        rest.contains('/pages/');
  }
}

/// D5 — `core/` non conosce le feature.
class NoFeaturesInCore extends _ImportRule {
  const NoFeaturesInCore() : super(_code);

  static const _code = LintCode(
    name: 'no_features_in_core',
    problemMessage: 'core/ non può dipendere da una feature.',
    correctionMessage:
        'Se serve a una feature sola, non appartiene a core/. '
        'Vedi la dependency rule D5 e la regola sui contenuti di core/ in '
        'docs/development/01-principles.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  bool appliesTo(String path) => isCore(path);

  @override
  bool isForbidden(String uri, String path) => uri.contains('features/');
}

/// D6 — solo i repository parlano con i data source.
///
/// È la regola che impedisce il ritorno del problema che questa architettura
/// nasce per risolvere: due percorsi paralleli verso lo stesso endpoint, uno
/// con cache e uno senza.
class NoDataSourceOutsideRepository extends _ImportRule {
  const NoDataSourceOutsideRepository() : super(_code);

  static const _code = LintCode(
    name: 'no_data_source_outside_repository',
    problemMessage:
        'Solo un repository può usare un data source o un servizio di rete.',
    correctionMessage:
        'Esponi il dato attraverso il repository dell\'aggregato. '
        'Vedi la dependency rule D6 in docs/development/01-principles.md.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  bool appliesTo(String path) =>
      !isRepository(path) && !isDataLayer(path) && !isCompositionRoot(path);

  @override
  bool isForbidden(String uri, String path) =>
      uri.contains('/data/remote/') ||
      uri.contains('/data/local/') ||
      uri.contains('_data_source.dart');
}
