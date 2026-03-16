import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutEmptyState extends StatefulWidget {
  const WorkoutEmptyState({super.key});

  @override
  State<WorkoutEmptyState> createState() => _WorkoutEmptyStateState();
}

class _WorkoutEmptyStateState extends State<WorkoutEmptyState>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _pulseCtrl;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _floatAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -7.0, end: 7.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildHero(),
              const Spacer(flex: 1),
              _buildText(),
              const SizedBox(height: 44),
              _buildCTA(context),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return SizedBox(
      width: 290,
      height: 290,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer radial glow
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF2196F3).withValues(alpha: 0.18),
                  const Color(0xFF7B4BC1).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Dashed ring
          Container(
            width: 186,
            height: 186,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.07),
                width: 1,
              ),
            ),
          ),
          // Main pulsing icon circle
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.48),
                      blurRadius: 44,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: const Color(0xFF7B4BC1).withValues(alpha: 0.22),
                      blurRadius: 64,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 58,
                ),
              ),
            ),
          ),
          // Top-right: lightning
          _FloatingChip(
            animation: _floatAnim,
            factor: 0.5,
            top: 18,
            right: 22,
            icon: Icons.bolt,
            color: const Color(0xFFFF9800),
          ),
          // Bottom-left: fire
          _FloatingChip(
            animation: _floatAnim,
            factor: -0.5,
            bottom: 22,
            left: 20,
            icon: Icons.local_fire_department,
            color: const Color(0xFFFF5252),
          ),
          // Top-left: star
          _FloatingChip(
            animation: _floatAnim,
            factor: -0.7,
            top: 42,
            left: 38,
            icon: Icons.star_rounded,
            color: const Color(0xFF9C27B0),
            small: true,
          ),
          // Bottom-right: trending up
          _FloatingChip(
            animation: _floatAnim,
            factor: 0.7,
            bottom: 42,
            right: 36,
            icon: Icons.trending_up,
            color: const Color(0xFF4CAF50),
            small: true,
          ),
        ],
      ),
    );
  }

  // ── Text ──────────────────────────────────────────────────────────────────

  Widget _buildText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF64B5F6), Color(0xFFCE93D8)],
            ).createShader(bounds),
            child: const Text(
              'Crea la tua\nprima scheda!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1.18,
                letterSpacing: -0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Progetta allenamenti su misura per te.\nInizia il tuo percorso fitness oggi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ── CTA ───────────────────────────────────────────────────────────────────

  Widget _buildCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: () => context.push('/workouts/workout/new/edit'),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withValues(alpha: 0.42),
                blurRadius: 28,
                offset: const Offset(0, 10),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top shine
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 29,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Iniziamo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Floating icon chip ──────────────────────────────────────────────────────

class _FloatingChip extends StatelessWidget {
  final Animation<double> animation;
  final double factor;
  final IconData icon;
  final Color color;
  final bool small;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _FloatingChip({
    required this.animation,
    required this.factor,
    required this.icon,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final offset = animation.value * factor;
        return Positioned(
          top: top != null ? top! + offset : null,
          bottom: bottom != null ? bottom! - offset : null,
          left: left,
          right: right,
          child: Container(
            padding: EdgeInsets.all(small ? 7 : 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(small ? 10 : 13),
              color: color.withValues(alpha: 0.14),
              border: Border.all(
                color: color.withValues(alpha: 0.28),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 14,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: small ? 16 : 20),
          ),
        );
      },
    );
  }
}
