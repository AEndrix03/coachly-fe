import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/active_workout_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Anteprima UI del riepilogo post-sessione.
///
/// I valori sono volutamente fittizi finché lo storico sessioni non espone
/// metriche comparabili; la pagina non li presenta come dati persistiti.
class WorkoutCompletionPage extends StatelessWidget {
  const WorkoutCompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: context.spacing.lg),
              _CompletionHero(
                title: context.activeTr('completion.title'),
                subtitle: context.activeTr('completion.subtitle'),
                badge: context.activeTr('completion.mockBadge'),
              ),
              SizedBox(height: context.spacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.timer_outlined,
                      label: context.activeTr('completion.duration'),
                      value: context.activeTr('completion.durationValue'),
                    ),
                  ),
                  SizedBox(width: context.spacing.sm),
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.fitness_center_rounded,
                      label: context.activeTr('completion.sets'),
                      value: context.activeTr('completion.setsValue'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.spacing.sm),
              _MetricCard(
                icon: Icons.monitor_weight_outlined,
                label: context.activeTr('completion.volume'),
                value: context.activeTr('completion.volumeValue'),
              ),
              SizedBox(height: context.spacing.lg),
              _InsightCard(
                icon: Icons.trending_up_rounded,
                title: context.activeTr('completion.performanceTitle'),
                body: context.activeTr('completion.performanceBody'),
                accent: colors.feedbackSuccess,
              ),
              SizedBox(height: context.spacing.sm),
              _InsightCard(
                icon: Icons.auto_graph_rounded,
                title: context.activeTr('completion.improvementTitle'),
                body: context.activeTr('completion.improvementBody'),
                accent: colors.surfaceAccent,
              ),
              SizedBox(height: context.spacing.sm),
              _InsightCard(
                icon: Icons.workspace_premium_rounded,
                title: context.activeTr('completion.qualityTitle'),
                body: context.activeTr('completion.qualityBody'),
                accent: colors.feedbackWarning,
              ),
              SizedBox(height: context.spacing.xl),
              FilledButton.icon(
                onPressed: context.pop,
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(
                    context.sizes.primaryActionHeight,
                  ),
                  backgroundColor: colors.surfaceAccent,
                  foregroundColor: colors.textOnAccent,
                ),
                icon: const Icon(Icons.home_rounded),
                label: Text(context.activeTr('completion.home')),
              ),
              SizedBox(height: context.spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionHero extends StatelessWidget {
  const _CompletionHero({
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  final String title;
  final String subtitle;
  final String badge;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: EdgeInsets.all(context.spacing.md),
        decoration: BoxDecoration(
          color: context.colors.feedbackSuccess.withValues(alpha: .14),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.emoji_events_rounded,
          size: context.sizes.iconXl,
          color: context.colors.feedbackSuccess,
        ),
      ),
      SizedBox(height: context.spacing.md),
      Text(
        badge,
        textAlign: TextAlign.center,
        style: context.scale.micro.black.copyWith(
          color: context.colors.surfaceAccent,
          letterSpacing: 1,
        ),
      ),
      SizedBox(height: context.spacing.xs),
      Text(
        title,
        textAlign: TextAlign.center,
        style: context.scale.headline.black.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
      SizedBox(height: context.spacing.sm),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: context.scale.body.copyWith(color: context.colors.textSecondary),
      ),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(context.spacing.md),
    decoration: BoxDecoration(
      color: context.colors.surfaceElevated,
      borderRadius: BorderRadius.circular(context.radii.card),
      border: Border.all(color: context.colors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: context.colors.surfaceAccent),
        SizedBox(height: context.spacing.md),
        Text(
          value,
          style: context.scale.title.black.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          label,
          style: context.scale.captionLoose.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    ),
  );
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(context.spacing.md),
    decoration: BoxDecoration(
      color: context.colors.surfaceElevated,
      borderRadius: BorderRadius.circular(context.radii.card),
      border: Border.all(color: context.colors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accent),
        SizedBox(width: context.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.scale.body.black.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: context.spacing.xs),
              Text(
                body,
                style: context.scale.captionLoose.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
