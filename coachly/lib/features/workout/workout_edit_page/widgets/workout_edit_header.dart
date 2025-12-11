import 'package:coachly/shared/widgets/buttons/glass_icon_button.dart';
import 'package:flutter/material.dart';

class WorkoutEditHeader extends StatelessWidget {
  final String title;
  final bool isDirty;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final Function(String) onTitleChanged;

  const WorkoutEditHeader({
    super.key,
    required this.title,
    required this.isDirty,
    required this.isSaving,
    required this.onBack,
    required this.onSave,
    required this.onTitleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF7B4BC1)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildAppBar(context), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          GlassIconButton(
            icon: Icons.arrow_back,
            onPressed: () => _handleBack(context),
            marginRight: 8,
          ),
          const Spacer(),
          if (isDirty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF9800).withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Modificato',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isSaving ? null : onSave,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSaving
                    ? LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.3),
                          Colors.grey.withOpacity(0.2),
                        ],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                      ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSaving
                      ? Colors.white.withOpacity(0.2)
                      : const Color(0xFF4CAF50),
                  width: 2,
                ),
                boxShadow: [
                  if (!isSaving)
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSaving)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(Icons.check, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isSaving ? 'Salvataggio...' : 'Salva',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: title)
              ..selection = TextSelection.collapsed(offset: title.length),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              hintText: 'Nome scheda...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onTitleChanged,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Modalità Modifica',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  void _handleBack(BuildContext context) {
    if (isDirty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text(
            'Modifiche non salvate',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Hai modifiche non salvate. Vuoi uscire senza salvare?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onBack();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF5252),
              ),
              child: const Text('Esci'),
            ),
          ],
        ),
      );
    } else {
      onBack();
    }
  }
}
