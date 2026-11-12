import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/reward_tier.dart';

/// Bronze -> Platinum. Nodes pop in one after another while a line fills up
/// to the member's position between their current and next tier.
class TierLadder extends StatefulWidget {
  const TierLadder({
    required this.current,
    required this.progressToNext,
    super.key,
  });

  final RewardTier current;

  /// 0..1 of the way from [current] to the next tier.
  final double progressToNext;

  @override
  State<TierLadder> createState() => _TierLadderState();
}

class _TierLadderState extends State<TierLadder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  bool _started = false;

  static const int _count = 4;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduceMotion(context)) {
      _controller.value = 1;
    } else {
      // Nodes enter one step apart; the line fills after the last one.
      _controller.duration = AppMotion.tierLadderStep * (_count + 3);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Share of the controller timeline taken by [steps] ladder steps.
  double _at(int steps) => steps / (_count + 3);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final position = widget.current.index + widget.progressToNext;
    final lineTarget = (position / (_count - 1)).clamp(0.0, 1.0);
    final lineCurve = Interval(_at(2), 1, curve: AppMotion.standard);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Stack(
        children: [
          Positioned.fill(
            top: AppSpacing.tierNodeSize / 2 - AppSpacing.tierLineStroke / 2,
            bottom: null,
            child: CustomPaint(
              size: const Size(double.infinity, AppSpacing.tierLineStroke),
              painter: TierLinePainter(
                fill: lineTarget * lineCurve.transform(_controller.value),
                nodes: _count,
              ),
            ),
          ),
          Row(
            children: [
              for (final tier in RewardTier.values)
                Expanded(
                  child: _node(
                    tier,
                    tier.label(l10n),
                    Interval(
                      _at(tier.index),
                      _at(tier.index + 2),
                      curve: AppMotion.pop,
                    ).transform(_controller.value),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _node(RewardTier tier, String label, double scale) {
    final reached = tier.index <= widget.current.index;
    final isCurrent = tier == widget.current;
    return Column(
      children: [
        Transform.scale(
          scale: scale,
          child: Container(
            width: AppSpacing.tierNodeSize,
            height: AppSpacing.tierNodeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reached ? tier.color : AppColors.surfaceMuted,
              border: isCurrent
                  ? Border.all(
                      color: AppColors.accent,
                      width: AppSpacing.highlightBorder,
                    )
                  : null,
            ),
            child: reached
                ? const Icon(
                    Icons.check,
                    size: AppSpacing.iconSm,
                    color: AppColors.textPrimary,
                  )
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Track plus a pink fill, running between the first and last node centres.
class TierLinePainter extends CustomPainter {
  const TierLinePainter({required this.fill, required this.nodes});

  final double fill;
  final int nodes;

  @override
  void paint(Canvas canvas, Size size) {
    final slot = size.width / nodes;
    final start = Offset(slot / 2, size.height / 2);
    final end = Offset(size.width - slot / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.tierLineStroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint..color = AppColors.skeletonBase);
    canvas.drawLine(
      start,
      Offset.lerp(start, end, fill.clamp(0.0, 1.0))!,
      paint..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(TierLinePainter old) =>
      old.fill != fill || old.nodes != nodes;
}
