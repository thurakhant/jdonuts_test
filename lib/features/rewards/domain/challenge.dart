import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

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

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String imageAsset,
    required ChallengeStyle style,
    required int goal,
    required int progress,
    required int rewardPoints,
  }) = _Challenge;

  const Challenge._();

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  double get fraction => goal == 0 ? 0 : (progress / goal).clamp(0, 1);

  /// Goal reached: the Earn button is active.
  bool get isComplete => progress >= goal;
}
