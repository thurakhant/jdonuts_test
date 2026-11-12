import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/failure_text.dart';
import '../../../../app/widgets/section_message.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../member/application/member_providers.dart';
import '../../../member/domain/member.dart';
import '../../application/rewards_providers.dart';
import '../../domain/challenge.dart';
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
    final member = ref.watch(memberProvider);
    final challenges = ref.watch(challengesProvider);
    return Scaffold(
      // White behind the heading, tiers and donut; the card list sits on a
      // light grey band below.
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _header(l10n, challenges.value?.length ?? 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.lg,
                AppSpacing.screenEdge,
                AppSpacing.lg,
              ),
              child: _summaryState(l10n, member),
            ),
            _tabSelector(l10n),
            _tabContent(l10n, challenges),
          ],
        ),
      ),
    );
  }

  /// Heading and the Rewards pill. No right padding: the pill sits flush on
  /// the screen edge.
  Widget _header(AppLocalizations l10n, int rewardCount) {
    return Padding(
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
              child: Text(l10n.rewardsHeading, style: AppTypography.headline),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          RewardsPill(label: l10n.rewardsPill, count: rewardCount),
        ],
      ),
    );
  }

  /// The selector straddles the white/grey boundary: half its height on
  /// each colour.
  Widget _tabSelector(AppLocalizations l10n) {
    return Stack(
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
    );
  }

  /// The selected tab's content on the grey band. The shell's nav bar
  /// floats over the body, so the last card needs room to scroll clear.
  Widget _tabContent(
    AppLocalizations l10n,
    AsyncValue<List<Challenge>> challenges,
  ) {
    return Container(
      color: AppColors.background,
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
              ? _challengeList(l10n, challenges)
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
    );
  }

  String _errorText(AppLocalizations l10n, Object error) =>
      '${l10n.sectionError} ${dataErrorMessage(l10n, error)}';

  Widget _summaryState(AppLocalizations l10n, AsyncValue<Member?> member) {
    return member.when(
      loading: () => const SkeletonBox(
        height: AppSpacing.pointsRingSize,
        radius: AppRadius.lg,
      ),
      error: (error, _) => SectionMessage(
        message: _errorText(l10n, error),
        // Re-runs the catalog import too, in case that is what failed.
        onRetry: () => ref
          ..invalidate(catalogReadyProvider)
          ..invalidate(memberProvider),
      ),
      data: (m) =>
          m == null ? SectionMessage(message: l10n.sectionEmpty) : _summary(m),
    );
  }

  Widget _challengeList(
    AppLocalizations l10n,
    AsyncValue<List<Challenge>> challenges,
  ) {
    return challenges.when(
      loading: () => Column(
        children: [
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: SkeletonBox(
                height: AppSpacing.challengeArtSize + 2 * AppSpacing.md,
                radius: AppRadius.lg,
              ),
            ),
        ],
      ),
      error: (error, _) => SectionMessage(
        message: _errorText(l10n, error),
        onRetry: () => ref
          ..invalidate(catalogReadyProvider)
          ..invalidate(challengesProvider),
      ),
      data: (items) => items.isEmpty
          ? SectionMessage(message: l10n.sectionEmpty)
          : Column(
              children: [
                for (final (i, c) in items.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ChallengeCard(challenge: c, index: i),
                  ),
              ],
            ),
    );
  }

  /// Ladder on the left half, donut on the right; the taller of the two
  /// sets the height, so larger text pushes the section down, not over.
  Widget _summary(Member m) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: TierLadder(
              current: RewardTier.fromName(m.tier),
              pointsRemaining: m.pointsToNextTier,
              progress: m.tierProgress,
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
            child: PointsRing(
              points: m.totalPoints,
              progress: m.tierProgress,
              offscreenRight: AppSpacing.pointsRingBleed,
            ),
          ),
        ),
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
