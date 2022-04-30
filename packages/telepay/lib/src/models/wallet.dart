// {
//   "asset": "TON",
//   "blockchain": "TON",
//   "balance": 0,
//   "network": "mainnet"
// }

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Wallet extends Equatable {
  const Wallet({
    required this.asset,
    required this.blockchain,
    required this.balance,
    required this.network,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  final String asset;
  final String blockchain;
  final double balance;
  final String network;

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  @override
  List<Object> get props => [asset, blockchain, balance, network];
}
