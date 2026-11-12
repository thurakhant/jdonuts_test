import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// Bottom sheet for social sign-in and legal links; no real integration.
Future<void> showPlaceholderSheet(BuildContext context, {String? title}) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title ?? l10n.placeholderSheetTitle, style: AppTypography.title),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.placeholderSheetBody, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    ),
  );
}
