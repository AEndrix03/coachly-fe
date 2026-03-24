import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceEntryParserServiceProvider = Provider<VoiceEntryParserService>((ref) {
  return const VoiceEntryParserService();
});

class VoiceEntryParserService {
  const VoiceEntryParserService();

  ParsedVoiceEntry parse({
    required String originalText,
    required String normalizedText,
  }) {
    var working = normalizedText;

    int? sets;
    int? reps;
    double? weightKg;

    final pattern4x8 = RegExp(r'\b(\d+)\s*[x×]\s*(\d+)\b');
    final patternSetsReps = RegExp(
      r'\b(\d+)\s*(?:sets)\s*(?:of|da|by)?\s*(\d+)\b',
    );
    final patternBy = RegExp(r'\b(\d+)\s*(?:by|da)\s*(\d+)\b');
    final patternWeight = RegExp(r'\b(\d+(?:\.\d+)?)\s*(?:kg)\b');
    final patternReps = RegExp(r'\b(\d+)\s*(?:reps)\b');
    final patternSets = RegExp(r'\b(\d+)\s*(?:sets)\b');

    final fourByEightMatch = pattern4x8.firstMatch(working);
    if (fourByEightMatch != null) {
      sets = int.tryParse(fourByEightMatch.group(1)!);
      reps = int.tryParse(fourByEightMatch.group(2)!);
      working = _stripFirst(working, fourByEightMatch.group(0)!);
    }

    if (sets == null || reps == null) {
      final setRepMatch = patternSetsReps.firstMatch(working);
      if (setRepMatch != null) {
        sets ??= int.tryParse(setRepMatch.group(1)!);
        reps ??= int.tryParse(setRepMatch.group(2)!);
        working = _stripFirst(working, setRepMatch.group(0)!);
      }
    }

    if (sets == null || reps == null) {
      final byMatch = patternBy.firstMatch(working);
      if (byMatch != null) {
        sets ??= int.tryParse(byMatch.group(1)!);
        reps ??= int.tryParse(byMatch.group(2)!);
        working = _stripFirst(working, byMatch.group(0)!);
      }
    }

    final weightMatch = patternWeight.firstMatch(working);
    if (weightMatch != null) {
      weightKg = double.tryParse(weightMatch.group(1)!);
      working = _stripFirst(working, weightMatch.group(0)!);
    }

    if (reps == null) {
      final repsMatch = patternReps.firstMatch(working);
      if (repsMatch != null) {
        reps = int.tryParse(repsMatch.group(1)!);
        working = _stripFirst(working, repsMatch.group(0)!);
      }
    }

    if (sets == null) {
      final setsMatch = patternSets.firstMatch(working);
      if (setsMatch != null) {
        sets = int.tryParse(setsMatch.group(1)!);
        working = _stripFirst(working, setsMatch.group(0)!);
      }
    }

    working = working
        .replaceAll(RegExp(r'\b(?:sets|reps|kg)\b'), ' ')
        .replaceAll(RegExp(r'\b\d+(?:\.\d+)?\b'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return ParsedVoiceEntry(
      originalText: originalText,
      normalizedText: normalizedText,
      exercisePhrase: working,
      sets: sets,
      reps: reps,
      weightKg: weightKg,
    );
  }

  String _stripFirst(String source, String pattern) {
    final escaped = RegExp.escape(pattern);
    return source.replaceFirst(RegExp(escaped), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
