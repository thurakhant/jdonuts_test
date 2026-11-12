/// The membership ladder shown on Rewards, lowest first.
enum RewardTier {
  silver,
  gold,
  platinum;

  /// Reads the tier name stored on the member record ("Silver"). Unknown
  /// names fall back to the lowest tier.
  static RewardTier fromName(String name) {
    final key = name.toLowerCase();
    return values.firstWhere((t) => t.name == key, orElse: () => silver);
  }
}
