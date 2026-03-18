import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Read-only exercise card used in workout detail (and wherever a non-edit
/// view of a workout exercise is needed).
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

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);

    return InkWell(
      onTap: _toggleExpanded,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
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
            color: Colors.white.withValues(alpha: _isExpanded ? 0.2 : 0.1),
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
            _buildMainContent(locale),
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
            _buildBottomBar(),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: _buildExpandedContent(locale),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Locale locale) {
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTag(
                        exercise.muscles?.firstOrNull?.muscle?.nameI18n
                                .fromI18n(locale) ??
                            'N/A',
                        const Color(0xFF2196F3),
                        Icons.fitness_center,
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        exercise.difficultyLevel ?? 'N/A',
                        const Color(0xFFFF9800),
                        Icons.whatshot,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildHeaderActions(),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.open_in_new,
          onTap: _hasExerciseId ? _openExerciseDetail : null,
          color: const Color(0xFF2196F3),
          tooltip: 'Apri dettaglio esercizio',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: _isExpanded ? Icons.expand_less : Icons.expand_more,
          onTap: _toggleExpanded,
          color: Colors.white,
          tooltip: _isExpanded ? 'Collassa' : 'Espandi',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
    required Color color,
    required String tooltip,
  }) {
    final isEnabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: isEnabled ? 0.18 : 0.08),
                color.withValues(alpha: isEnabled ? 0.08 : 0.03),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: isEnabled ? 0.35 : 0.15),
              width: 1.2,
            ),
          ),
          child: Icon(
            icon,
            color: isEnabled
                ? color.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.3),
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final progressFormat = NumberFormat.percentPattern();
    final progressText = widget.workoutExercise.progress > 0
        ? '+${progressFormat.format(widget.workoutExercise.progress)}'
        : '';

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
          _buildInfoChip(Icons.repeat, widget.workoutExercise.sets),
          const SizedBox(width: 12),
          _buildInfoChip(Icons.timer_outlined, widget.workoutExercise.rest),
          const Spacer(),
          _buildWeightChip(),
          if (progressText.isNotEmpty) ...[
            const SizedBox(width: 8),
            _buildProgressChip(progressText),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Locale locale) {
    final description = widget.workoutExercise.exercise.descriptionI18n
        ?.fromI18n(locale)
        .trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(19),
          bottomRight: Radius.circular(19),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(
                'Serie ${widget.workoutExercise.sets}',
                const Color(0xFF2196F3),
                Icons.repeat,
              ),
              _buildTag(
                'Recupero ${widget.workoutExercise.rest}',
                const Color(0xFF7B4BC1),
                Icons.timer_outlined,
              ),
              _buildTag(
                'Carico ${widget.workoutExercise.weight}',
                const Color(0xFF00BCD4),
                Icons.fitness_center,
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _hasExerciseId ? _openExerciseDetail : null,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF90CAF9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text(
                'Dettaglio esercizio',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
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

  Widget _buildInfoChip(IconData icon, String text) {
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

  Widget _buildWeightChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Text(
        widget.workoutExercise.weight,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildProgressChip(String progressText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withValues(alpha: 0.25),
            const Color(0xFF4CAF50).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Text(
        progressText,
        style: const TextStyle(
          color: Color(0xFF4CAF50),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  Future<void> _openExerciseDetail() async {
    final exerciseId = _exerciseId;
    if (exerciseId == null || exerciseId.isEmpty) return;

    final repository = ref.read(exerciseInfoPageRepositoryProvider);
    final response = await repository.getExerciseDetail(exerciseId);

    if (!mounted) return;

    if (!response.success || response.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossibile caricare il dettaglio esercizio. Riprova.',
          ),
        ),
      );
      return;
    }

    context.push(
      '/workouts/workout/${widget.workoutId}/workout_exercise_page/$exerciseId',
    );
  }

  String _displayName(Locale locale) {
    final localName = widget.workoutExercise.exercise.nameI18n?.fromI18n(
      locale,
    );
    if (_isValidDisplayName(localName)) {
      return localName!.trim();
    }

    if (_isValidDisplayName(_resolvedExerciseName)) {
      return _resolvedExerciseName!.trim();
    }

    return 'Esercizio ${widget.exerciseNumber}';
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
