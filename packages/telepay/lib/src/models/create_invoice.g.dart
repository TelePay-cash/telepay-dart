// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvoice _$CreateInvoiceFromJson(Map<String, dynamic> json) =>
    CreateInvoice(
      asset: json['asset'] as String,
      blockchain: json['blockchain'] as String,
      network: json['network'] as String?,
      amount: (json['amount'] as num).toDouble(),
      expiresAt: json['expires_at'] as int?,
      description: json['description'] as String?,
      metadata: json['metadata'] as String?,
      successUrl: json['success_url'] as String?,
      cancelUrl: json['cancel_url'] as String?,
    );

Map<String, dynamic> _$CreateInvoiceToJson(CreateInvoice instance) {
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
  writeNotNull('description', instance.description);
  writeNotNull('metadata', instance.metadata);
  writeNotNull('expires_at', instance.expiresAt);
  writeNotNull('success_url', instance.successUrl);
  writeNotNull('cancel_url', instance.cancelUrl);
  return val;
}
