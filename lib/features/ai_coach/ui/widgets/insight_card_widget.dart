import 'package:coachly/features/ai_coach/domain/models/insight_card.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';

class InsightCardWidget extends StatelessWidget {
  const InsightCardWidget({super.key, required this.card});

  final InsightCard card;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 210),
        margin: const EdgeInsets.fromLTRB(46, 2, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: AiCoachTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AiCoachTheme.insightBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.label,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AiCoachTheme.accentBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.body,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AiCoachTheme.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
