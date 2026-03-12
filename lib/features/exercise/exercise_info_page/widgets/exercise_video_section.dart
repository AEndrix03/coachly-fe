import 'package:flutter/material.dart';

class ExerciseVideoSection extends StatelessWidget {
  final String videoUrl;
  final String exerciseName;
  final List<String> tags;

  const ExerciseVideoSection({
    super.key,
    required this.videoUrl,
    required this.exerciseName,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoPlayer(),
          const SizedBox(height: 20),
          Text(
            exerciseName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // TODO: Replace with actual video player
          const Icon(Icons.fitness_center, size: 60, color: Color(0xFF2196F3)),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTag(tag)).toList(),
    );
  }

  Widget _buildTag(String label) {
    Color backgroundColor;
    Color textColor;

    switch (label.toLowerCase()) {
      case 'intermedio':
      case 'intermediate':
        backgroundColor = const Color(0xFFFF9800).withOpacity(0.15);
        textColor = const Color(0xFFFF9800);
        break;
      case 'compound':
        backgroundColor = const Color(0xFF9C27B0).withOpacity(0.15);
        textColor = const Color(0xFF9C27B0);
        break;
      case 'push':
        backgroundColor = const Color(0xFFFF5252).withOpacity(0.15);
        textColor = const Color(0xFFFF5252);
        break;
      default:
        backgroundColor = const Color(0xFF2196F3).withOpacity(0.15);
        textColor = const Color(0xFF2196F3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
