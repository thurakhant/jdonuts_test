import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';

/// Donut-frosting ring: a pink arc with sprinkles sweeps to
/// [points] / [target] while the number counts up in the white centre.
class PointsRing extends StatelessWidget {
  const PointsRing({required this.points, required this.target, super.key});

  final int points;

  /// Points at which the next tier starts (the ring is full there).
  final int target;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sweep = AppMotion.effective(context, AppMotion.pointsRingSweep);
    final count = AppMotion.effective(context, AppMotion.pointsCountUp);
    final fraction = target == 0 ? 0.0 : (points / target).clamp(0.0, 1.0);
    final pink = AppTypography.title.copyWith(color: AppColors.accent);
    return Semantics(
      label: '${formatMmk(points)} ${l10n.totalPoints}',
      child: SizedBox.square(
        dimension: AppSpacing.pointsRingSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fraction),
              duration: sweep,
              curve: AppMotion.sweep,
              builder: (_, value, _) => CustomPaint(
                size: const Size.square(AppSpacing.pointsRingSize),
                painter: PointsRingPainter(fraction: value),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.totalPoints,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: points.toDouble()),
                  duration: count,
                  curve: AppMotion.standard,
                  builder: (_, value, _) => Text(
                    formatMmk(value.round()),
                    style: pink.copyWith(
                      fontSize: AppTypography.display.fontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A pale grey track, a thick pink "frosting" arc from 12 o'clock and tiny
/// white sprinkles scattered along the arc.
class PointsRingPainter extends CustomPainter {
  const PointsRingPainter({required this.fraction});

  final double fraction;

  /// Angle between sprinkles, in radians.
  static const double _sprinkleGap = 0.2;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppSpacing.pointsRingStroke;
    final arcRect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcRect,
      0,
      2 * math.pi,
      false,
      paint..color = AppColors.skeletonBase,
    );
    final sweep = 2 * math.pi * fraction;
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweep,
      false,
      paint..color = AppColors.accent,
    );
    _sprinkles(canvas, arcRect, sweep);
  }

  void _sprinkles(Canvas canvas, Rect arcRect, double sweep) {
    final paint = Paint()
      ..color = AppColors.surface
      ..strokeWidth = AppSpacing.ringSprinkleStroke
      ..strokeCap = StrokeCap.round;
    final radius = arcRect.width / 2;
    const half = AppSpacing.ringSprinkleLength / 2;
    for (var i = 0; i * _sprinkleGap < sweep - _sprinkleGap; i++) {
      final angle = -math.pi / 2 + _sprinkleGap / 2 + i * _sprinkleGap;
      // Deterministic scatter: offset across the band and a tilt per dash.
      final across = ((i * 7) % 5 - 2) * AppSpacing.pointsRingStroke * 0.14;
      final tilt = ((i * 5) % 7 - 3) * 0.45;
      final centre =
          arcRect.center +
          Offset(math.cos(angle), math.sin(angle)) * (radius + across);
      final dir = Offset(math.cos(angle + tilt), math.sin(angle + tilt)) * half;
      canvas.drawLine(centre - dir, centre + dir, paint);
    }
  }

  @override
  bool shouldRepaint(PointsRingPainter old) => old.fraction != fraction;
}
