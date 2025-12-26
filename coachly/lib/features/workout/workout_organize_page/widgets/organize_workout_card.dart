import 'dart:ui';

import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:coachly/shared/widgets/badges/coach_badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganizeWorkoutCard extends ConsumerStatefulWidget {
  final WorkoutModel workout;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onEdit;

  const OrganizeWorkoutCard({
    super.key,
    required this.workout,
    required this.onDelete,
    required this.onToggleActive,
    required this.onEdit,
  });

  @override
  ConsumerState<OrganizeWorkoutCard> createState() =>
      _OrganizeWorkoutCardState();
}

class _OrganizeWorkoutCardState extends ConsumerState<OrganizeWorkoutCard> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.workout.active;
  }

  @override
  void didUpdateWidget(covariant OrganizeWorkoutCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workout != oldWidget.workout) {
      setState(() {
        _isActive = widget.workout.active;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isActive ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF23233A).withOpacity(0.85),
              const Color(0xFF2A2A3E).withOpacity(0.65),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIconSection(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.workout.titleI18n.fromI18n(language),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.15,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const CoachBadgeWidget(
                              fontSize: 9,
                              iconSize: 10,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _buildInfoChip(
                              Icons.fitness_center,
                              '${widget.workout.workoutExercises.length} esercizi',
                            ),
                            _buildInfoChip(
                              Icons.person_outline,
                              'Coach ${widget.workout.coachName ?? 'N/A'}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (String result) {
                      if (result == 'toggleActive') {
                        setState(() {
                          _isActive = !_isActive;
                        });
                        widget.onToggleActive(_isActive);
                      } else if (result == 'edit') {
                        widget.onEdit();
                      } else if (result == 'delete') {
                        widget.onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'toggleActive',
                            child: Text(_isActive ? 'Disattiva' : 'Attiva'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Modifica'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Elimina'),
                          ),
                        ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.16),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Icon(Icons.assignment, color: Colors.white, size: 18),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.80), size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.80),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
