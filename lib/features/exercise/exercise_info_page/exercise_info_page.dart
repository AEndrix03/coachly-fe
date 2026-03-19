import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_equipment_model/exercise_equipment_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_muscle_model/exercise_muscle_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_safety_model/exercise_safety_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_variant_model/exercise_variant_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_info_provider/exercise_info_provider.dart';
import 'package:coachly/features/user_settings/providers/settings_provider.dart';
import 'package:coachly/shared/extensions/i18n_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ExercisePage extends ConsumerStatefulWidget {
  final String id;

  const ExercisePage({super.key, required this.id});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  late final ExerciseInfoNotifier _exerciseInfoNotifier;

  @override
  void initState() {
    super.initState();
    _exerciseInfoNotifier = ref.read(exerciseInfoProvider.notifier);
    Future.microtask(() => _exerciseInfoNotifier.loadExerciseDetail(widget.id));
  }

  @override
  void dispose() {
    _exerciseInfoNotifier.clearSelectedExercise();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseInfoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.hasError
            ? _ErrorState(
                key: const ValueKey('error'),
                message: state.errorMessage ?? 'Errore sconosciuto',
                onRetry: () => ref
                    .read(exerciseInfoProvider.notifier)
                    .loadExerciseDetail(widget.id),
                onBack: () => context.pop(),
              )
            : state.isLoadingDetail || !state.hasSelectedExercise
            ? const _SkeletonState(key: ValueKey('loading'))
            : _ContentState(
                key: ValueKey(state.selectedExercise!.id),
                exercise: state.selectedExercise!,
              ),
      ),
    );
  }
}

// ─────────────────────────── skeleton ────────────────────────────────────────

class _SkeletonState extends StatelessWidget {
  const _SkeletonState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1A1A2E),
      highlightColor: const Color(0xFF2A2A4E),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header gradient placeholder
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(
                  3,
                  (_) => Expanded(
                    child: Container(
                      height: 72,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Section blocks
            ...List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Container(
                  height: i == 0 ? 140 : 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── error ───────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _BackButton(onBack: onBack),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: Color(0xFFFF5252),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Impossibile caricare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: onRetry,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF7B4BC1)],
                          ),
                        ),
                        child: const Text(
                          'Riprova',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── content ─────────────────────────────────────────

class _ContentState extends ConsumerWidget {
  final ExerciseDetailModel exercise;

  const _ContentState({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final name =
        exercise.nameI18n?.fromI18n(locale) ?? exercise.id ?? 'Esercizio';
    final description =
        exercise.descriptionI18n?.fromI18n(locale)?.trim() ?? '';
    final video = exercise.media?.firstWhereOrNull(
      (m) => m.mediaType == 'video',
    );
    final muscles = exercise.muscles ?? const [];
    final safety = exercise.safety ?? const [];
    final equipments = exercise.equipments ?? const [];
    final variants = exercise.variants ?? const [];

    return CustomScrollView(
      slivers: [
        // ── Gradient header ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _ExerciseHero(
            name: name,
            difficulty: exercise.difficultyLevel,
            mechanics: exercise.mechanicsType,
            forceType: exercise.forceType,
            isBodyweight: exercise.isBodyweight ?? false,
            videoUrl: video?.mediaUrl,
          ),
        ),
        // ── Sections ─────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty) ...[
                  _SectionBlock(
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFF2196F3),
                    title: 'Descrizione',
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (muscles.isNotEmpty) ...[
                  _SectionBlock(
                    icon: Icons.fitness_center_rounded,
                    color: const Color(0xFF9C27B0),
                    title: 'Muscoli coinvolti',
                    child: _MusclesList(muscles: muscles, locale: locale),
                  ),
                  const SizedBox(height: 20),
                ],
                if (safety.isNotEmpty) ...[
                  _SectionBlock(
                    icon: Icons.warning_rounded,
                    color: const Color(0xFFFF9800),
                    title: 'Consigli di sicurezza',
                    child: _SafetyList(safety: safety, locale: locale),
                  ),
                  const SizedBox(height: 20),
                ],
                if (equipments.isNotEmpty) ...[
                  _SectionBlock(
                    icon: Icons.build_rounded,
                    color: const Color(0xFF00BCD4),
                    title: 'Attrezzatura',
                    child: _EquipmentList(
                      equipments: equipments,
                      locale: locale,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (variants.isNotEmpty) ...[
                  _SectionBlock(
                    icon: Icons.swap_horiz_rounded,
                    color: const Color(0xFF4CAF50),
                    title: 'Varianti',
                    child: _VariantsList(variants: variants, locale: locale),
                  ),
                ],
                if (description.isEmpty &&
                    muscles.isEmpty &&
                    safety.isEmpty &&
                    equipments.isEmpty &&
                    variants.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Text(
                        'Nessuna informazione disponibile.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── hero header ─────────────────────────────────────

class _ExerciseHero extends StatelessWidget {
  final String name;
  final String? difficulty;
  final String? mechanics;
  final String? forceType;
  final bool isBodyweight;
  final String? videoUrl;

  const _ExerciseHero({
    required this.name,
    required this.difficulty,
    required this.mechanics,
    required this.forceType,
    required this.isBodyweight,
    this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF6A1B9A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button row
              Row(
                children: [
                  _BackButton(onBack: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 20),
              // Icon + name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isBodyweight
                          ? Icons.self_improvement_rounded
                          : Icons.fitness_center_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Stat chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (difficulty != null)
                    _HeroChip(
                      label: _difficultyLabel(difficulty!),
                      icon: Icons.whatshot_rounded,
                      color: _difficultyColor(difficulty!),
                    ),
                  if (mechanics != null)
                    _HeroChip(
                      label: _mechanicsLabel(mechanics!),
                      icon: Icons.sync_alt_rounded,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  if (forceType != null)
                    _HeroChip(
                      label: _forceLabel(forceType!),
                      icon: Icons.bolt_rounded,
                      color: const Color(0xFFFFD740),
                    ),
                  if (isBodyweight)
                    _HeroChip(
                      label: 'Corpo libero',
                      icon: Icons.self_improvement_rounded,
                      color: const Color(0xFF69F0AE),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(String raw) => switch (raw.toLowerCase()) {
    'beginner' => 'Principiante',
    'intermediate' => 'Intermedio',
    'advanced' => 'Avanzato',
    _ => raw,
  };

  Color _difficultyColor(String raw) => switch (raw.toLowerCase()) {
    'beginner' => const Color(0xFF69F0AE),
    'intermediate' => const Color(0xFFFFB300),
    'advanced' => const Color(0xFFFF5252),
    _ => Colors.white70,
  };

  String _mechanicsLabel(String raw) => switch (raw.toLowerCase()) {
    'compound' => 'Composto',
    'isolation' => 'Isolamento',
    _ => raw,
  };

  String _forceLabel(String raw) => switch (raw.toLowerCase()) {
    'push' => 'Spinta',
    'pull' => 'Trazione',
    'legs' => 'Gambe',
    'core' => 'Core',
    'static' => 'Statico',
    _ => raw,
  };
}

class _HeroChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _HeroChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── section block ───────────────────────────────────

class _SectionBlock extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Widget child;

  const _SectionBlock({
    required this.icon,
    required this.color,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 15),
            ),
            const SizedBox(width: 9),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
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
        ),
      ],
    );
  }
}

// ─────────────────────────── muscles list ────────────────────────────────────

class _MusclesList extends StatelessWidget {
  final List<ExerciseMuscleModel> muscles;
  final Locale locale;

  const _MusclesList({required this.muscles, required this.locale});

  @override
  Widget build(BuildContext context) {
    final sorted = [...muscles]
      ..sort(
        (a, b) => (b.activationPercentage ?? 0).compareTo(
          a.activationPercentage ?? 0,
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sorted.asMap().entries.map((entry) {
        final m = entry.value;
        final name = m.muscle?.nameI18n.fromI18n(locale) ?? 'N/A';
        final activation = m.activationPercentage ?? 0;
        final isLast = entry.key == sorted.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (activation > 0)
                    Text(
                      '$activation%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              if (activation > 0) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: activation / 100,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF9C27B0),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────── safety list ─────────────────────────────────────

class _SafetyList extends StatelessWidget {
  final List<ExerciseSafetyModel> safety;
  final Locale locale;

  const _SafetyList({required this.safety, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: safety.asMap().entries.map((entry) {
        final isLast = entry.key == safety.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
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
                  entry.value.safetyNotesI18n.fromI18n(locale),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────── equipment list ──────────────────────────────────

class _EquipmentList extends StatelessWidget {
  final List<ExerciseEquipmentModel> equipments;
  final Locale locale;

  const _EquipmentList({required this.equipments, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: equipments.map((e) {
        final label = e.equipment.nameI18n.fromI18n(locale);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00BCD4).withValues(alpha: 0.18),
                const Color(0xFF00BCD4).withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF00BCD4).withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────── variants list ───────────────────────────────────

class _VariantsList extends StatelessWidget {
  final List<ExerciseVariantModel> variants;
  final Locale locale;

  const _VariantsList({required this.variants, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: variants.asMap().entries.map((entry) {
        final v = entry.value;
        final isLast = entry.key == variants.length - 1;
        final name = v.nameI18n?.fromI18n(locale) ?? v.id ?? 'N/A';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50).withValues(alpha: 0.25),
                        const Color(0xFF4CAF50).withValues(alpha: 0.10),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Color(0xFF4CAF50),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (v.difficultyLevel != null)
                        Text(
                          v.difficultyLevel!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isLast) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
              const SizedBox(height: 12),
            ],
          ],
        );
      }).toList(),
    );
  }
}

// ─────────────────────────── back button ─────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onBack;

  const _BackButton({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
