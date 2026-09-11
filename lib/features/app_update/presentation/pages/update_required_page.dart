import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/app_update/application/app_update_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Schermata bloccante per una versione sotto `minSupportedVersion`.
///
/// Dice due cose, in quest'ordine: che i dati **non sono persi**, e cosa fare.
/// La prima conta piu' della seconda — in una app dove gli allenamenti vivono
/// solo sul dispositivo, un muro senza spiegazioni si legge come "ho perso
/// tutto" (`docs/development/07-errors-and-feedback.md`).
class UpdateRequiredPage extends ConsumerWidget {
  const UpdateRequiredPage({super.key});

  static const String routePath = '/update-required';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final requirements = ref.watch(appUpdateRequirementsProvider);
    final isChecking = ref.watch(appUpdateProvider).isLoading;

    // Il backend puo' mandare un messaggio straordinario; quando non lo fa si
    // usa il testo tradotto del client, perche' il server non conosce la lingua.
    final serverMessage = requirements?.message ?? '';
    final body = serverMessage.isEmpty
        ? context.l10n.updateRequiredBody
        : serverMessage;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: context.spacing.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.system_update,
                  size: context.sizes.iconXl,
                  color: context.colors.surfaceAccent,
                ),
                SizedBox(height: context.spacing.xl),
                Text(
                  context.l10n.updateRequiredTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: context.spacing.md),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.spacing.xxl),
                FilledButton(
                  // Il default Material e' 40 dp di altezza, sotto il minimo di
                  // accessibilita' (`14-accessibility.md`).
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(context.sizes.touchTarget),
                  ),
                  onPressed: isChecking
                      ? null
                      : () =>
                            ref.read(appUpdateProvider.notifier).recheck(),
                  child: Text(context.l10n.updateRequiredAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
