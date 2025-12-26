import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/tag_dto/tag_dto.dart'; // Import for TagDto
import 'package:coachly/shared/extensions/i18n_extension.dart'; // Import for fromI18n
import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import for ConsumerWidget

class WorkoutDetailHeader extends ConsumerWidget {
  // Changed to ConsumerWidget
  final String title;
  final String coachName;
  final List<TagDto> muscleTags; // Changed to List<TagDto>
  final double progress;
  final int sessionsCount;
  final int lastSessionDays;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onEdit;

  const WorkoutDetailHeader({
    super.key,
    required this.title,
    required this.coachName,
    required this.muscleTags,
    required this.progress,
    required this.sessionsCount,
    required this.lastSessionDays,
    required this.onBack,
    required this.onShare,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    final locale = ref.watch(languageProvider); // Use languageProvider
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
          children: [
            _buildAppBar(),
            _buildContent(locale),
          ], // Pass locale to _buildContent
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
    // Accept locale
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
          const SizedBox(height: 16),
          _buildCoachBadge(),
          const SizedBox(height: 16),
          _buildMuscleTags(locale), // Pass locale
          const SizedBox(height: 24),
          _buildProgressSection(),
        ],
      ),
    );
  }

  Widget _buildCoachBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
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
    // Accept locale
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
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildProgressSection() {
    final progressPercent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.black.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '$sessionsCount sessioni',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                'Ultimo: $lastSessionDays giorni fa',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
