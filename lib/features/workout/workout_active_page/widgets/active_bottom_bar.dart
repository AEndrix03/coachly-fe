import 'package:coachly/features/common/ai/ai_coach_widget.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveBottomBar extends ConsumerWidget {
  final String workoutId;
  final VoidCallback onComplete;

  const ActiveBottomBar({
    super.key,
    required this.workoutId,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final status = ref.watch(
      activeWorkoutProvider(workoutId).select((s) => s.status),
    );
    final isSaving = status == ActiveWorkoutStatus.saving;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            scheme.surfaceContainerHighest.withValues(alpha: 0.88),
            scheme.surface,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: isSaving ? null : onComplete,
                icon: isSaving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.flag_rounded, size: 20),
                label: Text(isSaving ? 'Salvataggio...' : 'Completa sessione'),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  disabledBackgroundColor: scheme.surfaceContainerHighest,
                  disabledForegroundColor: scheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton.filledTonal(
                tooltip: 'AI Coach',
                onPressed: () => _showAICoach(context),
                icon: const Icon(Icons.auto_awesome_rounded, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor: scheme.secondaryContainer.withValues(
                    alpha: 0.68,
                  ),
                  foregroundColor: scheme.onSecondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
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
