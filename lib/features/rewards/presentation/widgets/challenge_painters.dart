import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

Paint _stroke(Color color) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = AppSpacing.challengeStroke
  ..strokeCap = StrokeCap.round
  ..color = color;

/// Four quarter arcs around a donut picture; the first [progress] fraction
/// of the circle is drawn in pink, the rest in grey.
class QuarterDonutPainter extends CustomPainter {
  const QuarterDonutPainter({required this.progress});

  final double progress;

  /// Small gap left between quarters, in radians.
  static const double _gap = 0.16;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(AppSpacing.challengeStroke / 2);
    const quarter = math.pi / 2;
    for (var i = 0; i < 4; i++) {
      final start = -math.pi / 2 + i * quarter + _gap / 2;
      final filled = (progress * 4 - i).clamp(0.0, 1.0);
      canvas.drawArc(
        rect,
        start,
        quarter - _gap,
        false,
        _stroke(AppColors.skeletonBase),
      );
      if (filled > 0) {
        canvas.drawArc(
          rect,
          start,
          (quarter - _gap) * filled,
          false,
          _stroke(AppColors.accent),
        );
      }
    }
  }

  @override
  bool shouldRepaint(QuarterDonutPainter old) => old.progress != progress;
}

/// An orange arc over the top of a coffee cup that fills left to right.
class CoffeeCupPainter extends CustomPainter {
  const CoffeeCupPainter({required this.progress});

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
  bool shouldRepaint(CoffeeCupPainter old) => old.progress != progress;
}

/// Clips to a pie slice starting at 12 o'clock and running clockwise.
class SectorClipper extends CustomClipper<Path> {
  const SectorClipper(this.sweep);

  final double sweep;

  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width / 2, size.height / 2)
    ..arcTo(Offset.zero & size, -math.pi / 2, sweep, false)
    ..close();

  @override
  bool shouldReclip(SectorClipper old) => old.sweep != sweep;
}

/// Luminance matrix that turns a picture grey.
const List<double> greyscaleMatrix = [
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];
