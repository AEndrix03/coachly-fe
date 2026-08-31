import 'dart:async';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/presentation/active_workout_strings.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/spring_reveal.dart';

/// La nota rapida, con i tag preimpostati.
///
/// I tag esistono perche' scrivere a mano fra due serie non succede:
/// un tocco su «forma calante» invece di una frase.
class QuickNoteSheet extends StatefulWidget {
  final String exerciseName;
  final ActiveSetState set;
  final void Function(String text, Set<SetNoteTag> tags) onSave;

  const QuickNoteSheet({
    super.key,
    required this.exerciseName,
    required this.set,
    required this.onSave,
  });

  @override
  State<QuickNoteSheet> createState() => QuickNoteSheetState();
}

class QuickNoteSheetState extends State<QuickNoteSheet> {
  static const _primaryTags = [
    SetNoteTag.goodSet,
    SetNoteTag.feltStrong,
    SetNoteTag.formOff,
  ];
  static const _moreTags = [
    SetNoteTag.greatPump,
    SetNoteTag.lostPosition,
    SetNoteTag.romIssue,
    SetNoteTag.lowEnergy,
    SetNoteTag.gripIssue,
    SetNoteTag.equipment,
  ];

  late final TextEditingController _textController;
  late Set<SetNoteTag> _tags;
  Timer? _debounce;
  Timer? _savedTimer;
  bool _dirty = false;
  bool _saving = false;
  bool _savedVisible = false;
  bool _moreOpen = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.set.note ?? '');
    _tags = {...?widget.set.noteTags};
  }

  void _onTextChanged(String _) {
    _dirty = true;
    _debounce?.cancel();
    setState(() {
      _saving = true;
      _savedVisible = false;
    });
    _debounce = Timer(const Duration(milliseconds: 500), _commit);
  }

  void _toggleTag(SetNoteTag tag) {
    HapticFeedback.selectionClick();
    setState(() {
      _tags.contains(tag) ? _tags.remove(tag) : _tags.add(tag);
      _dirty = true;
      _saving = true;
      _savedVisible = false;
    });
    _debounce?.cancel();
    _commit();
  }

  void _commit({bool updateVisualState = true}) {
    if (!_dirty) return;
    _dirty = false;
    widget.onSave(_textController.text.trim(), {..._tags});
    if (!updateVisualState || !mounted) return;
    _savedTimer?.cancel();
    setState(() {
      _saving = false;
      _savedVisible = true;
    });
    _savedTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _savedVisible = false);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _savedTimer?.cancel();
    _commit(updateVisualState: false);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboard),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: .32),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.activeTr('quickNote'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Set ${widget.set.position + 1} · ${widget.exerciseName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              minLines: 4,
              maxLines: 6,
              onChanged: _onTextChanged,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: context.l10n.workoutActiveNoteHint,
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: scheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(context.l10n.workoutActiveQuickAdd, style: labelStyle),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in _primaryTags)
                  QuickNoteTag(
                    tag: tag,
                    selected: _tags.contains(tag),
                    onTap: () => _toggleTag(tag),
                  ),
                QuickNoteMoreButton(
                  open: _moreOpen,
                  onTap: () => setState(() => _moreOpen = !_moreOpen),
                ),
              ],
            ),
            SpringReveal(
              visible: _moreOpen,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in _moreTags)
                      QuickNoteTag(
                        tag: tag,
                        selected: _tags.contains(tag),
                        onTap: () => _toggleTag(tag),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 20,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _saving
                    ? Text(
                        context.l10n.workoutActiveSaving,
                        key: const ValueKey('saving'),
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      )
                    : _savedVisible
                    ? Row(
                        key: const ValueKey('saved'),
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            context.l10n.workoutActiveSaved,
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: scheme.primary,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey('idle')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickNoteTag extends StatelessWidget {
  final SetNoteTag tag;
  final bool selected;
  final VoidCallback onTap;

  const QuickNoteTag({
    super.key,
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, icon) = noteTagPresentation(tag);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedScale(
          scale: selected ? 1.02 : 1,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: .14)
                  : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (selected) ...[
                  const SizedBox(width: 5),
                  Icon(Icons.check_rounded, size: 15, color: scheme.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickNoteMoreButton extends StatelessWidget {
  final bool open;
  final VoidCallback onTap;

  const QuickNoteMoreButton({
    super.key,
    required this.open,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ActionChip(
    onPressed: onTap,
    avatar: const Icon(Icons.more_horiz_rounded, size: 17),
    label: Text(open ? 'Less' : 'More'),
  );
}
