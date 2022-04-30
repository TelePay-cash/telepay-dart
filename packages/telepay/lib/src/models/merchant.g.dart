// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchant _$MerchantFromJson(Map<String, dynamic> json) => Merchant(
      name: json['name'] as String,
      url: json['url'] as String,
      logoUrl: json['logo_url'] as String,
      logoThumbnailUrl: json['logo_thumbnail_url'] as String,
      verified: json['verified'] as bool,
      username: json['username'] as String,
      publicProfile: json['public_profile'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'logo_url': instance.logoUrl,
      'logo_thumbnail_url': instance.logoThumbnailUrl,
      'verified': instance.verified,
      'username': instance.username,
      'public_profile': instance.publicProfile,
      'owner': instance.owner.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
