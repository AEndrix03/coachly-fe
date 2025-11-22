import 'package:flutter/material.dart';
import 'dart:async';

/// Widget moderno per il timer di recupero con countdown prossima serie
class RestTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onTimerComplete;
  final VoidCallback? onClose;

  const RestTimerWidget({
    super.key,
    this.initialSeconds = 90,
    this.onTimerComplete,
    this.onClose,
  });

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopTimer();
        widget.onTimerComplete?.call();
        // TODO: Play sound/vibration
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _addTime(int seconds) {
    setState(() => _remainingSeconds += seconds);
    if (!_isRunning && _remainingSeconds > 0) {
      _startTimer();
    }
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping card
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F2937), Color(0xFF111827)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFF374151),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recupero',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white70, size: 26),
                        onPressed: widget.onClose,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Timer Display con animazione
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final isWarning = _remainingSeconds <= 10 && _isRunning;
                      return Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isWarning
                                ? [
                                    Color(0xFFEF4444).withOpacity(
                                        0.8 + _pulseController.value * 0.2),
                                    Color(0xFFDC2626).withOpacity(
                                        0.8 + _pulseController.value * 0.2),
                                  ]
                                : const [Color(0xFF6366F1), Color(0xFF4F46E5)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isWarning
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF6366F1))
                                  .withOpacity(0.5),
                              blurRadius: 24,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formattedTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isRunning ? 'Prossima serie' : 'Pronto',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // Controls
                  if (!_isRunning) ...[
                    // Start button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: _startTimer,
                        icon: const Icon(Icons.play_arrow_rounded, size: 26),
                        label: const Text(
                          'Parti Adesso',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Quick add buttons
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildQuickButton('+15s', () => _addTime(15)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildQuickButton('+30s', () => _addTime(30)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildQuickButton('+60s', () => _addTime(60)),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Running controls
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 58,
                              child: ElevatedButton.icon(
                                onPressed: _stopTimer,
                                icon:
                                    const Icon(Icons.pause_rounded, size: 22),
                                label: const Text(
                                  'Pausa',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF374151),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 58,
                              child: ElevatedButton.icon(
                                onPressed: () => _addTime(15),
                                icon: const Icon(Icons.add_rounded, size: 22),
                                label: const Text(
                                  '+15sec',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  shadowColor: const Color(0xFF6366F1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF4B5563), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
