import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Friendly message for an empty or failed section, with optional Retry.
class SectionMessage extends StatelessWidget {
  const SectionMessage({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(child: Text(message, style: AppTypography.caption)),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
        ],
      ),
    );
  }
}
