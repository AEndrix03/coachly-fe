import 'package:flutter/material.dart';

class ActiveAppBar extends StatelessWidget {
  final String elapsedTime;
  final int currentExercise;
  final int totalExercises;

  const ActiveAppBar({
    super.key,
    required this.elapsedTime,
    required this.currentExercise,
    required this.totalExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1E2A), Color(0xFF14141F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2A3A), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () => _showCancelDialog(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$elapsedTime | $currentExercise/$totalExercises',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.pause, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: Implementare pausa
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A3A), Color(0xFF1E1E2A)],
              ),
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
              color: const Color(0xFF1E1E2A),
              offset: const Offset(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                const PopupMenuItem(
                  value: 'notes',
                  child: Row(
                    children: [
                      Icon(Icons.note_outlined, color: Colors.white70, size: 20),
                      SizedBox(width: 12),
                      Text('Note allenamento', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history, color: Colors.white70, size: 20),
                      SizedBox(width: 12),
                      Text('Storico scheda', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'discard',
                  child: Row(
                    children: [
                      Icon(Icons.close, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Text('Termina e scarta', style: TextStyle(color: Colors.red)),
                    ],
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
        backgroundColor: const Color(0xFF1E1E2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Annulla allenamento?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'I progressi attuali non verranno salvati.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continua', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Annulla', style: TextStyle(color: Colors.red)),
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
        backgroundColor: const Color(0xFF1E1E2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Terminare e scartare?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tutti i dati di questo allenamento verranno eliminati.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Scarta', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}
