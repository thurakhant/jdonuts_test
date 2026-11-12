import 'package:material_ui/material_ui.dart';

import '../motion/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A placeholder shape with a sweeping shine, shown while data loads.
/// The spec asks for skeletons, not spinners.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    this.width,
    this.height,
    this.radius = AppRadius.md,
    super.key,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.skeletonShimmer,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final slide = _controller.value * 3 - 1;
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              gradient: LinearGradient(
                begin: Alignment(slide - 1, 0),
                end: Alignment(slide + 1, 0),
                colors: const [
                  AppColors.skeletonBase,
                  AppColors.skeletonShine,
                  AppColors.skeletonBase,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
