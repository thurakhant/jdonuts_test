import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';

/// Ring that sweeps to [points] / [target] while the number counts up.
class PointsRing extends StatelessWidget {
  const PointsRing({
    required this.points,
    required this.target,
    required this.nextTierName,
    super.key,
  });

  final int points;

  /// Points at which the next tier starts (the ring is full there).
  final int target;
  final String nextTierName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sweep = AppMotion.effective(context, AppMotion.pointsRingSweep);
    final count = AppMotion.effective(context, AppMotion.pointsCountUp);
    final fraction = target == 0 ? 0.0 : (points / target).clamp(0.0, 1.0);
    return Semantics(
      label: '${formatMmk(points)} ${l10n.pointsTotalLabel}',
      child: SizedBox(
        width: AppSpacing.pointsRingSize,
        height: AppSpacing.pointsRingSize,
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
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: points.toDouble()),
                  duration: count,
                  curve: AppMotion.standard,
                  builder: (_, value, _) => Text(
                    formatMmk(value.round()),
                    style: AppTypography.display,
                  ),
                ),
                Text(
                  l10n.pointsToTier(formatMmk(target - points), nextTierName),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws the pale track and the pink arc, starting at 12 o'clock.
class PointsRingPainter extends CustomPainter {
  const PointsRingPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppSpacing.pointsRingStroke;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcRect,
      0,
      2 * math.pi,
      false,
      paint..color = AppColors.backgroundPink,
    );
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      paint..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(PointsRingPainter old) => old.fraction != fraction;
}
