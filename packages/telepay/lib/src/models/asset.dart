import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Asset extends Equatable {
  const Asset({
    required this.asset,
    required this.blockchain,
    required this.url,
    required this.networks,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  /// The asset name.
  final String asset;

  /// The blockchain on which the asset is located.
  final String blockchain;

  /// The URL of the blockchain.
  final String url;

  /// The network on which the asset is located.
  final List<String> networks;

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  List<Object> get props => [asset, blockchain, url, networks];
}
