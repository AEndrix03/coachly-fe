import 'package:coachly/features/coach/data/models/coach_summary/coach_summary.dart';
import 'package:flutter/material.dart';

class CoachCard extends StatelessWidget {
  const CoachCard({required this.coach, super.key});

  final CoachSummary coach;

  static const Color surface = Color(0xFF13131F);
  static const Color border = Color(0xFF2A2A40);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textMuted = Color(0xFF555555);
  static const Color accentBlue = Color(0xFF4A3AFF);
  static const Color success = Color(0xFF00D68F);

  @override
  Widget build(BuildContext context) {
    final accent = _colorFromHex(coach.accentColorHex, accentBlue);
    final initials = _initialsFromName(coach.displayName);

    return Opacity(
      opacity: coach.acceptingClients ? 1 : 0.7,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              // TODO: navigate to coach profile
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(color: accent),
                          CustomPaint(painter: _PatternPainter()),
                          if (coach.priceRangeLabel != null)
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.24),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Text(
                                  coach.priceRangeLabel!,
                                  style: const TextStyle(
                                    color: textPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -24),
                              child: _Avatar(
                                accent: accent,
                                avatarUrl: coach.avatarUrl,
                                initials: initials,
                                isVerified: coach.isVerified,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coach.displayName,
                                      style: const TextStyle(
                                        color: textPrimary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        if (coach.acceptingClients) ...[
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: success,
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Expanded(
                                          child: Text(
                                            'coachly.io/${coach.handle}',
                                            style: const TextStyle(
                                              color: textSecondary,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(0, -10),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: coach.specialties
                                .map(
                                  (s) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.14),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.32),
                                      ),
                                    ),
                                    child: Text(
                                      s,
                                      style: const TextStyle(
                                        color: textPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -4),
                          child: Row(
                            children: [
                              Expanded(
                                child: _StatItem(
                                  value: coach.rating.toStringAsFixed(1),
                                  label: 'Rating',
                                ),
                              ),
                              Expanded(
                                child: _StatItem(
                                  value: '${coach.activeClients}',
                                  label: 'Clienti',
                                ),
                              ),
                              Expanded(
                                child: _StatItem(
                                  value: '${coach.avgResponseHours}h',
                                  label: 'Risposta',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  minHeight: 6,
                                  value: coach.retentionRate.clamp(0, 1),
                                  backgroundColor: textMuted.withValues(
                                    alpha: 0.3,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    accent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(coach.retentionRate * 100).toStringAsFixed(0)}% retention',
                              style: const TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!coach.acceptingClients)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.24),
                  ),
                ),
                child: const Text(
                  'Non disponibile',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Color _colorFromHex(String hex, Color fallback) {
    final normalized = hex.trim().replaceFirst('#', '');
    if (normalized.length != 6) {
      return fallback;
    }

    final value = int.tryParse('FF$normalized', radix: 16);
    if (value == null) {
      return fallback;
    }

    return Color(value);
  }

  static String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'C';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.accent,
    required this.avatarUrl,
    required this.initials,
    required this.isVerified,
  });

  final Color accent;
  final String? avatarUrl;
  final String initials;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0D0D18), width: 3),
              color: accent.withValues(alpha: 0.22),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: avatarUrl == null
                  ? Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: CoachCard.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: CoachCard.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (isVerified)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: CoachCard.accentBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0D0D18), width: 2),
                ),
                child: const Icon(Icons.check, size: 11, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: CoachCard.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(color: CoachCard.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    for (double x = -size.height; x < size.width; x += 12) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
