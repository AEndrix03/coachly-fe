import 'dart:math' as math;

import 'package:coachly/features/ai_coach/domain/models/coach_message.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.showTyping = false,
  });

  final CoachMessage message;
  final bool showTyping;

  @override
  Widget build(BuildContext context) {
    final isAi = message.sender == MessageSender.ai;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 8),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: isAi
                ? [
                    _AiAvatar(),
                    const SizedBox(width: 8),
                    _BubbleCard(message: message, showTyping: showTyping),
                  ]
                : [
                    _BubbleCard(message: message, showTyping: showTyping),
                    const SizedBox(width: 8),
                    const _UserAvatar(),
                  ],
          ),
        ),
      ),
    );
  }
}

class _BubbleCard extends StatelessWidget {
  const _BubbleCard({required this.message, required this.showTyping});

  final CoachMessage message;
  final bool showTyping;

  @override
  Widget build(BuildContext context) {
    final isAi = message.sender == MessageSender.ai;

    return Container(
      constraints: const BoxConstraints(maxWidth: 265),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isAi ? AiCoachTheme.bgSurface : AiCoachTheme.userBubble,
        borderRadius: isAi
            ? const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
        border: isAi ? Border.all(color: AiCoachTheme.borderSubtle) : null,
      ),
      child: showTyping && isAi && message.text.trim().isEmpty
          ? const _TypingIndicator()
          : Text(
              message.text,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.55,
                color: isAi ? AiCoachTheme.textPrimary : AiCoachTheme.userText,
              ),
            ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AiCoachTheme.aiAvatarStart, AiCoachTheme.aiAvatarEnd],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'AI',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AiCoachTheme.aiAvatarText,
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AiCoachTheme.userAvatarBg,
      ),
      child: const Icon(
        Icons.person,
        size: 14,
        color: AiCoachTheme.textSecondary,
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final phase = (_controller.value - (index * 0.16)) * 2 * math.pi;
              final offset = math.max(0.0, math.sin(phase));

              return Transform.translate(
                offset: Offset(0, -offset * 3),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AiCoachTheme.accentBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
