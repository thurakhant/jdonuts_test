import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// Month names (1-12) from the ARB file.
List<String> monthNames(AppLocalizations l) => [
  l.month1,
  l.month2,
  l.month3,
  l.month4,
  l.month5,
  l.month6,
  l.month7,
  l.month8,
  l.month9,
  l.month10,
  l.month11,
  l.month12,
];

/// Read-only field that opens a month list in a bottom sheet.
class MonthField extends StatelessWidget {
  const MonthField({required this.month, required this.onPicked, super.key});

  final int? month;
  final ValueChanged<int> onPicked;

  Future<void> _pick(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final names = monthNames(l10n);
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => ListView(
        children: [
          for (var i = 0; i < names.length; i++)
            ListTile(
              title: Text(names[i]),
              selected: month == i + 1,
              onTap: () => Navigator.of(context).pop(i + 1),
            ),
        ],
      ),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = month == null ? null : monthNames(l10n)[month! - 1];
    return InkWell(
      key: const ValueKey('dob-month'),
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
        ),
        child: Text(
          selected ?? l10n.month,
          style: selected == null
              ? AppTypography.body.copyWith(color: AppColors.textSecondary)
              : AppTypography.body,
        ),
      ),
    );
  }
}
