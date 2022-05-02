import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

/// {@template wallet}
/// Wallet model.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Wallet extends Equatable {
  /// {@macro wallet}
  const Wallet({
    required this.asset,
    required this.blockchain,
    required this.balance,
    required this.network,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  /// The asset to transfer.
  final String asset;

  /// The blockchain on which the asset is located.
  final String blockchain;

  /// The balance of the [Wallet].
  final double balance;

  /// The blockchain network on which the asset is located.
  final String network;

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  @override
  List<Object> get props => [asset, blockchain, balance, network];
}
