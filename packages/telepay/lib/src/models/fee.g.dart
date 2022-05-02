// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fee _$FeeFromJson(Map<String, dynamic> json) => Fee(
      blockchainFee: (json['blockchain_fee'] as num).toDouble(),
      processingFee: (json['processing_fee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$FeeToJson(Fee instance) => <String, dynamic>{
      'blockchain_fee': instance.blockchainFee,
      'processing_fee': instance.processingFee,
      'total': instance.total,
    };
