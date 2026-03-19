import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Read-only exercise card — same visual style as EditableExerciseCard but
/// without drag handle, edit fields, delete and variant buttons.
class WorkoutExerciseViewCard extends ConsumerStatefulWidget {
  final WorkoutExerciseModel workoutExercise;
  final String workoutId;
  final int exerciseNumber;

  const WorkoutExerciseViewCard({
    super.key,
    required this.workoutExercise,
    required this.workoutId,
    required this.exerciseNumber,
  });

  @override
  ConsumerState<WorkoutExerciseViewCard> createState() =>
      _WorkoutExerciseViewCardState();
}

class _WorkoutExerciseViewCardState
    extends ConsumerState<WorkoutExerciseViewCard> {
  bool _isExpanded = false;
  bool _isResolvingName = false;
  bool _triedNameResolution = false;
  String? _resolvedExerciseName;

  String? get _exerciseId => widget.workoutExercise.exercise.id?.trim();
  bool get _hasExerciseId => (_exerciseId?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    _resolveExerciseNameIfNeeded();
  }

  @override
  void didUpdateWidget(covariant WorkoutExerciseViewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workoutExercise.exercise.id !=
        widget.workoutExercise.exercise.id) {
      _resolvedExerciseName = null;
      _triedNameResolution = false;
      _resolveExerciseNameIfNeeded();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A2A3E).withValues(alpha: 0.6),
            const Color(0xFF1A1A2E).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          width: 1.5,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMainContent(),
          // Summary bar — visible only when collapsed
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                _buildSummaryBar(),
              ],
            ),
          ),
          // Read-only detail — visible only when expanded
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildReadOnlyFields(),
          ),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildMainContent() {
    final locale = ref.watch(languageProvider);
    final exercise = widget.workoutExercise.exercise;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _buildNumberBadge(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _displayName(locale),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (_isResolvingName) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag(
                      exercise.muscles?.firstOrNull?.muscle?.nameI18n.fromI18n(
                            locale,
                          ) ??
                          context.tr('common.na'),
                      const Color(0xFF2196F3),
                      Icons.fitness_center,
                    ),
                    _buildTag(
                      exercise.difficultyLevel ?? context.tr('common.na'),
                      const Color(0xFFFF9800),
                      Icons.whatshot,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildNumberBadge() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A4A5E), Color(0xFF2A2A3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 2,
          color: Colors.white.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.exerciseNumber.toString(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          Colors.white,
          _toggleExpanded,
        ),
        if (_hasExerciseId) ...[
          const SizedBox(height: 8),
          _buildIconButton(
            LucideIcons.eye,
            const Color(0xFF2196F3),
            _openExerciseDetail,
          ),
        ],
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ─── Summary bar (collapsed) ───────────────────────────────────────────────

  Widget _buildSummaryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(19),
          bottomRight: _isExpanded ? Radius.zero : const Radius.circular(19),
        ),
      ),
      child: Row(
        children: [
          _buildSummaryChip(Icons.repeat, widget.workoutExercise.sets),
          const SizedBox(width: 10),
          _buildSummaryChip(Icons.timer_outlined, widget.workoutExercise.rest),
          const Spacer(),
          _buildSummaryChip(
            Icons.fitness_center,
            widget.workoutExercise.weight,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ─── Expanded read-only fields ─────────────────────────────────────────────

  Widget _buildReadOnlyFields() {
    final locale = ref.read(languageProvider);
    final ex = widget.workoutExercise;
    final sets = _extractSetParts(ex.sets);
    final restValue = ex.rest.replaceAll(RegExp(r'[^0-9]'), '');
    final weightValue = ex.weight.replaceAll(RegExp(r'[^0-9.]'), '');
    final description =
        ex.exercise.descriptionI18n?.fromI18n(locale).trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(19),
          bottomRight: Radius.circular(19),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildReadOnlyField(context.tr('workout.sets'), sets.$1),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReadOnlyField(context.tr('workout.reps'), sets.$2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReadOnlyField(
                  context.tr('workout.load'),
                  weightValue,
                  suffix: 'kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildReadOnlyField(
            context.tr('workout.rest'),
            restValue,
            suffix: 's',
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildReadOnlyField(
              context.tr('workout.description'),
              description,
              multiline: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(
    String label,
    String value, {
    String? suffix,
    bool multiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: multiline ? 5 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffix != null && value.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  suffix,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  (String, String) _extractSetParts(String rawSets) {
    final matches = RegExp(
      r'\d+',
    ).allMatches(rawSets).map((m) => m.group(0)!).toList();
    if (matches.length >= 2) return (matches[0], matches[1]);
    if (matches.length == 1) return (matches[0], '');
    return ('', '');
  }

  Widget _buildTag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpanded() {
    if (!mounted) return;
    setState(() => _isExpanded = !_isExpanded);
  }

  void _openExerciseDetail() {
    final exerciseId = _exerciseId;
    if (exerciseId == null || exerciseId.isEmpty) return;
    context.push(
      '/workouts/workout/${widget.workoutId}/workout_exercise_page/$exerciseId',
    );
  }

  String _displayName(Locale locale) {
    final localName = widget.workoutExercise.exercise.nameI18n?.fromI18n(
      locale,
    );
    if (_isValidDisplayName(localName)) return localName!.trim();
    if (_isValidDisplayName(_resolvedExerciseName)) {
      return _resolvedExerciseName!.trim();
    }
    return 'Exercise ${widget.exerciseNumber}';
  }

  bool _isValidDisplayName(String? name) {
    if (name == null) return false;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    final exerciseId = _exerciseId;
    if (exerciseId != null && trimmed == exerciseId) return false;
    return true;
  }

  bool _hasEmbeddedDisplayName() {
    final names = widget.workoutExercise.exercise.nameI18n;
    if (names == null || names.isEmpty) return false;
    return names.values.any(_isValidDisplayName);
  }

  Future<void> _resolveExerciseNameIfNeeded() async {
    if (_triedNameResolution || _hasEmbeddedDisplayName()) return;

    final exerciseId = _exerciseId;
    if (exerciseId == null || exerciseId.isEmpty) return;

    _triedNameResolution = true;
    if (mounted) setState(() => _isResolvingName = true);

    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    final response = await repository.getExerciseDetail(exerciseId);

    if (!mounted) return;

    final locale = ref.read(languageProvider);
    final resolvedName = response.data?.nameI18n?.fromI18n(locale);

    setState(() {
      _isResolvingName = false;
      _resolvedExerciseName = _isValidDisplayName(resolvedName)
          ? resolvedName
          : null;
    });
  }
}
