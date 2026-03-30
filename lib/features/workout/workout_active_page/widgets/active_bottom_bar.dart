import 'package:coachly/features/ai_coach/data/services/context_assembler_service.dart';
import 'package:coachly/features/ai_coach/ui/ai_coach_panel.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveBottomBar extends ConsumerWidget {
  const ActiveBottomBar({
    super.key,
    required this.workoutId,
    required this.onComplete,
  });

  final String workoutId;
  final VoidCallback onComplete;

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
                label: Text(
                  isSaving
                      ? context.tr('session.saving')
                      : context.tr('session.complete'),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  disabledBackgroundColor: scheme.surfaceContainerHighest,
                  disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.6),
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
                tooltip: context.tr('nav.coach'),
                onPressed: isSaving ? null : () => _openAiCoachPanel(context),
                icon: const Icon(Icons.smart_toy_rounded, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor: scheme.secondaryContainer,
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

  Future<void> _openAiCoachPanel(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ProviderScope(
          overrides: [aiCoachWorkoutIdProvider.overrideWithValue(workoutId)],
          child: const AiCoachPanel(),
        );
      },
    );
  }
}
