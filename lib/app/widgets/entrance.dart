import 'package:material_ui/material_ui.dart';

import '../motion/app_motion.dart';

/// Fades and slides [child] in, [index] steps after its siblings.
///
/// One controller covers the delay and the motion (an [Interval]), so no
/// timers are left behind. Under Reduce Motion it shows immediately.
class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({
    required this.child,
    this.index = 0,
    this.step = AppMotion.staggerStep,
    this.duration = AppMotion.entrance,
    this.slide = AppMotion.entranceSlide,
    this.curve = AppMotion.standard,
    super.key,
  });

  final Widget child;
  final int index;
  final Duration step;
  final Duration duration;
  final Offset slide;
  final Curve curve;

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  late final Duration _delay = widget.step * widget.index;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduceMotion(context)) {
      _controller.value = 1;
    } else {
      _controller.duration = _delay + widget.duration;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = (_delay + widget.duration).inMicroseconds;
    final begin = total == 0 ? 0.0 : _delay.inMicroseconds / total;
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, 1, curve: widget.curve),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: widget.slide, end: Offset.zero).animate(curved),
        child: widget.child,
      ),
    );
  }
}

/// Scales [child] in with an overshoot ([AppMotion.pop]) after [delay].
class PopIn extends StatefulWidget {
  const PopIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.badgePop,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduceMotion(context)) {
      _controller.value = 1;
    } else {
      _controller.duration = widget.delay + widget.duration;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = (widget.delay + widget.duration).inMicroseconds;
    final begin = widget.delay.inMicroseconds / total;
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, 1, curve: AppMotion.pop),
      ),
      child: widget.child,
    );
  }
}
