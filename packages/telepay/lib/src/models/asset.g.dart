// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      asset: json['asset'] as String,
      blockchain: json['blockchain'] as String,
      url: json['url'] as String,
      networks:
          (json['networks'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'asset': instance.asset,
      'blockchain': instance.blockchain,
      'url': instance.url,
      'networks': instance.networks,
    };
