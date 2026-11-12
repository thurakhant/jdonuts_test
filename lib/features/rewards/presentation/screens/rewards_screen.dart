import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/notification_bell.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../member/application/member_providers.dart';
import '../../../member/domain/member.dart';
import '../../application/rewards_providers.dart';
import '../../domain/reward_tier.dart';
import '../widgets/challenge_card.dart';
import '../widgets/history_list.dart';
import '../widgets/points_ring.dart';
import '../widgets/rewards_tab_bar.dart';
import '../widgets/tier_ladder.dart';

/// Points ring, tier ladder and the Challenges / History tabs, all driven
/// by the shared member record.
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
                          l10n.rewardsTitle,
                          style: AppTypography.headline,
                        ),
                      ),
                      NotificationBell(count: member.notificationCount),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(child: _ring(member)),
                  const SizedBox(height: AppSpacing.lg),
                  _ladder(member),
                  const SizedBox(height: AppSpacing.lg),
                  RewardsTabBar(
                    labels: [l10n.tabChallenges, l10n.tabHistory],
                    selected: _tab,
                    onSelected: _select,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedSwitcher(
                    duration: AppMotion.effective(context, AppMotion.base),
                    transitionBuilder: _slideFade,
                    child: KeyedSubtree(
                      key: ValueKey(_tab),
                      child: _tab == 0 ? const _Challenges() : const _History(),
                    ),
                  ),
                ],
              ),
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

  Widget _ring(Member m) => PointsRing(
    points: m.totalPoints,
    target: m.totalPoints + m.pointsToNextTier,
    nextTierName: m.nextTier,
  );

  Widget _ladder(Member m) => TierLadder(
    current: RewardTier.fromName(m.tier),
    progressToNext: m.totalPoints / (m.totalPoints + m.pointsToNextTier),
  );
}

class _Challenges extends ConsumerWidget {
  const _Challenges();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ref
        .watch(challengesProvider)
        .when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => Text(l10n.rewardsLoadError),
          data: (items) => Column(
            children: [
              for (final (i, c) in items.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: ChallengeCard(
                    challenge: c,
                    index: i,
                    onClaim: () =>
                        ref.read(challengesProvider.notifier).claim(c.id),
                  ),
                ),
            ],
          ),
        );
  }
}

class _History extends ConsumerWidget {
  const _History();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ref
        .watch(historyProvider)
        .when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => Text(l10n.rewardsLoadError),
          data: (items) => HistoryList(entries: items),
        );
  }
}
