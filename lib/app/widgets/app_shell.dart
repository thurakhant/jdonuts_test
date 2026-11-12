import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import 'crown_icon.dart';
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
                  iconBuilder: (color, size) =>
                      CrownIcon(color: color, size: size),
                  label: l10n.rewardTab,
                ),
                PillNavItem(
                  icon: Icons.radio_button_checked,
                  label: l10n.scanTab,
                ),
                PillNavItem(
                  icon: Icons.account_balance_wallet_outlined,
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
