import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:telepay/src/models/owner.dart';

part 'merchant.g.dart';

/// {@template merchant}
/// Merchant model.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Merchant extends Equatable {
  /// {@macro merchant}
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

  /// The merchant name.
  final String name;

  /// The merchant URL.
  final String url;

  /// The merchant logo URL.
  final String logoUrl;

  /// The merchant logo thumbnail URL.
  final String logoThumbnailUrl;

  /// Whether the merchant is verified.
  final bool verified;

  /// The merchant username.
  final String username;

  /// The merchant public profile.
  final String publicProfile;

  /// The merchant owner.
  final Owner owner;

  /// The merchant date of creation.
  final DateTime createdAt;

  /// The merchant date of last update.
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
