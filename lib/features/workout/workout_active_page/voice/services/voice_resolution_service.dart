import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:coachly/features/workout/workout_active_page/voice/repositories/user_voice_alias_repository.dart';
import 'package:coachly/features/workout/workout_active_page/voice/repositories/voice_exercise_catalog_repository.dart';
import 'package:coachly/features/workout/workout_active_page/voice/repositories/voice_resolution_log_repository.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/exercise_candidate_retriever_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/exercise_reranker_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/match_confidence_decider_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/voice_entry_parser_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/services/voice_text_normalization_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceResolutionServiceProvider = Provider<VoiceResolutionService>((ref) {
  final textNormalizer = ref.watch(voiceTextNormalizationServiceProvider);
  final parser = ref.watch(voiceEntryParserServiceProvider);
  final catalogRepository = ref.watch(voiceExerciseCatalogRepositoryProvider);
  final retriever = ref.watch(exerciseCandidateRetrieverServiceProvider);
  final reranker = ref.watch(exerciseRerankerServiceProvider);
  final decider = ref.watch(matchConfidenceDeciderServiceProvider);
  final aliasRepository = ref.watch(userVoiceAliasRepositoryProvider);
  final logRepository = ref.watch(voiceResolutionLogRepositoryProvider);

  return VoiceResolutionService(
    textNormalizer: textNormalizer,
    parser: parser,
    catalogRepository: catalogRepository,
    retriever: retriever,
    reranker: reranker,
    decider: decider,
    aliasRepository: aliasRepository,
    logRepository: logRepository,
  );
});

class VoiceResolutionService {
  const VoiceResolutionService({
    required VoiceTextNormalizationService textNormalizer,
    required VoiceEntryParserService parser,
    required VoiceExerciseCatalogRepository catalogRepository,
    required ExerciseCandidateRetrieverService retriever,
    required ExerciseRerankerService reranker,
    required MatchConfidenceDeciderService decider,
    required UserVoiceAliasRepository aliasRepository,
    required VoiceResolutionLogRepository logRepository,
  }) : _textNormalizer = textNormalizer,
       _parser = parser,
       _catalogRepository = catalogRepository,
       _retriever = retriever,
       _reranker = reranker,
       _decider = decider,
       _aliasRepository = aliasRepository,
       _logRepository = logRepository;

  final VoiceTextNormalizationService _textNormalizer;
  final VoiceEntryParserService _parser;
  final VoiceExerciseCatalogRepository _catalogRepository;
  final ExerciseCandidateRetrieverService _retriever;
  final ExerciseRerankerService _reranker;
  final MatchConfidenceDeciderService _decider;
  final UserVoiceAliasRepository _aliasRepository;
  final VoiceResolutionLogRepository _logRepository;

  Future<VoiceResolutionResult> resolve({
    required String rawText,
    required VoiceResolutionContext context,
  }) async {
    final normalizedText = _textNormalizer.normalize(rawText);
    final parsedEntry = _parser.parse(
      originalText: rawText,
      normalizedText: normalizedText,
    );
    final phrase = parsedEntry.exercisePhrase.isEmpty
        ? parsedEntry.normalizedText
        : parsedEntry.exercisePhrase;

    final catalog = await _catalogRepository.getCatalog();
    final catalogWithContext = _catalogRepository.mergeWithContext(
      catalog: catalog,
      context: context,
    );

    final retrievedCandidates = _retriever.retrieve(
      phrase: phrase,
      catalog: catalogWithContext,
      context: context,
    );

    UserVoiceAliasMatch? aliasMatch;
    if ((context.userId ?? '').isNotEmpty && phrase.isNotEmpty) {
      aliasMatch = await _aliasRepository.getAlias(
        userId: context.userId!,
        normalizedSpokenForm: phrase,
      );
    }

    final rerankedCandidates = _reranker.rerank(
      candidates: retrievedCandidates,
      context: context,
      userAliasMatch: aliasMatch,
    );

    final workoutCandidates = rerankedCandidates
        .where((candidate) => candidate.isInActiveWorkout)
        .toList(growable: false);
    final finalCandidates = workoutCandidates.isNotEmpty
        ? workoutCandidates
        : rerankedCandidates;
    final decision = _decider.decide(finalCandidates);

    final logId = await _logRepository.createLog(
      parsedEntry: parsedEntry,
      candidates: finalCandidates,
      confidence: decision.confidence,
      decisionType: decision.type,
    );

    return VoiceResolutionResult(
      logId: logId,
      parsedEntry: parsedEntry,
      candidates: finalCandidates,
      decision: decision,
    );
  }

  Future<void> registerFeedback({
    required VoiceResolutionResult resolution,
    required VoiceResolutionContext context,
    required String selectedExerciseId,
  }) async {
    final phrase = resolution.parsedEntry.exercisePhrase.trim();
    final userId = context.userId?.trim();

    if (userId != null && userId.isNotEmpty && phrase.isNotEmpty) {
      await _aliasRepository.registerSelection(
        userId: userId,
        normalizedSpokenForm: phrase,
        exerciseId: selectedExerciseId,
      );
    }

    await _logRepository.markSelection(
      logId: resolution.logId,
      selectedExerciseId: selectedExerciseId,
    );
  }
}
