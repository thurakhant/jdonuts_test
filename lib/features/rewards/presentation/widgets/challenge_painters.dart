import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/challenge.dart';

/// Picks the painter for a challenge's [ChallengeStyle].
CustomPainter painterFor(ChallengeStyle style, double progress) =>
    switch (style) {
      ChallengeStyle.quarterDonut => QuarterDonutPainter(progress: progress),
      ChallengeStyle.coffeeCup => CoffeeCupPainter(progress: progress),
    };

Paint _stroke(Color color) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = AppSpacing.challengeStroke
  ..strokeCap = StrokeCap.round
  ..color = color;

/// A quarter of a donut ring (top-left quadrant) that fills clockwise.
class QuarterDonutPainter extends CustomPainter {
  const QuarterDonutPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // A circle twice the box, centred on the box's bottom-right corner, so
    // its top-left quadrant is what shows.
    final rect = Rect.fromCircle(
      center: size.bottomRight(Offset.zero),
      radius: size.width - AppSpacing.challengeStroke,
    );
    const quarter = math.pi / 2;
    canvas.drawArc(
      rect,
      math.pi,
      quarter,
      false,
      _stroke(AppColors.backgroundPink),
    );
    canvas.drawArc(
      rect,
      math.pi,
      quarter * progress,
      false,
      _stroke(AppColors.accent),
    );
  }

  @override
  bool shouldRepaint(QuarterDonutPainter old) => old.progress != progress;
}

/// A coffee cup: the bowl is an arc whose stroke fills left to right, with a
/// handle and a saucer line.
class CoffeeCupPainter extends CustomPainter {
  const CoffeeCupPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = AppSpacing.challengeStroke;
    final bowl = Rect.fromLTWH(
      inset,
      -size.height * 0.25,
      size.width * 0.7,
      size.height * 1.05,
    );
    canvas.drawArc(bowl, 0, math.pi, false, _stroke(AppColors.backgroundPink));
    canvas.drawArc(
      bowl,
      math.pi,
      -math.pi * progress,
      false,
      _stroke(AppColors.accent),
    );
    // Handle on the right of the bowl.
    final handle = Rect.fromCenter(
      center: Offset(bowl.right, size.height * 0.32),
      width: size.width * 0.3,
      height: size.height * 0.3,
    );
    canvas.drawArc(
      handle,
      -math.pi / 2,
      math.pi,
      false,
      _stroke(AppColors.backgroundPink),
    );
    // Saucer.
    final y = size.height - inset / 2;
    canvas.drawLine(
      Offset(inset, y),
      Offset(bowl.right, y),
      _stroke(AppColors.tierSilver),
    );
  }

  @override
  bool shouldRepaint(CoffeeCupPainter old) => old.progress != progress;
}
