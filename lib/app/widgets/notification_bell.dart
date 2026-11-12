import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Display-only bell (shared by Home and Rewards): an orange capsule with a
/// white bell and a white unread-count dot, as in the design screens.
class NotificationBell extends StatelessWidget {
  const NotificationBell({
    required this.count,
    this.flushRight = false,
    super.key,
  });

  final int count;

  /// In the design the Home capsule is attached to the right screen edge,
  /// so only its left side is rounded.
  final bool flushRight;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context)!.notificationsLabel;
    return Semantics(
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.highlight,
          borderRadius: flushRight
              ? const BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.pill),
                )
              : const BorderRadius.all(Radius.circular(AppRadius.pill)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications_none,
                size: 20,
                color: AppColors.textOnPrimary,
              ),
              if (count > 0) ...[
                const SizedBox(width: AppSpacing.xs),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: Center(
                      child: Text(
                        '$count',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
