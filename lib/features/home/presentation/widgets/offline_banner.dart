import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// Slim persistent strip shown while the device is offline.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 14,
            color: AppColors.textOnPrimary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context)!.offlineBanner,
            style: AppTypography.caption.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
