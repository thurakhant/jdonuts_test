import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/validators/otp_validator.dart';

/// Six single-digit boxes: auto-advance, backspace goes back, a pasted code
/// fills all boxes, and the OS can autofill the SMS code.
class OtpBoxes extends StatefulWidget {
  const OtpBoxes({
    required this.onCompleted,
    this.enabled = true,
    this.hasError = false,
    super.key,
  });

  final ValueChanged<String> onCompleted;
  final bool enabled;
  final bool hasError;

  @override
  State<OtpBoxes> createState() => OtpBoxesState();
}

class OtpBoxesState extends State<OtpBoxes> {
  final _controllers = List.generate(
    kOtpLength,
    (_) => TextEditingController(),
  );
  final _focusNodes = List.generate(kOtpLength, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < kOtpLength; i++) {
      _focusNodes[i].addListener(() => _selectAllOnFocus(i));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _selectAllOnFocus(int i) {
    if (!_focusNodes[i].hasFocus) return;
    final c = _controllers[i];
    c.selection = TextSelection(baseOffset: 0, extentOffset: c.text.length);
  }

  /// Empties every box and puts the cursor back on the first one.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.isEmpty) return;
    final digits = value.split('');
    var last = index;
    for (var i = 0; i < digits.length && index + i < kOtpLength; i++) {
      _controllers[index + i].text = digits[i];
      last = index + i;
    }
    if (last < kOtpLength - 1) {
      _focusNodes[last + 1].requestFocus();
    } else if (_code.length == kOtpLength) {
      widget.onCompleted(_code);
    }
  }

  KeyEventResult _onKey(int index, KeyEvent event) {
    final isBack =
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace;
    if (isBack && _controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < kOtpLength; i++)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: _box(i),
              ),
            ),
        ],
      ),
    );
  }

  Widget _box(int i) {
    return Focus(
      onKeyEvent: (_, event) => _onKey(i, event),
      child: TextField(
        key: ValueKey('otp-box-$i'),
        controller: _controllers[i],
        focusNode: _focusNodes[i],
        enabled: widget.enabled,
        autofocus: i == 0,
        textAlign: TextAlign.center,
        style: AppTypography.headline,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) => _onChanged(i, v),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          enabledBorder: widget.hasError
              ? Theme.of(context).inputDecorationTheme.errorBorder
              : null,
          fillColor: widget.enabled
              ? AppColors.surface
              : AppColors.surfaceMuted,
        ),
      ),
    );
  }
}
