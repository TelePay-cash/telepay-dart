import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_transfer.g.dart';

/// {@template create_transfer}
/// Model for create a transference.
/// {@endtemplate}
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class CreateTransfer extends Equatable {
  /// {@macro create_transfer}
  const CreateTransfer({
    required this.asset,
    required this.blockchain,
    required this.network,
    required this.amount,
    required this.username,
    this.message,
  });

  factory CreateTransfer.fromJson(Map<String, dynamic> json) =>
      _$CreateTransferFromJson(json);

  /// The asset to transfer
  final String asset;

  /// The blockchain on which the asset is located
  final String blockchain;

  /// The blockchain network on which the asset is located
  final String? network;

  /// The amount to transfer
  final double amount;

  /// The username of the destination merchant or user.
  ///
  /// Example: lugodev.
  final String username;

  /// Optional message attached to the transfer, visible to the destination
  /// merchant or user.
  final String? message;

  Map<String, dynamic> toJson() => _$CreateTransferToJson(this);

  @override
  List<Object?> get props {
    return [
      asset,
      blockchain,
      network,
      amount,
      username,
      message,
    ];
  }
}
