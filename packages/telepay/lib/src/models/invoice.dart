// {
//  "number": "GB9Q1QEKZB",
//  "asset": "TON",
//  "blockchain": "TON",
//  "network": "testnet",
//  "status": "expired",
//  "amount": "0.010000000000000000",
//  "description": "First invoice",
//  "hidden_message": null,
//  "metadata": null,
//  "checkout_url": "https://telepay.cash/checkout/GB9Q1QEKZB",
//  "success_url": null,
//  "cancel_url": null,
//  "explorer_url": null,
//  "expires_at": "2022-04-29T21:57:09.947377Z",
//  "created_at": "2022-04-29T21:42:09.947450Z",
//  "updated_at": "2022-04-29T21:57:11.154336Z"
//}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Invoice extends Equatable {
  const Invoice({
    required this.number,
    required this.asset,
    required this.blockchain,
    required this.network,
    required this.status,
    required this.amount,
    required this.description,
    required this.hiddenMessage,
    required this.metadata,
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
    required this.explorerUrl,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  final String number;
  final String asset;
  final String blockchain;
  final String network;
  final String status;
  final String amount;
  final String description;
  final String? hiddenMessage;
  final String? metadata;
  final String checkoutUrl;
  final String? successUrl;
  final String? cancelUrl;
  final String? explorerUrl;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  @override
  List<Object?> get props => [
        number,
        asset,
        blockchain,
        network,
        status,
        amount,
        description,
        hiddenMessage,
        metadata,
        checkoutUrl,
        successUrl,
        cancelUrl,
        explorerUrl,
        expiresAt,
        createdAt,
        updatedAt,
      ];
}
