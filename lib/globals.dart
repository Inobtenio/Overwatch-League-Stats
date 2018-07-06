library owl_live_stats.globals;

import 'package:flutter/material.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'package:owl_live_stats/models/schedule.dart';

var globalContext;
var orangeColor = Color.fromARGB(210, 240, 150, 60);
var environment = 'stage';
const MAPS = {
  'blizzard-world': 'Blizzard World',
  'dorado': 'Dorado',
  'eichenwalde': 'Eichenwalde',
  'gibraltar': 'Gibraltar',
  'hanamura': 'Hanamura',
  'hollywoord': 'Hollywood',
  'horizon-lunar-colony': 'Horizon Lunar Colony',
  'ilios': 'Ilios',
  'junkertown': 'Junkertown',
  'kings-row': "King's row",
  'lijiang': 'Lijiang Tower',
  'nepal': 'Nepal',
  'numbani': 'Numbani',
  'oasis': 'Oasis',
  'rialto': 'Rialto',
  'route-66': 'Route 66',
  'temple-of-anubis': 'Temple of Anubis',
  'volskaya-industries': 'Volskaya Industries',
};

Color colorFromHex(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  CurrentMatch currentMatch;
  Teams teams;
  Players players;
  Schedule schedule;
  String authToken;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
