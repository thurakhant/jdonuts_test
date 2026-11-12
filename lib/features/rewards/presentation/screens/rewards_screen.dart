import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../member/application/member_providers.dart';
import '../../../member/domain/member.dart';
import '../../application/rewards_providers.dart';
import '../../domain/reward_tier.dart';
import '../widgets/challenge_card.dart';
import '../widgets/points_ring.dart';
import '../widgets/rewards_pill.dart';
import '../widgets/rewards_tab_bar.dart';
import '../widgets/tier_ladder.dart';

/// Tier ladder and points ring side by side, then the "Eat more earn more"
/// and "Gift" tabs. Member and challenges come from the local database.
class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  int _tab = 0;
  int _direction = 1;

  void _select(int index) {
    if (index == _tab) return;
    setState(() {
      _direction = index > _tab ? 1 : -1;
      _tab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final member = ref.watch(memberProvider).value;
    final challenges = ref.watch(challengesProvider).value ?? const [];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: member == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.screenEdge),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.rewardsHeading,
                          style: AppTypography.headline,
                        ),
                      ),
                      RewardsPill(
                        label: l10n.rewardsPill,
                        count: challenges.length,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _summary(member),
                  const SizedBox(height: AppSpacing.lg),
                  RewardsTabBar(
                    labels: [l10n.tabEatMore, l10n.tabGift],
                    selected: _tab,
                    onSelected: _select,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedSwitcher(
                    duration: AppMotion.effective(context, AppMotion.base),
                    transitionBuilder: _slideFade,
                    child: KeyedSubtree(
                      key: ValueKey(_tab),
                      child: _tab == 0
                          ? Column(
                              children: [
                                for (final (i, c) in challenges.indexed)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: ChallengeCard(
                                      challenge: c,
                                      index: i,
                                    ),
                                  ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Text(
                                l10n.giftEmpty,
                                textAlign: TextAlign.center,
                                style: AppTypography.body,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _summary(Member m) {
    final total = m.totalPoints + m.pointsToNextTier;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TierLadder(
            current: RewardTier.fromName(m.tier),
            progressToNext: m.totalPoints / total,
            pointsRemaining: m.pointsToNextTier,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PointsRing(points: m.totalPoints, target: total),
      ],
    );
  }

  Widget _slideFade(Widget child, Animation<double> animation) {
    final curved = animation.drive(CurveTween(curve: AppMotion.standard));
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: Offset(AppMotion.tabSwitchSlide.dx * _direction, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
