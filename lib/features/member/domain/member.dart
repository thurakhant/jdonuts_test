/// The one member record Home and Rewards both read.
class Member {
  const Member({
    required this.id,
    required this.name,
    required this.avatarAsset,
    required this.tier,
    required this.totalPoints,
    required this.pointsToNextTier,
    required this.nextTier,
    required this.notificationCount,
  });

  final String id;
  final String name;
  final String avatarAsset;
  final String tier;
  final int totalPoints;
  final int pointsToNextTier;
  final String nextTier;
  final int notificationCount;
}
