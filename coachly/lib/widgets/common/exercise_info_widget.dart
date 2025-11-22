import 'package:flutter/material.dart';

/// Widget moderno per le informazioni dell'esercizio con video e dettagli scrollabili
class ExerciseInfoWidget extends StatelessWidget {
  final String exerciseName;
  final String? videoUrl;
  final String? technique;
  final List<String>? safetyTips;
  final List<String>? equipment;
  final VoidCallback? onClose;

  const ExerciseInfoWidget({
    super.key,
    required this.exerciseName,
    this.videoUrl,
    this.technique,
    this.safetyTips,
    this.equipment,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          _buildHeader(context),

          // Contenuto scrollabile
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video/Emoji placeholder
                  _buildVideoSection(),
                  const SizedBox(height: 24),
                  
                  // Sezione Tecnica
                  if (technique != null) ...[
                    _buildTechniqueSection(),
                    const SizedBox(height: 20),
                  ],
                  
                  // Sezione Sicurezza
                  if (safetyTips != null && safetyTips!.isNotEmpty) ...[
                    _buildSafetySection(),
                    const SizedBox(height: 20),
                  ],
                  
                  // Sezione Attrezzatura
                  if (equipment != null && equipment!.isNotEmpty)
                    _buildEquipmentSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF374151), width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              exerciseName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white70),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF374151), Color(0xFF1F2937)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4B5563),
          width: 1.5,
        ),
      ),
      child: videoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // TODO: Video player widget
                  Image.network(
                    videoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildEmojiPlaceholder();
                    },
                  ),
                  // Play button overlay
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            )
          : _buildEmojiPlaceholder(),
    );
  }

  Widget _buildEmojiPlaceholder() {
    return const Center(
      child: Text(
        '🏋️',
        style: TextStyle(fontSize: 80),
      ),
    );
  }

  Widget _buildTechniqueSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1419),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tecnica',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            technique ??
                'Mantieni i gomiti a 45° dal corpo. Scendi controllato fino allo sterno. Spingi esplosivamente fino ad estensione completa evitando di iperestendere i gomiti. Mantieni scapole retratte e petto in fuori durante tutto il movimento.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              height: 1.6,
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
          color: const Color(0xFFEF4444).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFEF4444),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sicurezza',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...((safetyTips ?? _defaultSafetyTips).map((tip) => _buildSafetyPoint(tip)).toList()),
        ],
      ),
    );
  }

  Widget _buildSafetyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
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
        color: const Color(0xFF0F1419),
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
            'Attrezzatura',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (equipment ?? _defaultEquipment)
                .map((item) => _buildEquipmentChip(item))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF10B981),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static const List<String> _defaultSafetyTips = [
    'Usa sempre uno spotter per carichi massimali',
    'Evita il rimbalzo sul petto',
    'Mantieni i polsi dritti e allineati',
    'Riscaldamento specifico obbligatorio',
  ];

  static const List<String> _defaultEquipment = [
    'Bilanciere',
    'Panca piana',
  ];
}
