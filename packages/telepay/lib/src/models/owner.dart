import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owner.g.dart';

/// {@template owner}
/// Owner model.
/// {@endtemplate}
@JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
class Owner extends Equatable {
  /// {@macro owner}
  const Owner({
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);

  /// The owner first name.
  final String firstName;

  /// The owner last name.
  final String lastName;

  ///  The owner username.
  final String username;

  @override
  List<Object> get props => [firstName, lastName, username];
}
