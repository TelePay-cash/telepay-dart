// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      username: json['username'] as String,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'username': instance.username,
    };
