import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/rest_timer_provider.dart';

class ActiveAppBar extends ConsumerStatefulWidget {
  final int currentExercise;
  final int totalExercises;

  const ActiveAppBar({
    super.key,
    required this.currentExercise,
    required this.totalExercises,
  });

  @override
  ConsumerState<ActiveAppBar> createState() => _ActiveAppBarState();
}

class _ActiveAppBarState extends ConsumerState<ActiveAppBar> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1F2937), Color(0xFF111827)],
        ),
        border: Border(
          bottom: BorderSide(color: Color(0xFF374151), width: 1.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main app bar content - PADDING RIDOTTO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  // Back button - STILE COPIATO
                  _buildIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => _showCancelDialog(context),
                  ),

                  const SizedBox(width: 12),

                  // Time and exercise counter
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // RIDOTTO SPAZIO
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formattedTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF3B82F6).withOpacity(0.3),
                                const Color(0xFF2563EB).withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF3B82F6).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Esercizio ${widget.currentExercise}/${widget.totalExercises}',
                            style: const TextStyle(
                              color: Color(0xFF60A5FA),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pause button - STILE COPIATO
                  _buildIconButton(
                    icon: Icons.pause_rounded,
                    onPressed: () {
                      // TODO: Implementare pausa
                      _timer.cancel();
                    },
                  ),

                  const SizedBox(width: 8),

                  // Menu button - STILE COPIATO
                  _buildMenuButton(context),
                ],
              ),
            ),

            // Rest timer bar - appare solo quando attivo
            _buildRestTimerBar(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildRestTimerBar(WidgetRef ref) {
    final timerState = ref.watch(restTimerProvider);

    if (!timerState.isActive) return const SizedBox.shrink();

    final minutes = timerState.remainingSeconds ~/ 60;
    final seconds = timerState.remainingSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        border: Border(top: BorderSide(color: Color(0xFF374151), width: 1)),
      ),
      child: Row(
        children: [
          // Icona notte
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.bedtime,
              color: Color(0xFF60A5FA),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Timer
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),

          const SizedBox(width: 16),

          // Pulsante +15s
          _buildIconButton(
            icon: Icons.add,
            onPressed: () => ref.read(restTimerProvider.notifier).addTime(15),
          ),

          const Spacer(),

          // Pulsante X
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF991B1B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFDC2626).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFFEF4444), size: 18),
              onPressed: () => ref.read(restTimerProvider.notifier).stopTimer(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // STILE COPIATO DA workout_detail_header.dart e exercise_header.dart
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // STILE COPIATO
        borderRadius: BorderRadius.circular(14), // STILE COPIATO (non cerchio!)
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // STILE COPIATO
        borderRadius: BorderRadius.circular(14), // STILE COPIATO (non cerchio!)
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
          size: 22,
        ),
        color: const Color(0xFF1F2937),
        offset: const Offset(0, 52),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF374151), width: 1.5),
        ),
        onSelected: (value) {
          switch (value) {
            case 'notes':
              // TODO: Note allenamento
              break;
            case 'history':
              // TODO: Storico scheda
              break;
            case 'discard':
              _showDiscardDialog(context);
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'notes',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note_outlined,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Note allenamento',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'history',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Storico scheda',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(height: 1),
          PopupMenuItem(
            value: 'discard',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Termina e scarta',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF374151), width: 1.5),
        ),
        title: const Text(
          'Annulla allenamento?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'I progressi attuali non verranno salvati.',
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Continua',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade400.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Annulla',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showDiscardDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF374151), width: 1.5),
        ),
        title: const Text(
          'Terminare e scartare?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Tutti i dati di questo allenamento verranno eliminati.',
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Annulla',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade400.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Scarta',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}
