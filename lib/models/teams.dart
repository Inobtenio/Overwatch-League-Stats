import 'package:json_annotation/json_annotation.dart';
part 'teams.g.dart';

@JsonSerializable()
class Teams extends Object with _$TeamsSerializerMixin {
  final Map<String, dynamic> teams;

  Teams({this.teams});

  factory Teams.fromJson(Map<String, dynamic> json) => _$TeamsFromJson(json);
}
