import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:coachly/design_system/theme/exercise_theme.dart';
import 'package:coachly/features/exercise/exercise_info_page/presentation/widgets/exercise_detail_widgets.dart';
import 'package:coachly/features/exercise/exercise_info_page/providers/exercise_detail_view_provider.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExerciseVariantsPage extends ConsumerWidget {
  final String exerciseId;

  const ExerciseVariantsPage({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(exerciseDetailViewProvider(exerciseId));
    return Theme(
      data: exerciseDetailTheme(Theme.of(context)),
      child: asyncData.when(
        loading: () => const ExerciseLoadingView(),
        error: (_, _) => ExerciseErrorView(
          onRetry: () => ref.invalidate(exerciseDetailViewProvider(exerciseId)),
        ),
        data: (data) => ExerciseVariantsContent(data: data),
      ),
    );
  }
}

class ExerciseVariantsContent extends StatefulWidget {
  final ExerciseDetailViewData data;

  const ExerciseVariantsContent({super.key, required this.data});

  @override
  State<ExerciseVariantsContent> createState() =>
      _ExerciseVariantsContentState();
}

class _ExerciseVariantsContentState extends State<ExerciseVariantsContent> {
  String _filter = 'Tutte';

  List<String> get _filters {
    final axes = widget.data.variants
        .map((variant) => variant.relationAxis)
        .toSet();
    return ['Tutte', ...axes];
  }

  List<VariantViewData> get _variants => _filter == 'Tutte'
      ? widget.data.variants
      : widget.data.variants
            .where((variant) => variant.relationAxis == _filter)
            .toList();

  @override
  Widget build(BuildContext context) {
    final filters = _filters;
    final variants = _variants;
    return ExerciseDetailScaffold(
      title: context.tr('exercise.variants.title'),
      exerciseName: widget.data.name,
      body: CustomScrollView(
        key: const Key('variants-page-scroll'),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return FilterChip(
                    key: Key('variant-filter-$filter'),
                    selected: _filter == filter,
                    label: Text(filter),
                    onSelected: (_) {
                      if (_filter == filter) return;
                      HapticFeedback.selectionClick();
                      setState(() => _filter = filter);
                    },
                    selectedColor: context.exerciseTheme.primaryMuted,
                    backgroundColor: context.exerciseTheme.surface,
                    side: BorderSide(color: context.exerciseTheme.border),
                    labelStyle: TextStyle(
                      color: _filter == filter
                          ? context.exerciseTheme.textPrimary
                          : context.exerciseTheme.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            sliver: SliverList.separated(
              itemCount: variants.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final variant = variants[index];
                return VariantTile(
                  variant: variant,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (variant.id.isNotEmpty) {
                      context.push('/exercises/${variant.id}');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VariantTile extends StatelessWidget {
  final VariantViewData variant;
  final VoidCallback onTap;

  const VariantTile({super.key, required this.variant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.exerciseTheme;
    final similarity = variant.similarity;
    return Semantics(
      button: true,
      label: [
        variant.name,
        variant.relationAxis,
        if (similarity != null) _similarityLabel(similarity),
      ].join(', '),
      child: InkWell(
        key: Key('variant-${variant.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 74,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: colors.primary.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.name,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          variant.relationAxis.toUpperCase(),
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                          ),
                        ),
                        if (variant.similarity case final similarity?)
                          Text(
                            _similarityLabel(similarity),
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      variant.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  static String _similarityLabel(VariantSimilarity value) => switch (value) {
    VariantSimilarity.verySimilar => 'Molto simile',
    VariantSimilarity.similar => 'Simile',
    VariantSimilarity.different => 'Diversa',
  };
}
