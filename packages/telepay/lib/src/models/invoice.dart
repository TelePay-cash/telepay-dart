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
    this.network,
    required this.status,
    required this.amount,
    this.description,
    this.hiddenMessage,
    this.metadata,
    this.checkoutUrl,
    this.onchainUrl,
    this.successUrl,
    this.cancelUrl,
    this.explorerUrl,
    this.expiresAt,
    required this.createdAt,
    this.updatedAt,
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
  final String? network;

  /// The invoice status
  final String status;

  /// The invoice amount.
  final String amount;

  /// The invoice description.
  final String? description;

  /// The invoice hidden message.
  final String? hiddenMessage;

  /// The invoice attached metadata.
  final dynamic metadata;

  /// The invoice checkout url.
  final String? checkoutUrl;

  /// Is a deep link to optionally present it to your users.
  final String? onchainUrl;

  /// The URL to which the user is redirected to when the invoice is completed.
  final String? successUrl;

  /// The URL to which the user is redirected to when the invoice is cancelled.
  final String? cancelUrl;

  /// The URL the blockchange explorer.
  final String? explorerUrl;

  /// The invoice expiration date.
  final DateTime? expiresAt;

  /// The invoice creation date.
  final DateTime createdAt;

  /// The invoice last update date.
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
