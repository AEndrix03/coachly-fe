import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/auth/providers/user_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:coachly/shared/widgets/headers/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
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
            badgeIcon: Ionicons.person_circle_outline,
            badgeLabel: context.tr('profile.profile'),
            title: fullName.isEmpty
                ? context.tr('profile.your_profile')
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
                    icon: Ionicons.settings_outline,
                    color: const Color(0xFF2196F3),
                    title: context.tr('profile.preferences'),
                    child: _buildLanguageSetting(context, ref),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Ionicons.information_circle_outline,
                    color: const Color(0xFF9C27B0),
                    title: context.tr('profile.app_section'),
                    child: _buildAppInfo(context),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
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
              color: Colors.white.withValues(alpha: 0.25),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr('profile.member'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.80),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
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
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildLanguageSetting(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final currentLocale =
        Localizations.maybeLocaleOf(context) ?? AppStrings.defaultLocale;

    return Row(
      children: [
        Icon(
          Ionicons.language_outline,
          color: Colors.white.withValues(alpha: 0.60),
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          context.tr('common.language'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        ShadSelect<Locale>(
          placeholder: Text(
            AppStrings.languageDisplayName(
              language,
              displayLocale: currentLocale,
            ),
            style: const TextStyle(color: Colors.white, fontSize: 13),
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
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Column(
      children: [
        _infoRow(label: context.tr('common.version'), value: '1.0.0 MVP'),
        Divider(color: Colors.white.withValues(alpha: 0.07), height: 24),
        _infoRow(label: context.tr('common.build'), value: 'alpha'),
      ],
    );
  }

  Widget _infoRow({required String label, required String value}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.50),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final confirm = await showAppConfirmationDialog(
          context,
          title: context.tr('profile.logout_title'),
          content: context.tr('profile.logout_content'),
          confirmLabel: context.tr('profile.logout_confirm'),
          destructive: true,
          icon: Ionicons.log_out_outline,
        );
        if (confirm == true) {
          ref.read(authProvider.notifier).logout();
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFFFF5252).withValues(alpha: 0.10),
          border: Border.all(
            color: const Color(0xFFFF5252).withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.log_out_outline,
              color: const Color(0xFFFF5252).withValues(alpha: 0.85),
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              context.tr('profile.logout'),
              style: TextStyle(
                color: const Color(0xFFFF5252).withValues(alpha: 0.85),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
