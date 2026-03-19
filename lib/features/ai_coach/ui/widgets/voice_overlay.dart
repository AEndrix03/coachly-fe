import 'dart:math' as math;

import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';

class VoiceOverlay extends StatefulWidget {
  const VoiceOverlay({
    super.key,
    required this.visible,
    required this.voiceTranscript,
    required this.onCancel,
    required this.onSend,
  });

  final bool visible;
  final String voiceTranscript;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  State<VoiceOverlay> createState() => _VoiceOverlayState();
}

class _VoiceOverlayState extends State<VoiceOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.visible,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        child: Container(
          color: AiCoachTheme.bgPrimary.withValues(alpha: 0.93),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'IN ASCOLTO...',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AiCoachTheme.accentBlue,
                ),
              ),
              const SizedBox(height: 24),
              _VoiceOrb(controller: _controller),
              const SizedBox(height: 20),
              Text(
                widget.voiceTranscript.isEmpty
                    ? 'Parla adesso...'
                    : widget.voiceTranscript,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AiCoachTheme.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AiCoachTheme.textSecondary,
                      side: const BorderSide(color: AiCoachTheme.borderMid),
                    ),
                    child: const Text('Annulla'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: widget.onSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AiCoachTheme.accentBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Invia ?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceOrb extends StatelessWidget {
  const _VoiceOrb({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final data in [
            (size: 80.0, delay: 0.0),
            (size: 100.0, delay: 0.3),
            (size: 120.0, delay: 0.6),
          ])
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final t = (controller.value + data.delay) % 1;
                final scale = 0.9 + (0.3 * t);
                final opacity = (1 - t) * 0.7;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: data.size,
                    height: data.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AiCoachTheme.accentPurple.withValues(
                          alpha: 0.25 * opacity,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AiCoachTheme.accentBlue, AiCoachTheme.accentPurple],
              ),
            ),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final phase =
                        (controller.value + (index * 0.11)) * 2 * math.pi;
                    final normalized = (math.sin(phase) + 1) / 2;
                    final height = 6 + (16 * normalized);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.4),
                      child: Container(
                        width: 3,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
