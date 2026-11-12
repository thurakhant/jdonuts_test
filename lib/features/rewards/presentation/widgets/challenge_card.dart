import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/entrance.dart';
import '../../../../app/widgets/orange_badge.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/challenge.dart';
import 'challenge_painters.dart';

/// One challenge: animated progress art, title, count, an Earn button or
/// Claimed mark, and a reward badge that pops in.
class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    required this.challenge,
    required this.index,
    required this.onClaim,
    super.key,
  });

  final Challenge challenge;
  final int index;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = challenge;
    return StaggeredEntrance(
      index: index,
      step: AppMotion.cardStagger,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: c.fraction),
                  duration: AppMotion.effective(
                    context,
                    AppMotion.progressRing,
                  ),
                  curve: AppMotion.standard,
                  builder: (_, value, _) => CustomPaint(
                    size: const Size.square(AppSpacing.challengeArtSize),
                    painter: painterFor(c.style, value),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.title, style: AppTypography.title),
                      Text(
                        l10n.challengeProgress(c.progress, c.goal),
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: AppMotion.effective(context, AppMotion.base),
                  child: _action(l10n),
                ),
              ],
            ),
          ),
          Positioned(
            top: -AppSpacing.sm,
            right: AppSpacing.md,
            child: PopIn(
              key: ValueKey('badge-${c.id}-${c.claimed}'),
              delay: c.claimed
                  ? Duration.zero
                  : AppMotion.badgePopDelay + AppMotion.cardStagger * index,
              child: c.claimed
                  ? const _ClaimedBadge()
                  : OrangeBadge(l10n.rewardPoints(formatMmk(c.rewardPoints))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(AppLocalizations l10n) {
    if (challenge.claimed) {
      return Text(
        l10n.claimedLabel,
        key: const ValueKey('claimed'),
        style: AppTypography.caption.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w700,
        ),
      );
    }
    if (challenge.canClaim) {
      return ElevatedButton(
        key: const ValueKey('earn'),
        onPressed: onClaim,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.earnButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          backgroundColor: AppColors.accent,
        ),
        child: Text(l10n.earnButton),
      );
    }
    return const SizedBox.shrink(key: ValueKey('none'));
  }
}

class _ClaimedBadge extends StatelessWidget {
  const _ClaimedBadge();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          Icons.check,
          size: AppSpacing.iconSm,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}
