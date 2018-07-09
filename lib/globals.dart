library owl_live_stats.globals;

import 'package:flutter/material.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'package:owl_live_stats/models/schedule.dart';

var globalContext;
var orangeColor = Color.fromARGB(210, 240, 150, 60);
var environment = 'stage';
var channelId = "23161357";
var appId = "hz584ynr8wyug0tnajrps6d48hy0qk";
var authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhbGxvd2VkX3N0YWdlIjoic2FuZGJveCIsImFwcF9pZCI6Imh6NTg0eW5yOHd5dWcwdG5hanJwczZkNDhoeTBxayIsImNoYW5uZWxfaWQiOiIyMzE2MTM1NyIsImV4cCI6MTUzMzEyNTM5Mywib3BhcXVlX3VzZXJfaWQiOiJBejg5MGVmN3FudmVxLTIzNTZoIiwicHVic3ViX3Blcm1zIjp7InNlbmQiOlsiKiJdfSwicm9sZSI6IiIsInVzZXJfaWQiOiIifQ.vjDyJKQyZH0AWvl21DxSMi061JakQ5GEbwtIB0yfxIc";
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
  var environment = 'stage';
  var authToken = '';
  static final Singleton _singleton = new Singleton._internal();
  CurrentMatch currentMatch;
  Teams teams;
  Players players;
  Schedule schedule;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
