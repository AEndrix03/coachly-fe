import 'package:coachly/core/feedback/app_toast_service.dart';
import 'package:coachly/features/auth/providers/user_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/voice_resolution_context_builder.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/voice_resolution_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/workout_speech_to_text_service.dart';
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
                tooltip: context.tr('session.voice.tooltip'),
                onPressed: isSaving ? null : () => _handleVoiceEntry(context, ref),
                icon: const Icon(Icons.mic_rounded, size: 22),
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

  Future<void> _handleVoiceEntry(BuildContext context, WidgetRef ref) async {
    final toast = ref.read(appToastServiceProvider);
    final locale = Localizations.maybeLocaleOf(context) ?? AppStrings.defaultLocale;
    final localeId = locale.languageCode == 'it' ? 'it_IT' : 'en_US';

    final workoutState = ref.read(activeWorkoutProvider(workoutId));
    if (workoutState.exercises.isEmpty) {
      toast.showInfo(
        context,
        context.tr('session.voice.no_exercises'),
        title: context.tr('session.voice.title'),
      );
      return;
    }

    final transcript = await _runBlockingTask(
      context: context,
      message: context.tr('session.voice.listening'),
      task: () {
        return ref
            .read(workoutSpeechToTextServiceProvider)
            .transcribe(localeId: localeId);
      },
    );

    if (!context.mounted) {
      return;
    }
    if (transcript == null || transcript.trim().isEmpty) {
      toast.showWarning(
        context,
        context.tr('session.voice.no_speech'),
        title: context.tr('session.voice.title'),
      );
      return;
    }

    final userId = ref.read(userProvider)?.sub;
    final resolutionContext = ref
        .read(voiceResolutionContextBuilderProvider)
        .build(
          workoutId: workoutId,
          workoutState: workoutState,
          userId: userId,
        );

    final resolution = await _runBlockingTask(
      context: context,
      message: context.tr('session.voice.processing'),
      task: () {
        return ref
            .read(voiceResolutionServiceProvider)
            .resolve(rawText: transcript, context: resolutionContext);
      },
    );

    if (!context.mounted || resolution == null) {
      return;
    }
    if (resolution.candidates.isEmpty) {
      toast.showError(
        context,
        context.tr('session.voice.no_match'),
        title: context.tr('session.voice.title'),
      );
      return;
    }

    String? selectedExerciseId;
    switch (resolution.decision.type) {
      case VoiceMatchDecisionType.autoMatch:
        selectedExerciseId = resolution.candidates.first.exerciseId;
      case VoiceMatchDecisionType.topSuggestions:
      case VoiceMatchDecisionType.manualSelection:
        selectedExerciseId = await _showCandidatePicker(
          context: context,
          resolution: resolution,
        );
    }

    if (!context.mounted || selectedExerciseId == null) {
      return;
    }

    final applied = ref
        .read(activeWorkoutProvider(workoutId).notifier)
        .applyVoiceEntry(
          exerciseId: selectedExerciseId,
          sets: resolution.parsedEntry.sets,
          reps: resolution.parsedEntry.reps,
          weightKg: resolution.parsedEntry.weightKg,
        );

    if (applied == null) {
      toast.showError(
        context,
        context.tr('session.voice.apply_failed'),
        title: context.tr('session.voice.title'),
      );
      return;
    }

    await ref.read(voiceResolutionServiceProvider).registerFeedback(
      resolution: resolution,
      context: resolutionContext,
      selectedExerciseId: selectedExerciseId,
    );

    if (!context.mounted) {
      return;
    }

    toast.showSuccess(
      context,
      context.tr(
        'session.voice.applied',
        params: {
          'exercise': applied.exerciseName,
          'sets': '${applied.sets}',
          'reps': '${applied.reps}',
          'kg': applied.weightKg.toStringAsFixed(1),
        },
      ),
      title: context.tr('session.voice.title'),
    );
  }

  Future<T?> _runBlockingTask<T>({
    required BuildContext context,
    required String message,
    required Future<T?> Function() task,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final scheme = Theme.of(context).colorScheme;
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(message)),
              ],
            ),
          ),
        );
      },
    );

    try {
      return await task();
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<String?> _showCandidatePicker({
    required BuildContext context,
    required VoiceResolutionResult resolution,
  }) {
    final topCandidates = resolution.candidates.take(3).toList(growable: false);
    final parsed = resolution.parsedEntry;
    final parsedSummary = <String>[
      if (parsed.sets != null) '${parsed.sets} sets',
      if (parsed.reps != null) '${parsed.reps} reps',
      if (parsed.weightKg != null) '${parsed.weightKg!.toStringAsFixed(1)} kg',
    ].join(' - ');

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('session.voice.choose_title'),
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '"${parsed.originalText}"',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.72),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (parsedSummary.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  parsedSummary,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.68),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ...topCandidates.map((candidate) {
                final score = (candidate.finalScore * 100).toStringAsFixed(0);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    candidate.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${context.tr('session.voice.confidence')}: $score%',
                  ),
                  onTap: () => Navigator.pop(context, candidate.exerciseId),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
