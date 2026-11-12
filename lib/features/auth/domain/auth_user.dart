/// A registered user.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  factory AuthUser.fromJson(Map<String, Object?> json) => AuthUser(
    id: json['id']! as String,
    phone: json['phone']! as String,
    firstName: json['firstName']! as String,
    lastName: json['lastName']! as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth']! as String),
  );

  final String id;

  /// E.164, e.g. `+959254135592`.
  final String phone;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  String get fullName => lastName.isEmpty ? firstName : '$firstName $lastName';

  Map<String, Object?> toJson() => {
    'id': id,
    'phone': phone,
    'firstName': firstName,
    'lastName': lastName,
    'dateOfBirth': dateOfBirth.toIso8601String(),
  };
}

/// The signed-in user as remembered between launches.
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.phone,
    required this.firstName,
    required this.lastName,
  });

  factory AuthSession.fromUser(AuthUser user) => AuthSession(
    userId: user.id,
    phone: user.phone,
    firstName: user.firstName,
    lastName: user.lastName,
  );

  factory AuthSession.fromJson(Map<String, Object?> json) => AuthSession(
    userId: json['userId']! as String,
    phone: json['phone']! as String,
    firstName: json['firstName']! as String,
    lastName: json['lastName']! as String,
  );

  final String userId;
  final String phone;
  final String firstName;
  final String lastName;

  Map<String, Object?> toJson() => {
    'userId': userId,
    'phone': phone,
    'firstName': firstName,
    'lastName': lastName,
  };
}
