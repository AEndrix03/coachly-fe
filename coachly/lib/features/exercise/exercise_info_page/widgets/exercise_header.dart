import 'package:flutter/material.dart';

class ExerciseHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const ExerciseHeader({
    super.key,
    required this.onBack,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(Icons.arrow_back, onBack),
            Row(
              children: [
                _buildIconButton(Icons.share, onShare),
                const SizedBox(width: 12),
                _buildIconButton(Icons.bookmark_border, onSave),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
