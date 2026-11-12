// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  phone: json['phone'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
};

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  userId: json['userId'] as String,
  phone: json['phone'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phone': instance.phone,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
