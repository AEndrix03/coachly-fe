import 'package:coachly/features/ai_coach/application/ai_coach_notifier.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestionsRow extends ConsumerWidget {
  const SuggestionsRow({super.key, required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 38,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: suggestions
              .map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      final notifier = ref.read(
                        aiCoachProvider.notifier,
                      );
                      notifier.clearSuggestions();
                      notifier.sendMessage(suggestion);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AiCoachTheme.bgSurface,
                        border: Border.all(color: AiCoachTheme.borderMid),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AiCoachTheme.suggestionText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
