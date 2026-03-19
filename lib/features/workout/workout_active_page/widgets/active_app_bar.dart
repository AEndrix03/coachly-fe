import 'dart:async';

import 'package:coachly/features/workout/workout_active_page/providers/active_workout_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/rest_timer_provider.dart';

class ActiveAppBar extends ConsumerStatefulWidget {
  final String workoutId;

  const ActiveAppBar({super.key, required this.workoutId});

  @override
  ConsumerState<ActiveAppBar> createState() => _ActiveAppBarState();
}

class _ActiveAppBarState extends ConsumerState<ActiveAppBar> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _togglePause() {
    setState(() {
      if (_isPaused) {
        _startTimer();
      } else {
        _timer.cancel();
      }
      _isPaused = !_isPaused;
    });
  }

  String get _formattedTime {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final totalExercises = ref.watch(
      activeWorkoutProvider(widget.workoutId).select((s) => s.totalExercises),
    );
    final isBellEnabled = ref.watch(
      restTimerProvider.select((timer) => timer.isBellEnabled),
    );

    return Container(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          scheme.surfaceContainerHighest.withValues(alpha: 0.55),
          scheme.surface,
        ),
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.9),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(
                children: [
                  _buildIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: () => _showCancelDialog(context),
                    scheme: scheme,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary.withValues(alpha: 0.16),
                            scheme.secondary.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.timer_rounded,
                                size: 17,
                                color: scheme.onSurface.withValues(alpha: 0.78),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formattedTime,
                                style: TextStyle(
                                  color: scheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: isBellEnabled
                                    ? context.tr('session.bell_on')
                                    : context.tr('session.bell_off'),
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  ref
                                      .read(restTimerProvider.notifier)
                                      .toggleBell();
                                },
                                icon: Icon(
                                  isBellEnabled
                                      ? Icons.notifications_active_rounded
                                      : Icons.notifications_off_rounded,
                                  size: 20,
                                  color: isBellEnabled
                                      ? scheme.primary
                                      : scheme.onSurface.withValues(
                                          alpha: 0.55,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.tr(
                              'session.exercise_count',
                              params: {'count': '$totalExercises'},
                            ),
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.68),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildIconButton(
                    icon: _isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    onPressed: _togglePause,
                    scheme: scheme,
                  ),
                  const SizedBox(width: 8),
                  _buildMenuButton(context, scheme),
                ],
              ),
            ),
            _buildRestTimerBar(ref, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildRestTimerBar(WidgetRef ref, ColorScheme scheme) {
    final timerState = ref.watch(restTimerProvider);
    if (!timerState.isActive) {
      return const SizedBox.shrink();
    }

    final minutes = timerState.remainingSeconds ~/ 60;
    final seconds = timerState.remainingSeconds % 60;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.hourglass_bottom_rounded,
              color: scheme.tertiary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => ref.read(restTimerProvider.notifier).addTime(-10),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.onSurface.withValues(alpha: 0.82),
              side: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.8),
              ),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('-10s'),
          ),
          const SizedBox(width: 6),
          OutlinedButton(
            onPressed: () => ref.read(restTimerProvider.notifier).addTime(10),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.primary,
              side: BorderSide(color: scheme.primary.withValues(alpha: 0.5)),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('+10s'),
          ),
          const Spacer(),
          IconButton(
            tooltip: context.tr('session.stop_timer'),
            onPressed: () => ref.read(restTimerProvider.notifier).stopTimer(),
            icon: Icon(
              Icons.close_rounded,
              color: scheme.error.withValues(alpha: 0.92),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme scheme,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: IconButton(
        icon: Icon(icon, color: scheme.onSurface, size: 22),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, ColorScheme scheme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(Icons.more_horiz_rounded, color: scheme.onSurface, size: 22),
        color: scheme.surfaceContainerHigh,
        offset: const Offset(0, 52),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
        onSelected: (value) {
          switch (value) {
            case 'notes':
              break;
            case 'history':
              break;
            case 'discard':
              _showDiscardDialog(context);
              break;
          }
        },
        itemBuilder: (context) => [
          _menuItem(
            value: 'notes',
            icon: Icons.sticky_note_2_outlined,
            label: context.tr('session.notes'),
            color: scheme.onSurface,
          ),
          _menuItem(
            value: 'history',
            icon: Icons.history_toggle_off_rounded,
            label: context.tr('session.history'),
            color: scheme.onSurface,
          ),
          const PopupMenuDivider(height: 1),
          _menuItem(
            value: 'discard',
            icon: Icons.delete_sweep_rounded,
            label: context.tr('session.finish_discard'),
            color: scheme.error,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final result = await showAppConfirmationDialog(
      context,
      title: context.tr('session.exit_title'),
      content: context.tr('session.exit_content'),
      cancelLabel: context.tr('session.stay'),
      confirmLabel: context.tr('session.exit_without_save'),
      destructive: true,
      icon: Icons.warning_amber_rounded,
    );

    if (result == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showDiscardDialog(BuildContext context) async {
    final result = await showAppConfirmationDialog(
      context,
      title: context.tr('session.discard_title'),
      content: context.tr('session.discard_content'),
      confirmLabel: context.tr('session.discard_confirm'),
      destructive: true,
      icon: Icons.delete_sweep_rounded,
    );

    if (result == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}
