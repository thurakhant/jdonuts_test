import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'placeholder_sheet.dart';

/// Google / Apple / Facebook icon buttons; each opens the placeholder sheet.
class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (Icons.g_mobiledata, l10n.continueWithGoogle),
      (Icons.apple, l10n.continueWithApple),
      (Icons.facebook, l10n.continueWithFacebook),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final (icon, label) in items)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Material(
              color: AppColors.surface,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: label,
                icon: Icon(icon, color: AppColors.textPrimary),
                onPressed: () => showPlaceholderSheet(context, title: label),
              ),
            ),
          ),
      ],
    );
  }
}
