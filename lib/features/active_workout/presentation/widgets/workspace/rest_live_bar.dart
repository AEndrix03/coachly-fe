import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/active_workout/application/rest_timer_provider.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// Il recupero in corso.
///
/// Elemento di primo livello, non una notifica: la decisione «mi serve
/// un altro minuto» si prende mentre il timer scorre.
class RestLiveBar extends StatelessWidget {
  final RestTimerState rest;
  final VoidCallback onOpen;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onSkip;

  const RestLiveBar({
    super.key,
    required this.rest,
    required this.onOpen,
    required this.onMinus,
    required this.onPlus,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final remaining = rest.remainingSeconds;
    final time =
        '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';
    final total = rest.initialSeconds <= 0 ? 1 : rest.initialSeconds;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      height: context.sizes.primaryActionHeight + context.spacing.sm,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(context.radii.xl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                widthFactor: (remaining / total).clamp(0.0, 1.0),
                child: Container(height: 2, color: scheme.primary),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                tooltip: context.tr('workout.active.rest_minus_30'),
                onPressed: onMinus,
                icon: const Icon(Icons.remove_rounded),
              ),
              Expanded(
                child: InkWell(
                  onTap: onOpen,
                  child: Semantics(
                    button: true,
                    label: '${context.activeTr('rest')} $time',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.activeTr('rest').toUpperCase(),
                          style: context.scale.captionTight.black.copyWith(
                            color: scheme.primary,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '$time / ${clock(total)}',
                          maxLines: 1,
                          style: context.scale.bodyTight.black.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: context.tr('workout.active.rest_plus_30'),
                onPressed: onPlus,
                icon: const Icon(Icons.add_rounded),
              ),
              IconButton(
                tooltip: context.activeTr('skip'),
                onPressed: onSkip,
                icon: const Icon(Icons.skip_next_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
