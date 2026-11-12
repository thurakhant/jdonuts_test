import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/entrance.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/rewards_providers.dart';
import '../../domain/challenge.dart';
import 'challenge_painters.dart';
import 'earn_button.dart';

/// One challenge: the product picture with progress painted over it, the
/// title, "done/goal", and an EARN button with the points reward. The
/// artwork and the button read the same state: progress and claim status.
class ChallengeCard extends ConsumerWidget {
  const ChallengeCard({
    required this.challenge,
    required this.index,
    super.key,
  });

  final Challenge challenge;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final c = challenge;
    final claimed = ref.watch(claimedChallengesProvider).contains(c.id);
    return StaggeredEntrance(
      index: index,
      step: AppMotion.cardStagger,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            _Art(challenge: c),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, style: AppTypography.title),
                  Text(
                    l10n.challengeProgress(c.progress, c.goal),
                    style: AppTypography.body,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Wraps the points under the button when space is short.
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      EarnButton(
                        enabled: c.isComplete && !claimed,
                        claimed: claimed,
                        onPressed: () => ref
                            .read(claimedChallengesProvider.notifier)
                            .claim(c.id),
                      ),
                      Text(
                        l10n.pointsShort(formatMmk(c.rewardPoints)),
                        style: AppTypography.body,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Picture plus progress painter, animated from empty to the current value.
class _Art extends StatelessWidget {
  const _Art({required this.challenge});

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final c = challenge;
    const size = AppSpacing.challengeArtSize;
    // A finished challenge starts fully coloured, so it never flashes grey
    // when the list is rebuilt (for example after switching tabs).
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: c.isComplete ? c.fraction : 0, end: c.fraction),
      duration: AppMotion.effective(context, AppMotion.progressRing),
      curve: AppMotion.standard,
      builder: (_, value, _) => SizedBox.square(
        dimension: size,
        child: switch (c.style) {
          ChallengeStyle.quarterDonut => _donut(c, value),
          ChallengeStyle.coffeeCup => _coffee(c, value),
        },
      ),
    );
  }

  /// Greyscale picture with the finished quarters coloured in on top; the
  /// progress lives on the doughnut itself, with no ring around it.
  Widget _donut(Challenge c, double progress) {
    final image = ClipOval(child: Image.asset(c.imageAsset, fit: BoxFit.cover));
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(greyscaleMatrix),
          child: image,
        ),
        ClipPath(clipper: SectorClipper(2 * math.pi * progress), child: image),
      ],
    );
  }

  /// The cup with an arc over it that fills toward the goal.
  Widget _coffee(Challenge c, double progress) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Image.asset(c.imageAsset, fit: BoxFit.contain),
        ),
        CustomPaint(painter: CoffeeCupPainter(progress: progress)),
      ],
    );
  }
}
