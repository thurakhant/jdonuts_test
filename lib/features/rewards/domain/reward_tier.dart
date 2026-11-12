import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// The membership ladder, lowest first.
enum RewardTier {
  bronze(AppColors.tierBronze),
  silver(AppColors.tierSilver),
  gold(AppColors.tierGold),
  platinum(AppColors.tierPlatinum);

  const RewardTier(this.color);

  final Color color;

  /// Reads the tier name stored on the member record ("Silver"). Unknown
  /// names fall back to the lowest tier.
  static RewardTier fromName(String name) {
    final key = name.toLowerCase();
    return values.firstWhere((t) => t.name == key, orElse: () => bronze);
  }

  String label(AppLocalizations l10n) => switch (this) {
    bronze => l10n.tierBronze,
    silver => l10n.tierSilver,
    gold => l10n.tierGold,
    platinum => l10n.tierPlatinum,
  };
}
