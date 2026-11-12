import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/entrance.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/challenge.dart';

/// Points earned so far, newest first.
class HistoryList extends StatelessWidget {
  const HistoryList({required this.entries, super.key});

  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        for (final (i, e) in entries.indexed)
          StaggeredEntrance(
            index: i,
            step: AppMotion.cardStagger,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.title, style: AppTypography.body),
              subtitle: Text(
                l10n.daysAgo(e.daysAgo),
                style: AppTypography.caption,
              ),
              trailing: Text(
                l10n.rewardPoints(formatMmk(e.points)),
                style: AppTypography.title.copyWith(color: AppColors.accent),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
