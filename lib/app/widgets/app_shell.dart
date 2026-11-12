import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import 'pill_nav_bar.dart';

/// Scaffold around the bottom-nav branches (Home, Reward, Scan, Orders,
/// Settings) with the sliding-pill bar.
class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    this.showNavBar = true,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  /// Hidden on Product detail, which is pushed inside the Home tab.
  final bool showNavBar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: !showNavBar
          ? null
          : PillNavBar(
              selectedIndex: navigationShell.currentIndex,
              onSelected: navigationShell.goBranch,
              items: [
                PillNavItem(icon: Icons.home_outlined, label: l10n.homeTab),
                PillNavItem(
                  icon: Icons.emoji_events_outlined,
                  label: l10n.rewardTab,
                ),
                PillNavItem(
                  icon: Icons.qr_code_scanner_outlined,
                  label: l10n.scanTab,
                ),
                PillNavItem(
                  icon: Icons.receipt_long_outlined,
                  label: l10n.ordersTab,
                ),
                PillNavItem(
                  icon: Icons.settings_outlined,
                  label: l10n.settingsTab,
                ),
              ],
            ),
    );
  }
}
