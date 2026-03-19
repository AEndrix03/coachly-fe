import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coachly/shared/i18n/app_strings.dart';

class SetRow extends StatelessWidget {
  final String type;
  final double weight;
  final int reps;
  final bool completed;
  final ValueChanged<bool> onCompleteToggle;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const SetRow({
    super.key,
    required this.type,
    required this.weight,
    required this.reps,
    required this.completed,
    required this.onCompleteToggle,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onTypeChanged,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: completed
            ? Color.alphaBlend(
                scheme.primary.withValues(alpha: 0.2),
                scheme.surfaceContainerHigh,
              )
            : scheme.surfaceContainerHigh.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed
              ? scheme.primary.withValues(alpha: 0.55)
              : scheme.outlineVariant.withValues(alpha: 0.75),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          _buildTypeDropdown(scheme),
          const SizedBox(width: 8),
          Flexible(flex: 3, child: _buildWeightInput(scheme)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.close_rounded,
              color: scheme.onSurface.withValues(alpha: completed ? 0.75 : 0.4),
              size: 14,
            ),
          ),
          Flexible(flex: 2, child: _buildRepsInput(scheme)),
          const SizedBox(width: 4),
          _buildMenu(context, scheme),
          const SizedBox(width: 6),
          _buildModernCheckbox(scheme),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(ColorScheme scheme) {
    final typeMap = {
      'Normale': 'N',
      'Riscaldamento': 'R',
      'Cedimento': 'C',
      'Dropset': 'D',
      'Buffer': 'B',
      'Volume': 'V',
      'Avvicinamento': 'A',
    };
    final selectedType = _normalizeTypeForDropdown(type, typeMap);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: _fieldDecoration(scheme),
      child: DropdownButton<String>(
        value: selectedType,
        underline: const SizedBox.shrink(),
        dropdownColor: scheme.surfaceContainerHigh,
        isDense: true,
        icon: const SizedBox.shrink(),
        menuMaxHeight: 320,
        borderRadius: BorderRadius.circular(12),
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.82),
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        items: typeMap.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: SizedBox(
              width: 160,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return typeMap.entries.map((entry) {
            return Center(
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface.withValues(alpha: 0.82),
                ),
              ),
            );
          }).toList();
        },
        onChanged: (value) {
          if (value != null) {
            onTypeChanged(value);
          }
        },
      ),
    );
  }

  String _normalizeTypeForDropdown(
    String rawType,
    Map<String, String> typeMap,
  ) {
    final trimmed = rawType.trim();
    if (typeMap.containsKey(trimmed)) {
      return trimmed;
    }

    switch (trimmed.toLowerCase()) {
      case 'normal':
        return 'Normale';
      case 'warmup':
      case 'warm-up':
        return 'Riscaldamento';
      case 'failure':
        return 'Cedimento';
      case 'drop set':
        return 'Dropset';
      case 'approach':
        return 'Avvicinamento';
      default:
        return 'Normale';
    }
  }

  Widget _buildWeightInput(ColorScheme scheme) {
    return Container(
      constraints: const BoxConstraints(minWidth: 76, maxWidth: 102),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: _fieldDecoration(scheme),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: weight.toStringAsFixed(
                weight.truncateToDouble() == weight ? 0 : 1,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.84),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
              ],
              onChanged: (value) {
                final parsed = double.tryParse(value);
                if (parsed != null) {
                  onWeightChanged(parsed);
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'kg',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepsInput(ColorScheme scheme) {
    return Container(
      constraints: const BoxConstraints(minWidth: 56, maxWidth: 72),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: _fieldDecoration(scheme),
      child: TextFormField(
        initialValue: reps.toString(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.84),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        onChanged: (value) {
          final parsed = int.tryParse(value);
          if (parsed != null) {
            onRepsChanged(parsed);
          }
        },
      ),
    );
  }

  Widget _buildMenu(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          Icons.more_horiz_rounded,
          color: scheme.onSurface.withValues(alpha: 0.6),
          size: 20,
        ),
        onPressed: () {
          final button = context.findRenderObject() as RenderBox;
          final overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          final position = button.localToGlobal(Offset.zero, ancestor: overlay);

          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              position.dx,
              position.dy + button.size.height,
              overlay.size.width - position.dx - button.size.width,
              0,
            ),
            color: scheme.surfaceContainerHigh,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: scheme.outlineVariant, width: 1),
            ),
            items: <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'notes',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sticky_note_2_outlined,
                      color: scheme.onSurface.withValues(alpha: 0.75),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.tr('session.notes'),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'duplicate',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.copy_all_rounded,
                      color: scheme.onSurface.withValues(alpha: 0.75),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.tr('common.duplicate'),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: scheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.tr('common.delete'),
                      style: TextStyle(
                        color: scheme.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).then((value) {
            switch (value) {
              case 'notes':
                break;
              case 'duplicate':
                onDuplicate();
                break;
              case 'delete':
                onDelete();
                break;
            }
          });
        },
      ),
    );
  }

  Widget _buildModernCheckbox(ColorScheme scheme) {
    return GestureDetector(
      onTap: () => onCompleteToggle(!completed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: completed
              ? scheme.primary
              : scheme.surfaceContainerHighest.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: completed
                ? scheme.primary.withValues(alpha: 0.9)
                : scheme.outlineVariant.withValues(alpha: 0.9),
            width: 1.5,
          ),
          boxShadow: completed
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
        ),
        child: completed
            ? Icon(Icons.check_rounded, color: scheme.onPrimary, size: 20)
            : null,
      ),
    );
  }

  BoxDecoration _fieldDecoration(ColorScheme scheme) {
    return BoxDecoration(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.72)),
    );
  }
}
