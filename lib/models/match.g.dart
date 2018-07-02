// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => new Match(
    id: json['id'] as String,
    map_states: json['map_states'],
    map_types: json['map_types'],
    maps: json['maps'],
    match_id: json['match_id'],
    match_state: json['match_state'],
    players: json['players'],
    seen_players: json['seen_players'],
    teams: json['teams']);

abstract class _$MatchSerializerMixin {
  String get id;
  dynamic get map_states;
  dynamic get map_types;
  dynamic get maps;
  dynamic get match_id;
  dynamic get match_state;
  dynamic get players;
  dynamic get seen_players;
  dynamic get teams;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'map_states': map_states,
        'map_types': map_types,
        'maps': maps,
        'match_id': match_id,
        'match_state': match_state,
        'players': players,
        'seen_players': seen_players,
        'teams': teams
      };
}
