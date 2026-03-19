import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UserSettingsPage extends ConsumerWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final language = ref.watch(languageProvider);
    final currentLocale =
        Localizations.maybeLocaleOf(context) ?? AppStrings.defaultLocale;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('common.settings'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr('common.language'), style: theme.textTheme.h4),
            const SizedBox(height: 8),
            ShadSelect<Locale>(
              placeholder: Text(context.tr('common.select_language')),
              initialValue: language,
              options: AppStrings.languageOptions.map((locale) {
                return ShadOption(
                  value: locale,
                  child: Text(
                    AppStrings.languageDisplayName(
                      locale,
                      displayLocale: currentLocale,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                }
              },
              selectedOptionBuilder: (BuildContext context, Locale value) {
                return Text(
                  AppStrings.languageDisplayName(
                    value,
                    displayLocale: currentLocale,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
