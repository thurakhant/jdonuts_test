import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// The one member record Home and Rewards both read.
@freezed
abstract class Member with _$Member {
  const factory Member({
    required String id,
    required String name,
    required String avatarAsset,
    required String tier,
    required int totalPoints,
    required int pointsToNextTier,
    required String nextTier,
    required int notificationCount,

    /// How far the member is from the current tier to the next, 0 to 1.
    required double tierProgress,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
