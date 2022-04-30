import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owner.g.dart';

@JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
class Owner extends Equatable {
  const Owner({
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);

  final String firstName;
  final String lastName;
  final String username;

  @override
  List<Object> get props => [firstName, lastName, username];
}
