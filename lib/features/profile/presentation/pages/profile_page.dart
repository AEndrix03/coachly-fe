import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/auth/application/auth_provider.dart';
import 'package:coachly/features/auth/application/user_provider.dart';
import 'package:coachly/features/user_settings/application/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:coachly/shared/widgets/headers/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final scheme = Theme.of(context).colorScheme;

    final initials = _initials(user?.firstName, user?.lastName);
    final fullName = [
      user?.firstName,
      user?.lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          PageHeader(
            badgeIcon: Icons.account_circle_outlined,
            badgeLabel: context.l10n.profileProfile,
            title: fullName.isEmpty
                ? context.l10n.profileYourProfile
                : fullName,
            bottom: _buildAvatarInHeader(context, initials),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context: context,
                    icon: Icons.settings_outlined,
                    color: scheme.primary,
                    title: context.l10n.profilePreferences,
                    child: _buildLanguageSetting(context, ref),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context: context,
                    icon: Icons.info_outline,
                    color: scheme.secondary,
                    title: context.l10n.profileAppSection,
                    child: _buildAppInfo(context),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context: context,
                    icon: Icons.fitness_center_outlined,
                    color: scheme.tertiary,
                    title: context.l10n.profileWorkoutSection,
                    child: _buildPersonalExercisesEntry(context),
                  ),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarInHeader(BuildContext context, String initials) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.onPrimaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.25),
            ),
            child: Center(
              child: Text(
                initials,
                style: context.scale.subtitleLoose.bold.copyWith(
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.profileMember,
            style: context.scale.captionLoose.medium.copyWith(
              color: scheme.onPrimaryContainer.withValues(alpha: 0.80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 15),
            ),
            const SizedBox(width: 9),
            Text(
              title,
              style: context.scale.caption.semibold.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.55),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildLanguageSetting(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final language = ref.watch(languageProvider);
    final currentLocale =
        Localizations.maybeLocaleOf(context) ?? AppStrings.defaultLocale;

    return Row(
      children: [
        Icon(Icons.language_outlined, color: scheme.onSurfaceVariant, size: 18),
        const SizedBox(width: 12),
        Text(
          context.l10n.commonLanguage,
          style: context.scale.bodyTight.medium.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const Spacer(),
        ShadSelect<Locale>(
          placeholder: Text(
            AppStrings.languageDisplayName(
              language,
              displayLocale: currentLocale,
            ),
            style: context.scale.captionLoose.copyWith(color: scheme.onSurface),
          ),
          initialValue: language,
          options: AppStrings.languageOptions.map((l) {
            return ShadOption(
              value: l,
              child: Text(
                AppStrings.languageDisplayName(l, displayLocale: currentLocale),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(languageProvider.notifier).setLanguage(value);
            }
          },
          selectedOptionBuilder: (context, value) => Text(
            AppStrings.languageDisplayName(value, displayLocale: currentLocale),
            style: context.scale.captionLoose.copyWith(color: scheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        _infoRow(
          context: context,
          label: context.l10n.commonVersion,
          value: '1.0.0 MVP',
        ),
        Divider(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
          height: 24,
        ),
        _infoRow(
          context: context,
          label: context.l10n.commonBuild,
          value: 'alpha',
        ),
      ],
    );
  }

  Widget _buildPersonalExercisesEntry(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: () => context.push('/profile/personal-exercises'),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(Icons.list_outlined, color: scheme.onSurfaceVariant, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.profilePersonalExercises,
                style: context.scale.bodyTight.medium.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          label,
          style: context.scale.bodyTight.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: context.scale.bodyTight.medium.copyWith(
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: context.l10n.profileLogout,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final confirm = await showAppConfirmationDialog(
              context,
              title: context.l10n.profileLogoutTitle,
              content: context.l10n.profileLogoutContent,
              confirmLabel: context.l10n.profileLogoutConfirm,
              destructive: true,
              icon: Icons.logout_outlined,
            );
            if (confirm != true) return;

            // `logout()` rifiuta l'uscita se l'outbox non è vuota: quei dati
            // sono l'unica copia esistente. Il rifiuto va mostrato, non
            // ingoiato — vedi docs/development/05-sync-and-offline.md.
            final auth = ref.read(authProvider.notifier);
            if (await auth.logout()) return;

            final pending = await auth.pendingSyncCount();
            if (!context.mounted) return;

            final discard = await showAppConfirmationDialog(
              context,
              title: context.l10n.profileLogoutPendingTitle,
              content: context.l10n.profileLogoutPendingContent('$pending'),
              confirmLabel: context.l10n.profileLogoutPendingConfirm,
              destructive: true,
              icon: Icons.cloud_off_outlined,
            );
            if (discard == true) {
              await auth.logout(force: true);
            }
          },
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: scheme.errorContainer.withValues(alpha: 0.55),
              border: Border.all(
                color: scheme.error.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_outlined, color: scheme.error, size: 18),
                const SizedBox(width: 10),
                Text(
                  context.l10n.profileLogout,
                  style: context.scale.bodyTight.semibold.copyWith(
                    color: scheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String? first, String? last) {
    final f = first?.isNotEmpty == true ? first![0].toUpperCase() : '';
    final l = last?.isNotEmpty == true ? last![0].toUpperCase() : '';
    return '$f$l'.isEmpty ? '?' : '$f$l';
  }
}
