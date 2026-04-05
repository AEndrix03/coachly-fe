import 'package:coachly/core/text_filter/offensive_text_filter_service.dart';
import 'package:flutter/services.dart';

class PoliteTextInputFormatter extends TextInputFormatter {
  PoliteTextInputFormatter({
    OffensiveTextFilterService? service,
    this.policy = TextModerationPolicy.freeText,
  }) : _service = service ?? const OffensiveTextFilterService();

  final OffensiveTextFilterService _service;
  final TextModerationPolicy policy;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final sanitized = _service.sanitize(newValue.text, policy: policy);
    if (sanitized == newValue.text) {
      return newValue;
    }

    final safeOffset = newValue.selection.extentOffset.clamp(
      0,
      sanitized.length,
    );
    return TextEditingValue(
      text: sanitized,
      selection: TextSelection.collapsed(offset: safeOffset),
      composing: TextRange.empty,
    );
  }
}
