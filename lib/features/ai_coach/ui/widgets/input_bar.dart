import 'package:coachly/features/ai_coach/application/ai_coach_notifier.dart';
import 'package:coachly/features/ai_coach/ui/theme/ai_coach_theme.dart';
import 'package:coachly/core/text_filter/offensive_text_filter_service.dart';
import 'package:coachly/core/text_filter/polite_text_input_formatter.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputBar extends ConsumerStatefulWidget {
  const InputBar({
    super.key,
    required this.isListening,
    required this.isGenerating,
  });

  final bool isListening;
  final bool isGenerating;

  @override
  ConsumerState<InputBar> createState() => _InputBarState();
}

class _InputBarState extends ConsumerState<InputBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final _textFilter = const OffensiveTextFilterService();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(aiCoachProvider.notifier);

    // When voice listening ends with a transcript, populate the text field.
    ref.listen<AsyncValue<AiCoachState>>(aiCoachProvider, (prev, next) {
      final prevState = prev?.value;
      final nextState = next.value;
      if (nextState == null) return;
      final justFinished =
          (prevState?.isListening ?? false) && !nextState.isListening;
      if (justFinished && nextState.voiceTranscript.isNotEmpty) {
        _controller.text = _textFilter.sanitize(
          nextState.voiceTranscript,
          policy: TextModerationPolicy.freeText,
        );
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        notifier.clearVoiceTranscript();
        _focusNode.requestFocus();
      }
    });

    return Container(
      color: AiCoachTheme.bgPrimary,
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AiCoachTheme.closeButtonBg)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await HapticFeedback.lightImpact();
                  if (widget.isListening) {
                    await notifier.stopVoiceInput();
                  } else {
                    await notifier.startVoiceInput();
                  }
                },
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.isListening)
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 900),
                          tween: Tween<double>(begin: 0.9, end: 1.15),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Container(
                              width: 42 * value,
                              height: 42 * value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AiCoachTheme.accentPurple.withValues(
                                  alpha: 0.22,
                                ),
                              ),
                            );
                          },
                          onEnd: () {
                            if (mounted && widget.isListening) {
                              setState(() {});
                            }
                          },
                        ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isListening
                              ? AiCoachTheme.accentPurple
                              : AiCoachTheme.userBubble,
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AiCoachTheme.inputFieldBg,
                    border: Border.all(color: AiCoachTheme.inputFieldBorder),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !widget.isGenerating,
                    inputFormatters: [PoliteTextInputFormatter()],
                    style: const TextStyle(
                      fontSize: 13,
                      color: AiCoachTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: context.tr('ai.write_or_speak'),
                      hintStyle: const TextStyle(
                        color: AiCoachTheme.textHint,
                        fontSize: 13,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendSanitizedMessage(notifier),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.isGenerating
                    ? null
                    : () {
                        _sendSanitizedMessage(notifier);
                      },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AiCoachTheme.accentBlue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AiCoachTheme.accentBlue.withValues(alpha: 0.8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendSanitizedMessage(AiCoachNotifier notifier) {
    final text = _textFilter
        .sanitize(_controller.text, policy: TextModerationPolicy.freeText)
        .trim();
    if (text.isEmpty) {
      return;
    }
    _controller.clear();
    notifier.sendMessage(text);
  }
}
