import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';

/// Markers passed to ARB placeholders; [LinkedText] swaps them for links.
const List<String> kLinkMarkers = ['\u0001', '\u0002'];

/// One tappable word inside a sentence.
class LinkSpec {
  const LinkSpec(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
}

/// Renders an ARB sentence whose placeholders were filled with
/// [kLinkMarkers], turning each marker into a pink tappable link.
class LinkedText extends StatefulWidget {
  const LinkedText({
    required this.template,
    required this.links,
    this.style,
    this.textAlign = TextAlign.center,
    this.linkWeight = FontWeight.w700,
    super.key,
  });

  final String template;
  final List<LinkSpec> links;
  final TextStyle? style;
  final TextAlign textAlign;

  /// Legal footnotes use a lighter weight than inline actions like "Log In".
  final FontWeight linkWeight;

  @override
  State<LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<LinkedText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  List<InlineSpan> _spans() {
    _disposeRecognizers();
    final pattern = RegExp('[${kLinkMarkers.join()}]');
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final m in pattern.allMatches(widget.template)) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: widget.template.substring(cursor, m.start)));
      }
      final link = widget.links[kLinkMarkers.indexOf(m.group(0)!)];
      final tap = TapGestureRecognizer()..onTap = link.onTap;
      _recognizers.add(tap);
      spans.add(
        TextSpan(
          text: link.label,
          recognizer: tap,
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: widget.linkWeight,
          ),
        ),
      );
      cursor = m.end;
    }
    spans.add(TextSpan(text: widget.template.substring(cursor)));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: _spans()),
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
