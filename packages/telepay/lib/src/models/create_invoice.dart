import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_invoice.g.dart';

/// Creates an invoice, associated to your merchant
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class CreateInvoice extends Equatable {
  const CreateInvoice({
    required this.asset,
    required this.blockchain,
    required this.network,
    required this.amount,
    this.expiresAt,
    this.description,
    this.metadata,
    this.successUrl,
    this.cancelUrl,
  });

  factory CreateInvoice.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceFromJson(json);

  /// The invoice asset
  final String asset;

  /// The invoice blockchain, on on which the asset is located
  final String blockchain;

  /// The blockchain network, on which the asset is located.
  ///
  /// Examples: "testnet" and "mainnet" in TON.
  final String? network;

  /// The invoice amount.
  final double amount;

  /// The invoice description.
  final String? description;

  /// The invoice attached metadata.
  final String? metadata;

  /// Minutes to invoice expiration.
  ///
  /// If not defined, default is 600 minutes (10 hours).
  final int? expiresAt;

  /// The URL to which the user is redirected to when the invoice is completed.
  final String? successUrl;

  /// The URL to which the user is redirected to when the invoice is cancelled.
  final String? cancelUrl;

  Map<String, dynamic> toJson() => _$CreateInvoiceToJson(this);

  @override
  List<Object?> get props {
    return [
      asset,
      blockchain,
      network,
      amount,
      description,
      metadata,
      expiresAt,
      successUrl,
      cancelUrl,
    ];
  }
}
