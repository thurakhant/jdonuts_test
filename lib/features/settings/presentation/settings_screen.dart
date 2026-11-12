import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/application/auth_providers.dart';

/// Minimal Settings tab with a Log out row so sign-out can be tested.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTab)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logOut),
            onTap: () => ref.read(currentSessionProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
