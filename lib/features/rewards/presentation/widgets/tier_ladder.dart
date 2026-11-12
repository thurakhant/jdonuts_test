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
    required this.pointsRemaining,
    super.key,
  });

  final RewardTier current;
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => SizedBox(
        height: AppSpacing.tierRowHeight * _count,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: TierLinePainter(rows: _count)),
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
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, (1 - t) * AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TierBadge(tier: tier, letter: tier.label(l10n)[0]),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tier.label(l10n), style: AppTypography.title),
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

/// Shield badge with the tier's letter and one star per rank, standing in
/// for the design's rendered badge artwork.
class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier, required this.letter});

  final RewardTier tier;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.tierBadgeSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.shield, color: tier.color, size: AppSpacing.tierBadgeSize),
          Transform.translate(
            offset: const Offset(0, -3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i <= tier.index; i++)
                      const Icon(
                        Icons.star,
                        size: 6,
                        color: AppColors.textOnPrimary,
                      ),
                  ],
                ),
                Text(
                  letter,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey vertical track connecting the badge centres.
class TierLinePainter extends CustomPainter {
  const TierLinePainter({required this.rows});

  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    const half = AppSpacing.tierBadgeSize / 2;
    final top = const Offset(half, AppSpacing.tierBadgeSize);
    final bottom = Offset(
      half,
      AppSpacing.tierRowHeight * (rows - 1) + AppSpacing.sm,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.tierLineStroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.skeletonBase;
    canvas.drawLine(top, bottom, paint);
  }

  @override
  bool shouldRepaint(TierLinePainter old) => old.rows != rows;
}
