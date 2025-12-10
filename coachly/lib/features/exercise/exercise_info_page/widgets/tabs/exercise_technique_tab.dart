import 'package:flutter/material.dart';

class ExerciseTechniqueTab extends StatelessWidget {
  const ExerciseTechniqueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTechniqueCard(
            icon: Icons.published_with_changes,
            iconColor: const Color(0xFFFF4081),
            title: 'Setup Iniziale',
            description:
                'Sdraiati sulla panca con piedi ben piantati a terra. Scapole retratte e petto in fuori. Afferra il bilanciere con presa poco più larga delle spalle.',
            iconGradient: [const Color(0xFFFF4081), const Color(0xFFF50057)],
          ),
          const SizedBox(height: 16),
          _buildTechniqueCard(
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF2196F3),
            title: 'Fase Eccentrica',
            description:
                'Abbassa il bilanciere in modo controllato verso lo sterno. I gomiti formano un angolo di 45° con il corpo. Mantieni tensione continua.',
            iconGradient: [const Color(0xFF2196F3), const Color(0xFF1976D2)],
          ),
          const SizedBox(height: 16),
          _buildTechniqueCard(
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFF4CAF50),
            title: 'Fase Concentrica',
            description:
                'Spingi esplosivamente il bilanciere verso l\'alto seguendo una traiettoria leggermente diagonale. Espira durante la spinta.',
            iconGradient: [const Color(0xFF4CAF50), const Color(0xFF388E3C)],
          ),
          const SizedBox(height: 16),
          _buildTechniqueCard(
            icon: Icons.air,
            iconColor: const Color(0xFF9C27B0),
            title: 'Respirazione',
            description:
                'Inspira profondamente durante la discesa, trattieni brevemente in basso, espira potentemente durante la salita.',
            iconGradient: [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)],
          ),
          const SizedBox(height: 20),
          _buildSafetySection(),
          const SizedBox(height: 20),
          _buildEquipmentSection(),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required List<Color> iconGradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: iconGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetySection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B1B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF5252).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning,
                  color: Color(0xFFFF5252),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Consigli di Sicurezza',
                style: TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildSafetyPoint('Usa sempre spotter per carichi massimali'),
          _buildSafetyPoint('Evita il rimbalzo sul petto'),
          _buildSafetyPoint('Mantieni i polsi dritti e allineati'),
          _buildSafetyPoint('Riscaldamento specifico obbligatorio'),
        ],
      ),
    );
  }

  Widget _buildSafetyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attrezzatura Necessaria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildEquipmentChip('Bilanciere'),
              _buildEquipmentChip('Panca piana'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2196F3),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
