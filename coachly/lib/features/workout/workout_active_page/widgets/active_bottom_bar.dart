import 'package:coachly/features/common/ai/ai_coach_widget.dart';
import 'package:flutter/material.dart';

/// Barra inferiore moderna con pulsanti volanti
class ActiveBottomBar extends StatelessWidget {
  const ActiveBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: // AI Coach button - Viola gradient
      _buildFloatingButton(
        context: context,
        icon: Icons.smart_toy_outlined,
        gradient: [const Color(0xFF9333EA), const Color(0xFF7C3AED)],
        glowColor: const Color(0xFF9333EA),
        onTap: () => _showAICoach(context),
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
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.4),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }

  void _showAICoach(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AICoachWidget(
        onClose: () => Navigator.pop(context),
        showQuickActions: false,
      ),
    );
  }
}
