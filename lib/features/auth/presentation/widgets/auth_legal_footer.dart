import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Legal note under the sign-in actions.
///
/// Quiet enough to disappear at a glance, legible and clearly tappable when
/// someone looks for it: fine print, dimmed content colour, and the two
/// documents as separate targets with a hairline underline.
///
/// It always takes a single line: the sentence is laid out at its natural
/// width and scaled down to whatever the screen gives it, so a narrow phone
/// or a large text scale shrinks the note instead of wrapping it.
///
/// The sentence is one translatable message with the two document names as
/// placeholders, so a translation is free to reorder them. To find where the
/// names landed without parsing the grammar, the message is first formatted
/// with two private markers and then split on them.
class AuthLegalFooter extends StatefulWidget {
  const AuthLegalFooter({
    required this.onTermsTap,
    required this.onPrivacyTap,
    super.key,
  });

  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  State<AuthLegalFooter> createState() => _AuthLegalFooterState();
}

class _AuthLegalFooterState extends State<AuthLegalFooter> {
  static const String _termsMark = '';
  static const String _privacyMark = '';

  late final TapGestureRecognizer _terms;
  late final TapGestureRecognizer _privacy;

  @override
  void initState() {
    super.initState();
    _terms = TapGestureRecognizer()..onTap = () => widget.onTermsTap();
    _privacy = TapGestureRecognizer()..onTap = () => widget.onPrivacyTap();
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    final base = context.text.fineprint.copyWith(
      color: colors.textPrimary.withValues(alpha: 0.65),
    );
    final link = base.copyWith(
      color: colors.textPrimary.withValues(alpha: 0.88),
      decoration: TextDecoration.underline,
      decorationColor: colors.textPrimary.withValues(alpha: 0.35),
      decorationThickness: 1,
    );

    final skeleton = l10n.authLegalNotice(_termsMark, _privacyMark);
    final termsFirst = skeleton.indexOf(_termsMark) < skeleton.indexOf(
      _privacyMark,
    );
    final firstMark = termsFirst ? _termsMark : _privacyMark;
    final secondMark = termsFirst ? _privacyMark : _termsMark;

    final beforeFirst = skeleton.substring(0, skeleton.indexOf(firstMark));
    final between = skeleton.substring(
      skeleton.indexOf(firstMark) + 1,
      skeleton.indexOf(secondMark),
    );
    final afterSecond = skeleton.substring(skeleton.indexOf(secondMark) + 1);

    final termsSpan = TextSpan(
      text: l10n.authLegalTerms,
      style: link,
      recognizer: _terms,
    );
    final privacySpan = TextSpan(
      text: l10n.authLegalPrivacy,
      style: link,
      recognizer: _privacy,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text.rich(
        TextSpan(
          style: base,
          children: [
            TextSpan(text: beforeFirst),
            termsFirst ? termsSpan : privacySpan,
            TextSpan(text: between),
            termsFirst ? privacySpan : termsSpan,
            TextSpan(text: afterSecond),
          ],
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}
