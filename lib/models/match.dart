import 'package:json_annotation/json_annotation.dart';
part 'match.g.dart';

@JsonSerializable()
class Match extends Object with _$MatchSerializerMixin {
  final String id;
  final map_states;
  final map_types;
  final maps;
  final match_id;
  final match_state;
  final players;
  final seen_players;
  final teams;

  Match({this.id, this.map_states, this.map_types, this.maps, this.match_id, this.match_state, this.players, this.seen_players, this.teams});

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
