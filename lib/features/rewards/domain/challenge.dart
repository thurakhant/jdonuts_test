/// Which progress painter a challenge card uses.
enum ChallengeStyle { quarterDonut, coffeeCup }

class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.style,
    required this.goal,
    required this.progress,
    required this.rewardPoints,
    this.claimed = false,
  });

  final String id;
  final String title;
  final ChallengeStyle style;
  final int goal;
  final int progress;
  final int rewardPoints;
  final bool claimed;

  double get fraction => goal == 0 ? 0 : (progress / goal).clamp(0, 1);

  /// Goal reached and the reward is waiting to be claimed.
  bool get canClaim => progress >= goal && !claimed;

  Challenge copyWith({bool? claimed}) => Challenge(
    id: id,
    title: title,
    style: style,
    goal: goal,
    progress: progress,
    rewardPoints: rewardPoints,
    claimed: claimed ?? this.claimed,
  );
}

/// One line of the points history.
class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.title,
    required this.points,
    required this.daysAgo,
  });

  final String id;
  final String title;
  final int points;
  final int daysAgo;
}
