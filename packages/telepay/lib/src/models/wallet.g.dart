// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      asset: json['asset'] as String,
      blockchain: json['blockchain'] as String,
      balance: (json['balance'] as num).toDouble(),
      network: json['network'] as String?,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'asset': instance.asset,
      'blockchain': instance.blockchain,
      'balance': instance.balance,
      'network': instance.network,
    };
