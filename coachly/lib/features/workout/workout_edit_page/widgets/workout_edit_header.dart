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
          // Removed "Modificato" chip
          const SizedBox(width: 8),
          Stack(
            children: [
              GlassIconButton(
                icon: Icons.save,
                onPressed: isSaving ? null : onSave,
                iconColor: Colors.white,
                size: 20,
                marginRight: 0,
              ),
              if (isDirty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
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
          // Removed "Modalità Modifica" chip
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
