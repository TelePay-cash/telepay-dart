import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

/// {@template invoice}
/// Invoice model.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Invoice extends Equatable {
  /// {@macro invoice}
  const Invoice({
    required this.number,
    required this.asset,
    required this.blockchain,
    required this.network,
    required this.status,
    required this.amount,
    this.description,
    this.hiddenMessage,
    this.metadata,
    required this.checkoutUrl,
    this.successUrl,
    this.cancelUrl,
    this.explorerUrl,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  final String number;

  /// The invoice asset
  final String asset;

  /// The invoice blockchain, on on which the asset is located
  final String blockchain;

  /// The blockchain network, on which the asset is located.
  ///
  /// Examples: "testnet" and "mainnet" in TON.
  final String network;
  final String status;

  /// The invoice amount.
  final String amount;

  /// The invoice description.
  final String? description;
  final String? hiddenMessage;

  /// The invoice attached metadata.
  final Map<String, dynamic>? metadata;
  final String checkoutUrl;

  /// The URL to which the user is redirected to when the invoice is completed.
  final String? successUrl;

  /// The URL to which the user is redirected to when the invoice is cancelled.
  final String? cancelUrl;
  final String? explorerUrl;

  /// Minutes to invoice expiration.
  ///
  /// If not defined, default is 600 minutes (10 hours).
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
