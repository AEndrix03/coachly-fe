import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercises/domain/exercise_detail_view_data.dart';
import 'package:flutter/material.dart';

/// Mappa anatomica interattiva con evidenziazione dei muscoli coinvolti.
///
/// Vive nel design system perché è usata da due feature (esercizi e workout):
/// vedi la regola di promozione in `docs/development/10-components.md`.

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
      ..color = theme.surfaceElevated
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
    muscle(teresLeft, theme.primary, 'teres-major');
    muscle(teresRight, theme.primary, 'teres-major');

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
    muscle(bicepsLeft, theme.primaryMuted, 'biceps-brachii');
    muscle(bicepsRight, theme.primaryMuted, 'biceps-brachii');

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

String muscleRoleLabel(MuscleRole role) => switch (role) {
  MuscleRole.primary => 'Primario',
  MuscleRole.secondary => 'Secondario',
  MuscleRole.stabilizer => 'Stabilizzatore',
};

String tensionLabel(TensionLevel level) => switch (level) {
  TensionLevel.none => 'assente',
  TensionLevel.low => 'bassa',
  TensionLevel.moderate => 'moderata',
  TensionLevel.high => 'alta',
};
