import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// Scaffold around the bottom-nav branches (Home, Reward, placeholders,
/// Settings). Slice 5 replaces the bar with the sliding-pill design.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: l10n.homeTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            label: l10n.rewardTab,
          ),
          const NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: '',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: '',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.settingsTab,
          ),
        ],
      ),
    );
  }
}
