import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/widgets/failure_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/application/auth_providers.dart';

/// Minimal Settings tab with a Log out row so sign-out can be tested.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    final failure = await ref.read(currentSessionProvider.notifier).signOut();
    if (!mounted) return;
    setState(() => _signingOut = false);
    if (failure == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(dataErrorMessage(AppLocalizations.of(context)!, failure)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTab)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logOut),
            onTap: _signingOut ? null : _signOut,
          ),
        ],
      ),
    );
  }
}
