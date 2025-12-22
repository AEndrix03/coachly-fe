import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UserSettingsPage extends ConsumerWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language', style: theme.textTheme.h4),
            const SizedBox(height: 8),
            ShadSelect<Locale>(
              placeholder: const Text('Select a language'),
              initialValue: language,
              options: const [
                Locale('it', 'IT'),
                Locale('en', 'EN'),
              ].map((locale) {
                return ShadOption(
                  value: locale,
                  child: Text(locale.languageCode == 'it' ? 'Italiano' : 'English'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                }
              },
              selectedOptionBuilder: (BuildContext context, Locale value) {
                return Text(value.languageCode == 'it' ? 'Italiano' : 'English');
              },
            ),
          ],
        ),
      ),
    );
  }
}