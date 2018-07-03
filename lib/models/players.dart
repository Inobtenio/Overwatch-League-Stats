import 'package:json_annotation/json_annotation.dart';
part 'players.g.dart';

@JsonSerializable()
class Players extends Object with _$PlayersSerializerMixin {
  final Map<String, dynamic> players;

  Players({this.players});

  factory Players.fromJson(Map<String, dynamic> json) => _$PlayersFromJson(json);
}
