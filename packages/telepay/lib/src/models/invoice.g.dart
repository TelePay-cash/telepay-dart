// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      number: json['number'] as String,
      asset: json['asset'] as String,
      blockchain: json['blockchain'] as String,
      network: json['network'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      description: json['description'] as String,
      hiddenMessage: json['hidden_message'] as String?,
      metadata: json['metadata'] as String?,
      checkoutUrl: json['checkout_url'] as String,
      successUrl: json['success_url'] as String?,
      cancelUrl: json['cancel_url'] as String?,
      explorerUrl: json['explorer_url'] as String?,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'number': instance.number,
      'asset': instance.asset,
      'blockchain': instance.blockchain,
      'network': instance.network,
      'status': instance.status,
      'amount': instance.amount,
      'description': instance.description,
      'hidden_message': instance.hiddenMessage,
      'metadata': instance.metadata,
      'checkout_url': instance.checkoutUrl,
      'success_url': instance.successUrl,
      'cancel_url': instance.cancelUrl,
      'explorer_url': instance.explorerUrl,
      'expires_at': instance.expiresAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
