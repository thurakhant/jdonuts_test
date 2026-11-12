import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/reward_tier.dart';

/// How a tier looks on screen: its badge colour and translated name.
extension RewardTierStyle on RewardTier {
  Color get color => switch (this) {
    RewardTier.silver => AppColors.tierSilver,
    RewardTier.gold => AppColors.tierGold,
    RewardTier.platinum => AppColors.tierPlatinum,
  };

  String label(AppLocalizations l10n) => switch (this) {
    RewardTier.silver => l10n.tierSilver,
    RewardTier.gold => l10n.tierGold,
    RewardTier.platinum => l10n.tierPlatinum,
  };
}
