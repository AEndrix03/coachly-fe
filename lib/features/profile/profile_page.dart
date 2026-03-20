import 'package:coachly/features/ai_coach/data/services/gemma_inference_service.dart';
import 'package:coachly/features/ai_coach/domain/models/local_ai_model.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/auth/providers/user_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:coachly/shared/widgets/headers/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                    icon: Ionicons.hardware_chip_outline,
                    color: const Color(0xFF9C27B0),
                    title: context.tr('settings.local_ai.section'),
                    child: _AiCoachSettings(),
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

// ─── AI Coach Settings Widget ─────────────────────────────────────────────────

class _AiCoachSettings extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AiCoachSettings> createState() => _AiCoachSettingsState();
}

class _AiCoachSettingsState extends ConsumerState<_AiCoachSettings> {
  final _tokenController = TextEditingController();
  bool _tokenVisible = false;

  @override
  void initState() {
    super.initState();
    final token = ref.read(localAiSettingsProvider).hfToken;
    if (token != null) _tokenController.text = token;
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _requestEnable(BuildContext context) async {
    final aiSettings = ref.read(localAiSettingsProvider);
    final config = LocalAiModelConfig.forModel(aiSettings.model);
    final locale = Localizations.maybeLocaleOf(context) ?? AppStrings.defaultLocale;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          AppStrings.translate('settings.local_ai.enable_title', locale: locale),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow(
              ctx,
              Icons.storage_outlined,
              AppStrings.translate(
                'settings.local_ai.storage_info',
                locale: locale,
                params: {'size': config.storageSizeLabel},
              ),
            ),
            const SizedBox(height: 10),
            _infoRow(
              ctx,
              Icons.money_off_outlined,
              AppStrings.translate('settings.local_ai.no_cost', locale: locale),
            ),
            const SizedBox(height: 10),
            _infoRow(
              ctx,
              Icons.smartphone_outlined,
              AppStrings.translate('settings.local_ai.modern_device', locale: locale),
            ),
            const SizedBox(height: 10),
            _infoRow(
              ctx,
              Icons.toggle_off_outlined,
              AppStrings.translate('settings.local_ai.can_disable', locale: locale),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              AppStrings.translate('common.cancel', locale: locale),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            child: Text(
              AppStrings.translate('settings.local_ai.enable_confirm', locale: locale),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(localAiSettingsProvider.notifier).setEnabled(true);
    }
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF9C27B0), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _requestUninstall(BuildContext context) async {
    final locale = Localizations.maybeLocaleOf(context) ?? AppStrings.defaultLocale;

    final confirm = await showAppConfirmationDialog(
      context,
      title: AppStrings.translate('settings.local_ai.uninstall_title', locale: locale),
      content: AppStrings.translate('settings.local_ai.uninstall_body', locale: locale),
      confirmLabel: AppStrings.translate('settings.local_ai.uninstall_confirm', locale: locale),
      destructive: true,
      icon: Ionicons.trash_outline,
    );
    if (confirm == true && mounted) {
      await ref.read(gemmaInferenceServiceProvider).uninstallAllModels();
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiSettings = ref.watch(localAiSettingsProvider);
    final isEnabled = aiSettings.enabled;
    final dividerColor = Colors.white.withValues(alpha: 0.07);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle row
        Row(
          children: [
            Icon(
              Ionicons.hardware_chip_outline,
              color: Colors.white.withValues(alpha: 0.60),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('settings.local_ai.toggle'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    context.tr('settings.local_ai.toggle_subtitle'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (v) {
                if (v) {
                  _requestEnable(context);
                } else {
                  ref.read(localAiSettingsProvider.notifier).setEnabled(false);
                }
              },
              activeColor: const Color(0xFF9C27B0),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF9C27B0).withValues(alpha: 0.35);
                }
                return Colors.white.withValues(alpha: 0.12);
              }),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF9C27B0);
                }
                return Colors.white.withValues(alpha: 0.60);
              }),
            ),
          ],
        ),

        if (isEnabled) ...[
          Divider(color: dividerColor, height: 24),

          // Model quality selector
          Text(
            context.tr('settings.local_ai.model_quality'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          ...LocalAiModel.values.map((model) {
            final config = LocalAiModelConfig.forModel(model);
            final labelKey = switch (model) {
              LocalAiModel.minimal => 'settings.local_ai.model_minimal',
              LocalAiModel.good => 'settings.local_ai.model_good',
              LocalAiModel.best => 'settings.local_ai.model_best',
            };
            final isSelected = aiSettings.model == model;
            return GestureDetector(
              onTap: () {
                ref.read(localAiSettingsProvider.notifier).setModel(model);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF9C27B0).withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF9C27B0).withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isSelected
                          ? const Color(0xFF9C27B0)
                          : Colors.white.withValues(alpha: 0.35),
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(labelKey),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.70),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          Text(
                            config.id.replaceAll('.task', ''),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      config.storageSizeLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          Divider(color: dividerColor, height: 24),

          // HuggingFace token
          Text(
            context.tr('settings.local_ai.hf_token'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('settings.local_ai.hf_token_subtitle'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tokenController,
            obscureText: !_tokenVisible,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: context.tr('settings.local_ai.hf_token_hint'),
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF9C27B0),
                  width: 1.5,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _tokenVisible ? Icons.visibility_off : Icons.visibility,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.40),
                ),
                onPressed: () => setState(() => _tokenVisible = !_tokenVisible),
              ),
            ),
            onEditingComplete: () {
              ref
                  .read(localAiSettingsProvider.notifier)
                  .setHfToken(_tokenController.text);
              FocusScope.of(context).unfocus();
            },
          ),

          Divider(color: dividerColor, height: 24),

          // Uninstall button
          GestureDetector(
            onTap: () => _requestUninstall(context),
            child: Row(
              children: [
                Icon(
                  Ionicons.trash_outline,
                  color: const Color(0xFFFF5252).withValues(alpha: 0.75),
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  context.tr('settings.local_ai.uninstall_all'),
                  style: TextStyle(
                    color: const Color(0xFFFF5252).withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
