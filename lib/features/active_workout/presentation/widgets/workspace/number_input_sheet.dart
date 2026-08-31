import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/workspace_formatting.dart';

/// Il foglio numerico per il salto grosso di peso o ripetizioni.
///
/// Campo gia' a fuoco e tastiera numerica: gli scatti +/- coprono il
/// caso normale, questo copre il cambio vero.
class NumberInputSheet extends StatefulWidget {
  final double initial;
  final String label;
  final String? unit;
  final double step;
  final ValueChanged<double> onChanged;

  const NumberInputSheet({
    super.key,
    required this.initial,
    required this.label,
    required this.unit,
    required this.step,
    required this.onChanged,
  });

  @override
  State<NumberInputSheet> createState() => NumberInputSheetState();
}

class NumberInputSheetState extends State<NumberInputSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: number(widget.initial));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double? _parsedValue() =>
      double.tryParse(_controller.text.replaceAll(',', '.'));

  void _saveText(String _) {
    final value = _parsedValue();
    if (value != null) widget.onChanged(value);
  }

  void _adjust(double delta) {
    final value = ((_parsedValue() ?? widget.initial) + delta)
        .clamp(0, double.infinity)
        .toDouble();
    final text = number(value);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    widget.onChanged(value);
    _focusNode.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedPadding(
      duration: context.motion.resolve(context, context.motion.quick),
      curve: context.motion.enter,
      padding: EdgeInsets.fromLTRB(
        context.spacing.lg,
        0,
        context.spacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + context.spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: context.text.labelStrong.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.xs),
          Row(
            children: [
              NumberStepButton(
                icon: Icons.remove_rounded,
                tooltip: context.l10n.workoutBuilderDecrease(''),
                onPressed: () => _adjust(-widget.step),
              ),
              SizedBox(width: context.spacing.xs),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: context.text.displayM.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixText: widget.unit,
                    suffixStyle: context.text.titleM,
                  ),
                  onChanged: _saveText,
                ),
              ),
              SizedBox(width: context.spacing.xs),
              NumberStepButton(
                icon: Icons.add_rounded,
                tooltip: context.l10n.workoutBuilderIncrease(''),
                onPressed: () => _adjust(widget.step),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberStepButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const NumberStepButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: context.sizes.touchTargetWorkout,
    child: IconButton.filledTonal(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
    ),
  );
}
