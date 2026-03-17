import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/tag_dto/tag_dto.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutDetailHeader extends ConsumerWidget {
  final String title;
  final String coachName;
  final bool showCoach;
  final List<TagDto> muscleTags;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onEdit;

  const WorkoutDetailHeader({
    super.key,
    required this.title,
    required this.coachName,
    required this.showCoach,
    required this.muscleTags,
    required this.onBack,
    required this.onShare,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF7B4BC1)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildAppBar(), _buildContent(locale)],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          GlassIconButton(
            icon: Icons.arrow_back,
            onPressed: onBack,
            marginRight: 8,
          ),
          const Spacer(),
          GlassIconButton(
            icon: Icons.share,
            onPressed: onShare,
            marginRight: 8,
          ),
          GlassIconButton(icon: Icons.edit, onPressed: onEdit),
        ],
      ),
    );
  }

  Widget _buildContent(Locale locale) {
    final shouldShowCoach = showCoach && coachName.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (shouldShowCoach) ...[
            const SizedBox(height: 16),
            _buildCoachBadge(),
          ],
          if (muscleTags.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildMuscleTags(locale),
          ],
        ],
      ),
    );
  }

  Widget _buildCoachBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_outline, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            coachName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleTags(Locale locale) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: muscleTags
          .map((tag) => _buildTag(tag.nameI18n.fromI18n(locale)))
          .toList(),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
