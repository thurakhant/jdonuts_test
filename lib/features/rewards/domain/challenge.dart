/// Which progress art a challenge card draws over its picture.
enum ChallengeStyle {
  quarterDonut,
  coffeeCup;

  static ChallengeStyle? tryParse(String? name) {
    for (final style in values) {
      if (style.name == name) return style;
    }
    return null;
  }
}

class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.style,
    required this.goal,
    required this.progress,
    required this.rewardPoints,
  });

  final String id;
  final String title;
  final String imageAsset;
  final ChallengeStyle style;
  final int goal;
  final int progress;
  final int rewardPoints;

  double get fraction => goal == 0 ? 0 : (progress / goal).clamp(0, 1);

  /// Goal reached: the Earn button is active.
  bool get isComplete => progress >= goal;
}
