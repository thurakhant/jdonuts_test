import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Display-only bell (shared by Home and Rewards) with an unread-count badge.
class NotificationBell extends StatelessWidget {
  const NotificationBell({required this.count, super.key});

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
