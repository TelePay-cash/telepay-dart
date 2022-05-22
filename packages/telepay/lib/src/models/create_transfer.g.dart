// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransfer _$CreateTransferFromJson(Map<String, dynamic> json) =>
    CreateTransfer(
      asset: json['asset'] as String,
      blockchain: json['blockchain'] as String,
      network: json['network'] as String?,
      amount: (json['amount'] as num).toDouble(),
      username: json['username'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$CreateTransferToJson(CreateTransfer instance) {
  final val = <String, dynamic>{
    'asset': instance.asset,
    'blockchain': instance.blockchain,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('network', instance.network);
  val['amount'] = instance.amount;
  val['username'] = instance.username;
  writeNotNull('message', instance.message);
  return val;
}
