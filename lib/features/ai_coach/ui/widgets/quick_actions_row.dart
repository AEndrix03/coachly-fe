import 'package:coachly/features/ai_coach/application/ai_coach_notifier.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickActionsRow extends ConsumerStatefulWidget {
  const QuickActionsRow({super.key, required this.enabled});

  final bool enabled;

  @override
  ConsumerState<QuickActionsRow> createState() => _QuickActionsRowState();
}

class _QuickActionsRowState extends ConsumerState<QuickActionsRow> {
  QuickActionType? _pressed;

  @override
  Widget build(BuildContext context) {
    final actions = <({String icon, String label, QuickActionType type})>[
      (icon: '??', label: 'AGGIUSTA', type: QuickActionType.adjustWeight),
      (icon: '??', label: 'PROGRESSI', type: QuickActionType.showProgress),
      (icon: '??', label: 'FATICA', type: QuickActionType.fatigueCheck),
      (icon: '?', label: 'PROSSIMO', type: QuickActionType.nextExercise),
      (icon: '??', label: 'NUTRIZIONE', type: QuickActionType.nutrition),
    ];

    return SizedBox(
      height: 52,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: actions
              .map((action) {
                final isPressed = _pressed == action.type;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTapDown: widget.enabled
                        ? (_) => setState(() => _pressed = action.type)
                        : null,
                    onTapCancel: () => setState(() => _pressed = null),
                    onTapUp: widget.enabled
                        ? (_) => setState(() => _pressed = null)
                        : null,
                    onTap: widget.enabled
                        ? () {
                            ref
                                .read(aiCoachNotifierProvider.notifier)
                                .tapQuickAction(action.type);
                          }
                        : null,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 120),
                      scale: isPressed ? 0.93 : 1,
                      curve: Curves.easeOut,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AiCoachTheme.bgCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AiCoachTheme.borderMid),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              action.icon,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              action.label,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AiCoachTheme.textSecondary.withValues(
                                  alpha: 0.72,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
