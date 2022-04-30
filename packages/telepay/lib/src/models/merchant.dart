import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:telepay/src/models/owner.dart';

part 'merchant.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Merchant extends Equatable {
  const Merchant({
    required this.name,
    required this.url,
    required this.logoUrl,
    required this.logoThumbnailUrl,
    required this.verified,
    required this.username,
    required this.publicProfile,
    required this.owner,
    required this.createdAt,
    this.updatedAt,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantToJson(this);

  final String name;
  final String url;
  final String logoUrl;
  final String logoThumbnailUrl;
  final bool verified;
  final String username;
  final String publicProfile;
  final Owner owner;
  final DateTime createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props {
    return [
      name,
      url,
      logoUrl,
      logoThumbnailUrl,
      verified,
      username,
      publicProfile,
      owner,
      createdAt,
      updatedAt,
    ];
  }
}
