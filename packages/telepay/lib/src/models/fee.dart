import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fee.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Fee extends Equatable {
  const Fee({
    required this.blockchainFee,
    required this.processingFee,
    required this.total,
  });

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);

  /// Fee in the blockchain.
  final double blockchainFee;

  /// Fee in the processing.
  final double processingFee;

  /// Total fee.
  final double total;

  Map<String, dynamic> toJson() => _$FeeToJson(this);

  @override
  List<Object> get props => [blockchainFee, processingFee, total];
}
