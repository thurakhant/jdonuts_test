import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// A registered user.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,

    /// E.164, e.g. `+959254135592`.
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) = _AuthUser;

  const AuthUser._();

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  String get fullName => lastName.isEmpty ? firstName : '$firstName $lastName';
}

/// The signed-in user as remembered between launches.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String userId,
    required String phone,
    required String firstName,
    required String lastName,
  }) = _AuthSession;

  factory AuthSession.fromUser(AuthUser user) => AuthSession(
    userId: user.id,
    phone: user.phone,
    firstName: user.firstName,
    lastName: user.lastName,
  );

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
