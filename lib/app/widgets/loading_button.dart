import 'package:material_ui/material_ui.dart';

import '../motion/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Pill call-to-action. While [onPressed] is running it shows a spinner and
/// ignores further taps, so a double tap sends exactly one request.
class LoadingButton extends StatefulWidget {
  const LoadingButton({
    required this.label,
    required this.onPressed,
    this.color = AppColors.navBarBlue,
    super.key,
  });

  final String label;

  /// Null disables the button.
  final Future<void> Function()? onPressed;
  final Color color;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _busy = false;
  bool _pressed = false;

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onPressed?.call();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _setPressed(bool value) {
    if (widget.onPressed != null && _pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed && !AppMotion.reduceMotion(context) ? 0.97 : 1,
        duration: AppMotion.buttonPress,
        curve: AppMotion.standard,
        child: ElevatedButton(
          onPressed: enabled && !_busy ? _handleTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            disabledBackgroundColor: _busy
                ? widget.color
                : widget.color.withValues(alpha: 0.4),
            // Flat capsule, as in the design screens.
            elevation: 0,
            shadowColor: Colors.transparent,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          child: _busy
              ? const SizedBox.square(
                  dimension: AppSpacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.textOnPrimary,
                  ),
                )
              : Text(widget.label),
        ),
      ),
    );
  }
}
