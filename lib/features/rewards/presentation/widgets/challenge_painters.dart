import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

Paint _stroke(Color color) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = AppSpacing.challengeStroke
  ..strokeCap = StrokeCap.round
  ..color = color;

/// An orange arc over the top of a coffee cup that fills left to right.
class CoffeeProgressArcPainter extends CustomPainter {
  const CoffeeProgressArcPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(AppSpacing.challengeStroke / 2);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      _stroke(AppColors.skeletonBase),
    );
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * progress,
      false,
      _stroke(AppColors.highlight),
    );
  }

  @override
  bool shouldRepaint(CoffeeProgressArcPainter old) => old.progress != progress;
}

/// Clips to a pie slice starting at 12 o'clock and running clockwise.
class SectorClipper extends CustomClipper<Path> {
  const SectorClipper(this.sweepRadians);

  /// Clockwise angle of the slice, in radians.
  final double sweepRadians;

  @override
  Path getClip(Size size) {
    // arcTo collapses a full 360° sweep to nothing, so a finished circle
    // is an oval rather than a pie slice.
    if (sweepRadians >= 2 * math.pi) return Path()..addOval(Offset.zero & size);
    return Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..arcTo(Offset.zero & size, -math.pi / 2, sweepRadians, false)
      ..close();
  }

  @override
  bool shouldReclip(SectorClipper old) => old.sweepRadians != sweepRadians;
}

/// Luminance matrix that turns a picture grey.
const List<double> greyscaleMatrix = [
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];
