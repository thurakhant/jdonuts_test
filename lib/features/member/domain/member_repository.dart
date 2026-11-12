import 'member.dart';

abstract interface class MemberRepository {
  /// The single member record; null until the first import has run.
  Stream<Member?> watchMember();
}
