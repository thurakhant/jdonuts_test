import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import 'crown_icon.dart';
import 'pill_nav_bar.dart';
import 'donut_icon.dart';

/// Scaffold around the bottom-nav branches (Home, Reward, J'Donuts, Orders,
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
      // The page draws behind the bar, so on Home the shops landscape runs
      // under it instead of stopping at a background strip.
      extendBody: true,
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
                  iconBuilder: (color, size) =>
                      DonutIcon(color: color, size: size),
                  label: l10n.donutsTab,
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
