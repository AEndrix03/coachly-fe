import 'package:coachly/features/exercise/domain/exercise_detail_view_data.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/pages/coachly_concept_guide_page.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/shared/design_system/coachly_info_sheet.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onInfo;

  const ExerciseSectionTitle(this.title, {super.key, this.onInfo});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            title,
            style: context.scale.title.semibold.copyWith(
              color: colors.textPrimary,
              letterSpacing: -0.25,
            ),
          ),
        ),
        if (onInfo != null) ...[
          const SizedBox(width: 6),
          SizedBox.square(
            dimension: 44,
            child: IconButton(
              tooltip: context.l10n.commonInformation,
              padding: EdgeInsets.zero,
              onPressed: onInfo,
              icon: Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ExerciseLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ExerciseLinkButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Semantics(
      button: true,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          padding: EdgeInsets.zero,
          foregroundColor: colors.primary,
          textStyle: context.scale.body.semibold,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 5),
            const Icon(Icons.arrow_forward_rounded, size: 17),
          ],
        ),
      ),
    );
  }
}

class ExerciseMediaHero extends StatelessWidget {
  final ExerciseMediaViewData media;

  const ExerciseMediaHero({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.border),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (media.kind == ExerciseMediaKind.image &&
                    media.url?.isNotEmpty == true)
                  Image.network(
                    media.url!,
                    fit: BoxFit.cover,
                    cacheWidth: 900,
                    errorBuilder: (_, _, _) => _MediaPlaceholder(media: media),
                  )
                else if (media.kind == ExerciseMediaKind.video &&
                    media.thumbnailUrl?.isNotEmpty == true)
                  Image.network(
                    media.thumbnailUrl!,
                    fit: BoxFit.cover,
                    cacheWidth: 900,
                    errorBuilder: (_, _, _) => _MediaPlaceholder(media: media),
                  )
                else
                  _MediaPlaceholder(media: media),
                if (media.kind != ExerciseMediaKind.placeholder)
                  Center(
                    child: Semantics(
                      button: true,
                      label: context.l10n.exercisePlayMedia,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: colors.textPrimary.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 32,
                          color: colors.background,
                        ),
                      ),
                    ),
                  ),
                if (!reduceMotion)
                  const Positioned.fill(
                    child: IgnorePointer(child: _HeroSheen()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  final ExerciseMediaViewData media;

  const _MediaPlaceholder({required this.media});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Stack(
      children: [
        Positioned(
          right: -24,
          top: -36,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: 0.055),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.vertical_align_bottom_rounded,
                size: 42,
                color: colors.primary.withValues(alpha: 0.78),
              ),
              const SizedBox(height: 12),
              // Il riquadro e' 16:9, quindi ha un'altezza fissa: a text
              // scaling 2.0 queste due righe la superavano di 27px. Flexible
              // + ellipsis le fa cedere invece di sfondare. A scala 1 lo
              // spazio avanza e il layout non cambia
              // (`docs/development/14-accessibility.md`).
              Flexible(
                child: Text(
                  media.movementLabel,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.scale.bodyLoose.semibold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  context.l10n.exerciseMediaSoon,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.scale.captionLoose.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSheen extends StatefulWidget {
  const _HeroSheen();

  @override
  State<_HeroSheen> createState() => _HeroSheenState();
}

class _HeroSheenState extends State<_HeroSheen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.colors.borderSubtle, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class ExerciseDetailScaffold extends StatelessWidget {
  final String title;
  final String exerciseName;
  final Widget body;

  const ExerciseDetailScaffold({
    super.key,
    required this.title,
    required this.exerciseName,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        centerTitle: false,
        titleSpacing: 4,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Text(
                exerciseName,
                style: context.scale.bodyTight.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class ExerciseAddAction extends StatelessWidget {
  final VoidCallback onTap;

  const ExerciseAddAction({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: FilledButton.icon(
          key: const Key('exercise-add-action'),
          onPressed: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            textStyle: context.scale.bodyLoose.semibold,
          ),
          icon: const Icon(Icons.add_rounded),
          label: Text(context.l10n.exerciseAddToWorkout),
        ),
      ),
    );
  }
}

Future<void> showCoachlyInfoSheet(
  BuildContext context, {
  required String title,
  required String description,
  required String whyItMatters,
  required CoachlyGuideTopic guideTopic,
  String? disclaimer,
}) {
  return CoachlyInfoSheet.show(
    context,
    title: title,
    sections: [
      CoachlyInfoSection(context.l10n.workoutDetailWhatIsIt, description),
      CoachlyInfoSection(context.l10n.commonWhyItMatters, whyItMatters),
      if (disclaimer != null)
        CoachlyInfoSection(context.l10n.commonAppName, disclaimer),
    ],
    primaryActionLabel: context.l10n.commonGotIt,
    secondaryActionLabel: context.l10n.commonLearnMore,
    onSecondaryAction: () {
      final navigator = Navigator.of(context);
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      HapticFeedback.lightImpact();
      final route = reduceMotion
          ? PageRouteBuilder<void>(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (_, _, _) =>
                  CoachlyConceptGuidePage(topic: guideTopic),
            )
          : CupertinoPageRoute<void>(
              builder: (_) => CoachlyConceptGuidePage(topic: guideTopic),
            );
      navigator.push<void>(route);
    },
  );
}

class TensionDots extends StatelessWidget {
  final TensionLevel level;

  const TensionDots({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final activeCount = switch (level) {
      TensionLevel.none => 0,
      TensionLevel.low => 1,
      TensionLevel.moderate => 2,
      TensionLevel.high => 3,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < activeCount
                ? colors.primary
                : colors.textSecondary.withValues(alpha: 0.22),
          ),
        ),
      ),
    );
  }
}

class ResistanceProfileChart extends StatelessWidget {
  final List<double> points;

  const ResistanceProfileChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: CustomPaint(
          painter: _ResistanceProfilePainter(
            points: points,
            theme: context.exerciseTheme,
          ),
        ),
      ),
    );
  }
}

class _ResistanceProfilePainter extends CustomPainter {
  final List<double> points;
  final CoachlyExerciseTheme theme;

  const _ResistanceProfilePainter({required this.points, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = theme.border
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 22),
      Offset(size.width, size.height - 22),
      axis,
    );
    if (points.length < 2) return;
    final path = Path();
    for (var index = 0; index < points.length; index++) {
      final x = index * size.width / (points.length - 1);
      final y = (size.height - 34) * (1 - points[index]) + 6;
      index == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = theme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ResistanceProfilePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.theme != theme;
}

class ExerciseLoadingView extends StatelessWidget {
  const ExerciseLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    Widget block(double height, {double? width}) => Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
    );
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.42, end: 0.72),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeInOut,
            builder: (_, opacity, child) =>
                Opacity(opacity: opacity, child: child),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                block(44, width: 44),
                const SizedBox(height: 30),
                block(34, width: 220),
                const SizedBox(height: 18),
                block(190),
                const SizedBox(height: 28),
                block(18, width: 170),
                const SizedBox(height: 14),
                block(72),
                const SizedBox(height: 28),
                block(18, width: 130),
                const SizedBox(height: 14),
                block(120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ExerciseErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      color: colors.textSecondary,
                      size: 46,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.exerciseLoadFailed,
                      textAlign: TextAlign.center,
                      style: context.scale.titleLoose.semibold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: onRetry,
                      child: Text(context.l10n.commonRetry),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
