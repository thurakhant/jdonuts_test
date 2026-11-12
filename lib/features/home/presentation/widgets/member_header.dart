import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../member/application/member_providers.dart';
import '../../../member/domain/member.dart';

/// Avatar, name, tier chip, bell and the "points left" progress strip. Reads
/// the shared member record, so it always agrees with Rewards.
class MemberHeader extends ConsumerWidget {
  const MemberHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(memberProvider)
        .when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenEdge),
            child: SkeletonBox(height: 72, radius: AppRadius.lg),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (member) =>
              member == null ? const SizedBox.shrink() : _Header(member),
        );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.member);

  final Member member;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = member.totalPoints + member.pointsToNextTier;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: JdImage(member.avatarAsset, width: 48, height: 48),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  children: [
                    Text(member.name, style: AppTypography.headline),
                    _TierChip(member.tier),
                  ],
                ),
              ),
              _Bell(count: member.notificationCount),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.pointsLeftToTier(
                formatMmk(member.pointsToNextTier),
                member.nextTier,
              ),
              style: AppTypography.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TweenAnimationBuilder<double>(
            tween: Tween(end: member.totalPoints / total),
            duration: AppMotion.progressRing,
            curve: AppMotion.standard,
            builder: (_, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                color: AppColors.accent,
                backgroundColor: AppColors.backgroundPink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip(this.tier);

  final String tier;

  Color get _color => switch (tier.toLowerCase()) {
    'gold' => AppColors.tierGold,
    'platinum' => AppColors.tierPlatinum,
    'silver' => AppColors.tierSilver,
    _ => AppColors.highlight,
  };

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          tier,
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Display-only bell with an unread-count badge.
class _Bell extends StatelessWidget {
  const _Bell({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context)!.notificationsLabel;
    return Semantics(
      label: label,
      child: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.notifications_none, size: 28),
      ),
    );
  }
}
