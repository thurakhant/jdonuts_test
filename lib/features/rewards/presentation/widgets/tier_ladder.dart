import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/reward_tier.dart';

/// Silver -> Gold -> Platinum, top to bottom. Rows appear one after another
/// while a line fills down to the member's position.
class TierLadder extends StatefulWidget {
  const TierLadder({
    required this.current,
    required this.progressToNext,
    required this.pointsRemaining,
    super.key,
  });

  final RewardTier current;

  /// 0..1 of the way from [current] to the next tier.
  final double progressToNext;
  final int pointsRemaining;

  @override
  State<TierLadder> createState() => _TierLadderState();
}

class _TierLadderState extends State<TierLadder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  bool _started = false;

  static final int _count = RewardTier.values.length;

  /// Rows enter one step apart; the line fills after they are in.
  static final int _steps = _count + 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduceMotion(context)) {
      _controller.value = 1;
    } else {
      _controller.duration = AppMotion.tierLadderStep * _steps;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _at(int steps) => steps / _steps;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final position = widget.current.index + widget.progressToNext;
    final lineTarget = (position / (_count - 1)).clamp(0.0, 1.0);
    final lineCurve = Interval(_at(2), 1, curve: AppMotion.standard);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => SizedBox(
        height: AppSpacing.tierRowHeight * _count,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: TierLinePainter(
                  fill: lineTarget * lineCurve.transform(_controller.value),
                  rows: _count,
                ),
              ),
            ),
            Column(
              children: [
                for (final tier in RewardTier.values)
                  SizedBox(
                    height: AppSpacing.tierRowHeight,
                    child: _row(
                      l10n,
                      tier,
                      Interval(
                        _at(tier.index),
                        _at(tier.index + 2),
                        curve: AppMotion.standard,
                      ).transform(_controller.value),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _sub(AppLocalizations l10n, RewardTier tier) {
    if (tier == widget.current) return l10n.tierHere;
    if (tier.index < widget.current.index) return l10n.tierReached;
    if (tier.index == widget.current.index + 1) {
      return l10n.tierRemaining(
        formatMmk(widget.pointsRemaining),
        tier.label(l10n),
      );
    }
    return l10n.tierSoon;
  }

  Widget _row(AppLocalizations l10n, RewardTier tier, double t) {
    final isCurrent = tier == widget.current;
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, (1 - t) * AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.tierBadgeSize,
              height: AppSpacing.tierBadgeSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent ? AppColors.backgroundPink : null,
              ),
              child: Icon(
                Icons.shield,
                color: tier.color,
                size: AppSpacing.tierBadgeSize - AppSpacing.sm,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tier.label(l10n),
                    style: AppTypography.title.copyWith(
                      color: isCurrent
                          ? AppColors.accent
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(_sub(l10n, tier), style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical track plus a pink fill between the badge centres.
class TierLinePainter extends CustomPainter {
  const TierLinePainter({required this.fill, required this.rows});

  final double fill;
  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    const half = AppSpacing.tierBadgeSize / 2;
    final x = half;
    final top = Offset(x, AppSpacing.tierBadgeSize);
    final bottom = Offset(
      x,
      AppSpacing.tierRowHeight * (rows - 1) + AppSpacing.sm,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.tierLineStroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(top, bottom, paint..color = AppColors.skeletonBase);
    canvas.drawLine(
      top,
      Offset.lerp(top, bottom, fill.clamp(0.0, 1.0))!,
      paint..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(TierLinePainter old) =>
      old.fill != fill || old.rows != rows;
}
