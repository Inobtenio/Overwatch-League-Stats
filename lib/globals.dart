library owl_live_stats.globals;

import 'dart:async';
import 'package:owl_live_stats/values/strings.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'package:shared_preferences/shared_preferences.dart';

var environment = 'development';
class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  Match currentMatch;
  Teams teams;
  Players players;
  String authToken;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
