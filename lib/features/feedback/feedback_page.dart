import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  final _ideaController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0 && _ideaController.text.trim().isEmpty) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: _submitted ? _buildThanks(scheme) : _buildForm(scheme),
      ),
    );
  }

  Widget _buildForm(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildRatingCard(scheme),
          const SizedBox(height: 16),
          _buildIdeaCard(scheme),
          const SizedBox(height: 32),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2196F3).withValues(alpha: 0.20),
                const Color(0xFF7B4BC1).withValues(alpha: 0.20),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.tips_and_updates_rounded,
            color: Color(0xFF2196F3),
            size: 32,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Idee & Feedback',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Aiutaci a migliorare Coachly.\nOgni tuo feedback conta.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.50),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingCard(ColorScheme scheme) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconPill(
                icon: Icons.star_rounded,
                color: const Color(0xFFFFB300),
              ),
              const SizedBox(width: 10),
              const Text(
                'Come valuteresti l\'app?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedScale(
                    scale: filled ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 38,
                      color: filled
                          ? const Color(0xFFFFB300)
                          : Colors.white.withValues(alpha: 0.20),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (_rating > 0) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                _ratingLabel(_rating),
                style: const TextStyle(
                  color: Color(0xFFFFB300),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIdeaCard(ColorScheme scheme) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconPill(
                icon: Icons.edit_note_rounded,
                color: const Color(0xFF2196F3),
              ),
              const SizedBox(width: 10),
              const Text(
                'Hai suggerimenti o idee?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ideaController,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.80),
              fontSize: 14,
              height: 1.55,
            ),
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Es. "Vorrei poter vedere i progressi nel tempo..." oppure "Manca la funzione X..."',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.22),
                fontSize: 13,
                height: 1.55,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final canSubmit = _rating > 0 || _ideaController.text.trim().isNotEmpty;
    return GestureDetector(
      onTap: canSubmit ? _submit : null,
      child: AnimatedOpacity(
        opacity: canSubmit ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
            ),
            boxShadow: canSubmit
                ? [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.40),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text(
                'Invia Feedback',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThanks(ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2196F3).withValues(alpha: 0.20),
                    const Color(0xFF7B4BC1).withValues(alpha: 0.20),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 52,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Grazie mille!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Il tuo feedback è prezioso e ci aiuterà a costruire un\'app migliore per tutti.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.50),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            GestureDetector(
              onTap: () => setState(() {
                _submitted = false;
                _rating = 0;
                _ideaController.clear();
              }),
              child: Text(
                'Invia un altro feedback',
                style: TextStyle(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.80),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1:
        return 'Da migliorare';
      case 2:
        return 'Sufficiente';
      case 3:
        return 'Buona';
      case 4:
        return 'Ottima';
      case 5:
        return 'Eccellente!';
      default:
        return '';
    }
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _IconPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconPill({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: color, size: 15),
    );
  }
}
