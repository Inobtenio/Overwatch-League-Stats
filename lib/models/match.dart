import 'package:json_annotation/json_annotation.dart';
part 'match.g.dart';

@JsonSerializable()
class CurrentMatch extends Object with _$CurrentMatchSerializerMixin {
  final String id;
  final map_states;
  final map_types;
  final maps;
  final match_id;
  final match_state;
  final players;
  final seen_players;
  final teams;

  CurrentMatch({this.id, this.map_states, this.map_types, this.maps, this.match_id, this.match_state, this.players, this.seen_players, this.teams});

  factory CurrentMatch.fromJson(Map<String, dynamic> json) => _$CurrentMatchFromJson(json);
}
