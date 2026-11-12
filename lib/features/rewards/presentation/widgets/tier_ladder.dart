import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/reward_tier.dart';
import '../reward_tier_style.dart';

/// Silver -> Gold -> Platinum, top to bottom, joined by a line. Rows appear
/// one after another, then the line to the next tier fills to [progress].
class TierLadder extends StatefulWidget {
  const TierLadder({
    required this.current,
    required this.pointsRemaining,
    required this.progress,
    super.key,
  });

  final RewardTier current;
  final int pointsRemaining;

  /// Share of the way to the next tier, 0 to 1.
  final double progress;

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
      builder: (context, _) => Column(
        children: [
          for (final tier in RewardTier.values)
            _row(
              l10n,
              tier,
              Interval(
                _at(tier.index),
                _at(tier.index + 2),
                curve: AppMotion.standard,
              ).transform(_controller.value),
            ),
        ],
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

  /// How full the line below [tier] is: tiers already passed are full, the
  /// current one fills to the member's progress once the rows are in.
  double _lineFill(RewardTier tier) {
    if (tier.index < widget.current.index) return 1;
    if (tier.index > widget.current.index) return 0;
    final t = Interval(
      _at(_count),
      1,
      curve: AppMotion.standard,
    ).transform(_controller.value);
    return widget.progress.clamp(0.0, 1.0) * t;
  }

  /// Badge with the line down to the next badge, beside the tier's text.
  Widget _row(AppLocalizations l10n, RewardTier tier, double t) {
    final isLast = tier == RewardTier.values.last;
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, (1 - t) * AppSpacing.md),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: AppSpacing.tierBadgeSize,
                child: Column(
                  children: [
                    _TierBadge(tier: tier, letter: tier.label(l10n)[0]),
                    if (!isLast)
                      Expanded(
                        child: _TierLine(
                          key: ValueKey('tier-line-${tier.name}'),
                          fill: _lineFill(tier),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tier.label(l10n), style: AppTypography.title),
                      Text(_sub(l10n, tier), style: AppTypography.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grey track with a pink fill growing down from the top.
class _TierLine extends StatelessWidget {
  const _TierLine({required this.fill, super.key});

  final double fill;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: TierLinePainter(fill: fill));
}

class TierLinePainter extends CustomPainter {
  const TierLinePainter({required this.fill});

  /// Filled share of the segment, 0 to 1.
  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final paint = Paint()..strokeWidth = AppSpacing.tierLineStroke;
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      paint..color = AppColors.skeletonBase,
    );
    if (fill > 0) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height * fill),
        paint..color = AppColors.accent,
      );
    }
  }

  @override
  bool shouldRepaint(TierLinePainter old) => old.fill != fill;
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
