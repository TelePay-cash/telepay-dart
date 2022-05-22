import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_withdraw.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class CreateWithdraw extends Equatable {
  const CreateWithdraw({
    required this.asset,
    required this.blockchain,
    required this.network,
    required this.amount,
    required this.toAddress,
    this.message,
  });
  factory CreateWithdraw.fromJson(Map<String, dynamic> json) =>
      _$CreateWithdrawFromJson(json);

  /// The asset to estimate the feed from.
  final String asset;

  /// The invoice blockchain, on which the asset is located.
  final String blockchain;

  /// The blockchain network, on which the asset is located.
  ///
  /// Examples: "testnet" and "mainnet" in TON.
  final String? network;

  /// The amount to estimate the feed from.
  final double amount;

  /// The destination wallet address to estimate the feed.
  final String toAddress;

  /// Optional message or payload.
  final String? message;

  Map<String, dynamic> toJson() => _$CreateWithdrawToJson(this);

  @override
  List<Object?> get props {
    return [
      asset,
      blockchain,
      network,
      amount,
      toAddress,
      message,
    ];
  }
}
