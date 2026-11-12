import 'dart:math' as math;

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
      // White behind the heading, tiers and donut; the card list sits on a
      // light grey band below.
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: member == null
            ? const SizedBox.shrink()
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  // No right padding: the Rewards tab sits flush on the
                  // screen edge.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenEdge,
                      AppSpacing.md,
                      0,
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.rewardsHeading,
                              style: AppTypography.headline,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        RewardsPill(
                          label: l10n.rewardsPill,
                          count: challenges.length,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenEdge,
                      AppSpacing.lg,
                      AppSpacing.screenEdge,
                      AppSpacing.lg,
                    ),
                    child: _summary(member),
                  ),
                  // The selector straddles the white/grey boundary: half
                  // its height on each colour.
                  Stack(
                    children: [
                      const Column(
                        children: [
                          SizedBox(height: AppSpacing.tabBarHeight / 2),
                          ColoredBox(
                            color: AppColors.background,
                            child: SizedBox(
                              height: AppSpacing.tabBarHeight / 2,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                      RewardsTabBar(
                        labels: [l10n.tabEatMore, l10n.tabGift],
                        selected: _tab,
                        onSelected: _select,
                      ),
                    ],
                  ),
                  Container(
                    color: AppColors.background,
                    // The shell's nav bar floats over the body, so the last
                    // card needs room to scroll clear of it.
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenEdge,
                      AppSpacing.lg,
                      AppSpacing.screenEdge,
                      AppSpacing.navBarHeight +
                          AppSpacing.xl +
                          MediaQuery.paddingOf(context).bottom,
                    ),
                    child: AnimatedSwitcher(
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
                  ),
                ],
              ),
      ),
    );
  }

  Widget _summary(Member m) {
    final height = math.max(
      AppSpacing.tierRowHeight * RewardTier.values.length,
      AppSpacing.pointsRingSize,
    );
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: TierLadder(
                current: RewardTier.fromName(m.tier),
                pointsRemaining: m.pointsToNextTier,
              ),
            ),
          ),
          // The donut bleeds past the right screen edge, as in the design.
          Align(
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: const Offset(
                AppSpacing.screenEdge + AppSpacing.pointsRingBleed,
                0,
              ),
              child: PointsRing(points: m.totalPoints),
            ),
          ),
        ],
      ),
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
