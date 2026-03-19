import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';

class CoachHeader extends StatefulWidget {
  const CoachHeader({
    super.key,
    required this.onClose,
    required this.isModelLoading,
  });

  final VoidCallback onClose;
  final bool isModelLoading;

  @override
  State<CoachHeader> createState() => _CoachHeaderState();
}

class _CoachHeaderState extends State<CoachHeader>
    with TickerProviderStateMixin {
  late final AnimationController _ringController;
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ringController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusText = widget.isModelLoading
        ? 'Caricamento AI Coach...'
        : 'Monitora il tuo workout';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 12, 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _ringController,
                  builder: (context, child) {
                    final t = _ringController.value;
                    final scale = 1 + (0.15 * t);
                    final opacity = 0.3 * (1 - t);

                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AiCoachTheme.accentBlue,
                              width: 1.1,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AiCoachTheme.accentBlue,
                        AiCoachTheme.accentPurple,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Coach',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.25, end: 1).animate(
                        CurvedAnimation(
                          parent: _blinkController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AiCoachTheme.liveGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: AiCoachTheme.accentBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AiCoachTheme.closeButtonBg,
              shape: BoxShape.circle,
              border: Border.all(color: AiCoachTheme.borderMid),
            ),
            child: IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AiCoachTheme.textSecondary,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}
