// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_withdraw.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWithdraw _$CreateWithdrawFromJson(Map<String, dynamic> json) =>
    CreateWithdraw(
      asset: json['asset'] as String,
      blockchain: json['blockchain'] as String,
      network: json['network'] as String,
      amount: (json['amount'] as num).toDouble(),
      toAddress: json['to_address'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$CreateWithdrawToJson(CreateWithdraw instance) {
  final val = <String, dynamic>{
    'asset': instance.asset,
    'blockchain': instance.blockchain,
    'network': instance.network,
    'amount': instance.amount,
    'to_address': instance.toAddress,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  return val;
}
