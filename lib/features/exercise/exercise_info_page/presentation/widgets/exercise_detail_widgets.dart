import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/exercise_theme.dart';
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
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
          ),
        ),
        if (onInfo != null) ...[
          const SizedBox(width: 6),
          SizedBox.square(
            dimension: 44,
            child: IconButton(
              tooltip: 'Informazioni',
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
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                      label: 'Riproduci media esercizio',
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
              Text(
                media.movementLabel,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Media in arrivo',
                style: TextStyle(color: colors.textSecondary, fontSize: 13),
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
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x0FFFFFFF), Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class MuscleAnatomyView extends StatefulWidget {
  final List<MuscleViewData> muscles;
  final String? selectedMuscleId;
  final bool backView;
  final ValueChanged<String>? onMuscleSelected;

  const MuscleAnatomyView({
    super.key,
    required this.muscles,
    this.selectedMuscleId,
    this.backView = true,
    this.onMuscleSelected,
  });

  @override
  State<MuscleAnatomyView> createState() => _MuscleAnatomyViewState();
}

class _MuscleAnatomyViewState extends State<MuscleAnatomyView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _selectionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    value: 1,
  );
  bool _reduceMotion = false;
  String? _previousSelectedMuscleId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) _selectionController.value = 1;
  }

  @override
  void didUpdateWidget(covariant MuscleAnatomyView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMuscleId != widget.selectedMuscleId) {
      _previousSelectedMuscleId = oldWidget.selectedMuscleId;
      if (_reduceMotion) {
        _selectionController.value = 1;
      } else {
        _selectionController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.muscles
        .where((muscle) => muscle.id == widget.selectedMuscleId)
        .firstOrNull;
    final label = selected == null
        ? 'Modello anatomico, vista ${widget.backView ? 'posteriore' : 'frontale'}'
        : '${selected.name}, ${muscleRoleLabel(selected.role)}, '
              'tensione ${tensionLabel(selected.tension.lengthened)} in allungamento, '
              '${tensionLabel(selected.tension.midRange)} nel medio ROM, '
              '${tensionLabel(selected.tension.shortened)} in accorciamento';

    return Semantics(
      label: label,
      image: true,
      child: RepaintBoundary(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: widget.onMuscleSelected == null
              ? null
              : (details) {
                  if (widget.muscles.isEmpty) return;
                  final index = (details.localPosition.dy ~/ 54).clamp(
                    0,
                    widget.muscles.length - 1,
                  );
                  widget.onMuscleSelected!(widget.muscles[index].id);
                },
          child: CustomPaint(
            painter: _AnatomyPainter(
              theme: context.exerciseTheme,
              selectedMuscleId: widget.selectedMuscleId,
              previousSelectedMuscleId: _previousSelectedMuscleId,
              backView: widget.backView,
              selectionAnimation: _selectionController,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _AnatomyPainter extends CustomPainter {
  final CoachlyExerciseTheme theme;
  final String? selectedMuscleId;
  final String? previousSelectedMuscleId;
  final bool backView;
  final Animation<double> selectionAnimation;

  _AnatomyPainter({
    required this.theme,
    required this.selectedMuscleId,
    required this.previousSelectedMuscleId,
    required this.backView,
    required this.selectionAnimation,
  }) : super(repaint: selectionAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 180, size.height / 340);
    canvas.save();
    canvas.translate((size.width - 180 * scale) / 2, 4);
    canvas.scale(scale);

    final body = Paint()
      ..color = const Color(0xFF253230)
      ..style = PaintingStyle.fill;
    final bodyEdge = Paint()
      ..color = theme.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final head = RRect.fromRectAndRadius(
      const Rect.fromLTWH(70, 2, 40, 47),
      const Radius.circular(20),
    );
    canvas.drawRRect(head, body);
    canvas.drawRRect(head, bodyEdge);

    final torso = Path()
      ..moveTo(60, 52)
      ..quadraticBezierTo(90, 43, 120, 52)
      ..lineTo(132, 155)
      ..quadraticBezierTo(116, 184, 108, 190)
      ..lineTo(72, 190)
      ..quadraticBezierTo(64, 184, 48, 155)
      ..close();
    canvas.drawPath(torso, body);
    canvas.drawPath(torso, bodyEdge);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(27, 58, 26, 132),
        const Radius.circular(13),
      ),
      body,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(127, 58, 26, 132),
        const Radius.circular(13),
      ),
      body,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(62, 178, 25, 154),
        const Radius.circular(15),
      ),
      body,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(93, 178, 25, 154),
        const Radius.circular(15),
      ),
      body,
    );

    final selectionProgress = Curves.easeOut.transform(
      selectionAnimation.value,
    );
    void muscle(Path path, Color color, String id) {
      final alpha = switch (selectedMuscleId) {
        null => 0.92,
        final selectedId when selectedId == id => lerpDouble(
          previousSelectedMuscleId == id ? 0.92 : 0.5,
          0.92,
          selectionProgress,
        )!,
        _ when previousSelectedMuscleId == id => lerpDouble(
          0.92,
          0.5,
          selectionProgress,
        )!,
        _ => 0.5,
      };
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: alpha));
    }

    final leftLat = Path()
      ..moveTo(62, 76)
      ..quadraticBezierTo(50, 100, 58, 150)
      ..lineTo(77, 171)
      ..lineTo(84, 92)
      ..close();
    final rightLat = Path()
      ..moveTo(118, 76)
      ..quadraticBezierTo(130, 100, 122, 150)
      ..lineTo(103, 171)
      ..lineTo(96, 92)
      ..close();
    muscle(leftLat, theme.primary, 'latissimus-dorsi');
    muscle(rightLat, theme.primary, 'latissimus-dorsi');

    final teresLeft = Path()..addOval(const Rect.fromLTWH(55, 69, 28, 23));
    final teresRight = Path()..addOval(const Rect.fromLTWH(97, 69, 28, 23));
    muscle(teresLeft, const Color(0xFF3DAF9E), 'teres-major');
    muscle(teresRight, const Color(0xFF3DAF9E), 'teres-major');

    final bicepsLeft = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(31, 76, 18, 58),
          const Radius.circular(8),
        ),
      );
    final bicepsRight = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(131, 76, 18, 58),
          const Radius.circular(8),
        ),
      );
    muscle(bicepsLeft, const Color(0xFF3F8F89), 'biceps-brachii');
    muscle(bicepsRight, const Color(0xFF3F8F89), 'biceps-brachii');

    final rhomboids = Path()
      ..moveTo(90, 73)
      ..lineTo(75, 96)
      ..lineTo(90, 125)
      ..lineTo(105, 96)
      ..close();
    muscle(rhomboids, theme.info, 'rhomboids');

    if (!backView) {
      canvas.drawRect(
        const Rect.fromLTWH(64, 68, 52, 48),
        Paint()..color = body.color.withValues(alpha: 0.78),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnatomyPainter oldDelegate) {
    return oldDelegate.selectedMuscleId != selectedMuscleId ||
        oldDelegate.previousSelectedMuscleId != previousSelectedMuscleId ||
        oldDelegate.backView != backView ||
        oldDelegate.theme != theme;
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
                style: TextStyle(color: colors.textSecondary, fontSize: 14),
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
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Aggiungi all’allenamento'),
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
  String? disclaimer,
}) {
  final colors = context.exerciseTheme;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surfaceElevated,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.textSecondary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Perché conta?',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              whyItMatters,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (disclaimer != null) ...[
              const SizedBox(height: 18),
              Text(
                disclaimer,
                style: TextStyle(
                  color: colors.info,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.background,
                ),
                child: const Text('Ho capito'),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: Text(
                  'Approfondisci  →',
                  style: TextStyle(color: colors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String muscleRoleLabel(MuscleRole role) => switch (role) {
  MuscleRole.primary => 'Primario',
  MuscleRole.secondary => 'Secondario',
  MuscleRole.stabilizer => 'Stabilizzatore',
};

String tensionLabel(TensionLevel level) => switch (level) {
  TensionLevel.low => 'bassa',
  TensionLevel.moderate => 'moderata',
  TensionLevel.high => 'alta',
};

class TensionDots extends StatelessWidget {
  final TensionLevel level;

  const TensionDots({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final activeCount = switch (level) {
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
        child: Center(
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
                  'Impossibile caricare l’esercizio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Riprova'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
