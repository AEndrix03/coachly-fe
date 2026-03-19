import 'package:coachly/features/ai_coach/application/ai_coach_notifier.dart';
import 'package:coachly/features/ai_coach/data/services/context_assembler_service.dart';
import 'package:coachly/features/ai_coach/domain/models/coach_message.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:coachly/features/ai_coach/ui/widgets/coach_header.dart';
import 'package:coachly/features/ai_coach/ui/widgets/context_pill.dart';
import 'package:coachly/features/ai_coach/ui/widgets/input_bar.dart';
import 'package:coachly/features/ai_coach/ui/widgets/insight_card_widget.dart';
import 'package:coachly/features/ai_coach/ui/widgets/message_bubble.dart';
import 'package:coachly/features/ai_coach/ui/widgets/quick_actions_row.dart';
import 'package:coachly/features/ai_coach/ui/widgets/suggestions_row.dart';
import 'package:coachly/features/ai_coach/ui/widgets/voice_overlay.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiCoachPanel extends ConsumerStatefulWidget {
  const AiCoachPanel({super.key});

  @override
  ConsumerState<AiCoachPanel> createState() => _AiCoachPanelState();
}

class _AiCoachPanelState extends ConsumerState<AiCoachPanel> {
  late final ScrollController _messagesController;
  ProviderSubscription<AsyncValue<AiCoachState>>? _subscription;

  @override
  void initState() {
    super.initState();
    _messagesController = ScrollController();

    _subscription = ref.listenManual<AsyncValue<AiCoachState>>(
      aiCoachProvider,
      (previous, next) {
        final previousState = previous?.value;
        final nextState = next.value;

        final prevLength = previousState?.messages.length ?? 0;
        final nextLength = nextState?.messages.length ?? 0;

        final prevLastText = previousState?.messages.isNotEmpty == true
            ? previousState!.messages.last.text
            : '';
        final nextLastText = nextState?.messages.isNotEmpty == true
            ? nextState!.messages.last.text
            : '';

        if (nextLength != prevLength || nextLastText != prevLastText) {
          _scrollToBottom();
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    _messagesController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_messagesController.hasClients) {
        return;
      }

      _messagesController.animateTo(
        _messagesController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(aiCoachProvider);
    final workoutContext = ref.watch(currentWorkoutContextProvider);
    final coachState = asyncState.value ?? const AiCoachState();

    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        expand: false,
        builder: (context, sheetScrollController) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AiCoachTheme.bgPrimary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 4),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AiCoachTheme.dragHandle,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    CoachHeader(
                      onClose: () => Navigator.of(context).pop(),
                      isModelLoading: coachState.isModelLoading,
                    ),
                    ContextPill(context: workoutContext),
                    QuickActionsRow(enabled: !coachState.isGenerating),
                    const SizedBox(height: 6),
                    Expanded(
                      child: asyncState.isLoading && asyncState.value == null
                          ? _LoadingMessages(
                              scrollController: sheetScrollController,
                            )
                          : ListView.builder(
                              controller: _messagesController,
                              padding: const EdgeInsets.only(top: 4, bottom: 8),
                              itemCount: coachState.messages.length,
                              itemBuilder: (context, index) {
                                final message = coachState.messages[index];
                                final isLast =
                                    index == coachState.messages.length - 1;
                                final showTyping =
                                    coachState.isGenerating &&
                                    isLast &&
                                    message.sender == MessageSender.ai;

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    MessageBubble(
                                      message: message,
                                      showTyping: showTyping,
                                    ),
                                    if (message.insightCard != null)
                                      InsightCardWidget(
                                        card: message.insightCard!,
                                      ),
                                  ],
                                );
                              },
                            ),
                    ),
                    SuggestionsRow(suggestions: coachState.suggestions),
                    InputBar(
                      isListening: coachState.isListening,
                      isGenerating: coachState.isGenerating,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: VoiceOverlay(
                  visible: coachState.isListening,
                  voiceTranscript: coachState.voiceTranscript,
                  onCancel: () {
                    ref.read(aiCoachProvider.notifier).stopVoiceInput();
                  },
                  onSend: () {
                    ref
                        .read(aiCoachProvider.notifier)
                        .sendVoiceTranscript();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoadingMessages extends StatelessWidget {
  const _LoadingMessages({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 28),
        const Center(
          child: CircularProgressIndicator(color: AiCoachTheme.accentBlue),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            context.tr('ai.loading'),
            style: const TextStyle(
              color: AiCoachTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 90, 6),
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                color: AiCoachTheme.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AiCoachTheme.borderSubtle),
              ),
            ),
          );
        }),
      ],
    );
  }
}
