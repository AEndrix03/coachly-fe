import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:coachly/features/auth/providers/user_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
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
    final fullName = [user?.firstName, user?.lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(initials, fullName),
              const SizedBox(height: 32),
              _buildSection(
                icon: Ionicons.settings_outline,
                color: const Color(0xFF2196F3),
                title: 'Preferenze',
                child: _buildLanguageSetting(context, ref),
              ),
              const SizedBox(height: 16),
              _buildSection(
                icon: Ionicons.information_circle_outline,
                color: const Color(0xFF9C27B0),
                title: 'App',
                child: _buildAppInfo(),
              ),
              const SizedBox(height: 32),
              _buildLogoutButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String initials, String fullName) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 6),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName.isEmpty ? 'Utente' : fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Coachly Member',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.40),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
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

    return Row(
      children: [
        Icon(
          Ionicons.language_outline,
          color: Colors.white.withValues(alpha: 0.60),
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          'Lingua',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        ShadSelect<Locale>(
          placeholder: Text(
            language.languageCode == 'it' ? 'Italiano' : 'English',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          initialValue: language,
          options: const [Locale('it', 'IT'), Locale('en', 'EN')].map((l) {
            return ShadOption(
              value: l,
              child: Text(l.languageCode == 'it' ? 'Italiano' : 'English'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(languageProvider.notifier).setLanguage(value);
            }
          },
          selectedOptionBuilder: (context, value) => Text(
            value.languageCode == 'it' ? 'Italiano' : 'English',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        _infoRow(label: 'Versione', value: '1.0.0 MVP'),
        Divider(color: Colors.white.withValues(alpha: 0.07), height: 24),
        _infoRow(label: 'Build', value: 'alpha'),
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
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Sei sicuro di voler uscire?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annulla'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFF5252),
                ),
                child: const Text('Esci'),
              ),
            ],
          ),
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
              'Logout',
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
