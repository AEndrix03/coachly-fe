import 'package:flutter/material.dart';

/// Header gradient con pill-badge, identico allo stile di WorkoutHeader.
/// Usato da FeedbackPage, ProfilePage e qualsiasi futura pagina top-level.
class PageHeader extends StatelessWidget {
  final IconData badgeIcon;
  final String badgeLabel;
  final String title;
  final String? subtitle;
  /// Widget opzionale mostrato in fondo all'header (es. info-box, stats).
  final Widget? bottom;
  /// Gradient personalizzabile; di default usa il gradient dell'app.
  final List<Color>? gradientColors;

  const PageHeader({
    super.key,
    required this.badgeIcon,
    required this.badgeLabel,
    required this.title,
    this.subtitle,
    this.bottom,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        const [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF7B4BC1)];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBadge(context),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
              if (bottom != null) ...[
                const SizedBox(height: 18),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: scheme.onPrimary.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(badgeIcon, color: Colors.white, size: 14),
              const SizedBox(width: 7),
              Text(
                badgeLabel,
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.95),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
