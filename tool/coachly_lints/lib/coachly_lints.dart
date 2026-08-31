import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/rules/layer_imports.dart';
import 'src/rules/no_go_to_tab.dart';
import 'src/rules/no_hardcoded_strings.dart';
import 'src/rules/no_literal_colors.dart';
import 'src/rules/no_literal_text_style.dart';
import 'src/rules/no_manual_uuid.dart';
import 'src/rules/no_non_material_icons.dart';
import 'src/rules/no_raw_datetime_now.dart';
import 'src/rules/no_side_effects_in_build.dart';

/// Lint che rendono verificabili le regole di `docs/development/`.
///
/// Il principio guida della cartella: *ogni regola deve essere verificabile
/// automaticamente oppure dichiarata esplicitamente come non verificabile*.
/// Questi sono i lint che coprono la prima categoria.
///
/// Le regole partono in `warning` su tutto il repository. Vanno portate a
/// `error` sui soli file toccati da un PR: attivarle come errore ovunque il
/// primo giorno finirebbe in un `ignore_for_file` generalizzato, cioè il
/// fallimento di `AGENTS.md` ripetuto in scala.
PluginBase createPlugin() => _CoachlyLints();

class _CoachlyLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => const [
    // docs/development/09-design-tokens.md
    NoLiteralColors(),
    NoLiteralTextStyle(),
    // docs/development/13-i18n.md
    NoHardcodedStrings(),
    // docs/development/12-iconography.md — ADR-003
    NoNonMaterialIcons(),
    // docs/development/05-sync-and-offline.md
    NoManualUuid(),
    // docs/development/08-routing-navigation.md — R1
    NoGoToTab(),
    // docs/development/19-testing.md
    NoRawDateTimeNow(),
    // docs/development/03-state-riverpod.md
    NoSideEffectsInBuild(),
    // docs/development/01-principles.md — dependency rules
    NoDataLayerInPresentation(),
    NoMaterialInApplication(),
    NoCrossFeaturePresentation(),
    NoFeaturesInCore(),
    NoDataSourceOutsideRepository(),
  ];
}
