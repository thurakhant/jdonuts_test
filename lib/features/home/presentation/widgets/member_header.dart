import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/notification_bell.dart';
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
    return Padding(
      // No right padding: the bell capsule sits flush against the screen
      // edge, as in the design screens.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _RingedAvatar(asset: member.avatarAsset),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: AppTypography.headline),
                    Text(
                      l10n.tierMember(member.tier),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              NotificationBell(
                count: member.notificationCount,
                flushRight: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // White capsule, as in the design screens (no progress bar there).
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                l10n.pointsLeftToTier(
                  formatMmk(member.pointsToNextTier),
                  member.nextTier,
                ),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Round avatar with the partial orange ring from the design screens.
class _RingedAvatar extends StatelessWidget {
  const _RingedAvatar({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ExcludeSemantics(child: CustomPaint(painter: _ArcPainter())),
          ),
          ClipOval(child: JdImage(asset, width: 48, height: 48)),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawArc(
      rect.deflate(1.5),
      // Open on the lower-left, as in the mock.
      -2.0,
      4.4,
      false,
      Paint()
        ..color = AppColors.highlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => false;
}
