import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_spacing.dart';

const int _wiggles = 3;

/// Shakes [child] sideways each time [trigger] changes (wrong OTP).
/// Skipped when the OS asks to reduce motion.
class Shake extends StatefulWidget {
  const Shake({required this.trigger, required this.child, super.key});

  final int trigger;
  final Widget child;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.otpShake,
  );

  @override
  void didUpdateWidget(Shake old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger && !AppMotion.reduceMotion(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = AppMotion.exit.transform(_controller.value);
        final dx = math.sin(t * _wiggles * 2 * math.pi) * AppSpacing.md;
        return Transform.translate(
          offset: Offset(dx * (1 - t), 0),
          child: child,
        );
      },
    );
  }
}
