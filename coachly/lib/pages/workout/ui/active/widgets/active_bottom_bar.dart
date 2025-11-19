import 'package:coachly/widgets/common/ai_coach_widget.dart';
import 'package:coachly/widgets/common/rest_timer_widget.dart';
import 'package:flutter/material.dart';

/// Barra inferiore moderna con pulsanti volanti
class ActiveBottomBar extends StatelessWidget {
  const ActiveBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Timer button
          _buildFloatingButton(
            context: context,
            icon: Icons.timer_outlined,
            gradient: [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
            glowColor: const Color(0xFF6366F1),
            onTap: () => _showRestTimer(context),
          ),
          const SizedBox(height: 14),

          // AI Coach button
          _buildFloatingButton(
            context: context,
            icon: Icons.smart_toy_outlined,
            gradient: [const Color(0xFF10B981), const Color(0xFF059669)],
            glowColor: const Color(0xFF10B981),
            onTap: () => _showAICoach(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required BuildContext context,
    required IconData icon,
    required List<Color> gradient,
    required Color glowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  void _showRestTimer(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          RestTimerWidget(onClose: () => Navigator.pop(context)),
    );
  }

  void _showAICoach(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AICoachWidget(onClose: () => Navigator.pop(context)),
    );
  }
}
