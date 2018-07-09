import 'package:owl_live_stats/values/strings.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'package:owl_live_stats/models/schedule.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:owl_live_stats/globals.dart';// as globals;

class Net {
  final singleton = Singleton();
  var data;
  var env;
  var jwt;
  
  Net(this.env) {}

//  getPrefencesAndStore(String key) async {
//    prefs = await SharedPreferences.getInstance();
//    prefs.setString(SETTINGS[env][key], data);
//  }

//  getData() async {
//    prefs = await SharedPreferences.getInstance();
//    var currentMatchString = prefs.getString(SETTINGS[env]['match_preferences_key']);
//    currentMatch = Match.fromJson(json.decode(currentMatchString));
//  }

  requestCall(String method, String url, Map<String, String> body, Map<String, String> headers) async {
    var bodyString = json.encode(body);
    if (body != {}) {
      if (method == 'get') {
        return http.get(url, headers: headers);
      }
      return http.post(url, body: bodyString, headers: headers);
    }
    if (method == 'get') {
      return http.get(url, headers: headers);
    }
    return http.post(url, body: bodyString, headers: headers);
  }

  formURL(String path, Map<String, String> params) {
    params['environment'] = singleton.environment;
    if (SETTINGS[env]['scheme'] == 'http') {
      return new Uri.http(SETTINGS[env]['host'], SETTINGS[env][path], params).toString();
    }
    return new Uri.https(SETTINGS[env]['host'], SETTINGS[env][path], params).toString();
  }

  authToken() async {
    Map<String, String> stringParams = {};
    stringParams['app_id'] = appId;
    stringParams['channel_id'] = channelId;
    try {
      final response = await request('auth_token_key', 'post', 'auth_url_path', {}, stringParams, {'Content-Type': 'application/json'});
      jwt = appId + " " + json.decode(response.body)['token']; 
    } catch (e) {
      return;
    }
  }

  environment() async {
    try {
      final response = await request('settings_preferences_key', 'get', 'settings_url_path', {}, {}, {});
      singleton.environment = json.decode(response.body)['environment'];
    } catch (e) {
      return singleton.environment = 'stage';
    }
  }

  schedule() async {
    try {
      final response = await request('schedule_preferences_key', 'get', 'schedule_url_path', {}, {}, {'Authorization': jwt});
      singleton.schedule = Schedule.fromJson(json.decode(response.body));
    } catch (e) {
      return singleton.schedule = Schedule.fromJson({'matches': []});
    }
  }

  match() async {
    try {
      final response = await request('match_preferences_key', 'get', 'match_url_path', {}, {}, {'Authorization': jwt});
      singleton.currentMatch = CurrentMatch.fromJson(json.decode(response.body));
    } catch (e) {
      return singleton.currentMatch = CurrentMatch.fromJson({'id': null});
    }
  }

  teams(Map<String, String> params) async {
    try {
      final response = await request('teams_preferences_key', 'get', 'teams_url_path', params, {}, {'Authorization': jwt});
      singleton.teams = Teams.fromJson(json.decode(response.body));
    } catch (e) {
      return singleton.teams = Teams.fromJson({'teams': {}});
    }
  }

  players(Map<String, String> params) async {
    try {
      final response = await request('players_preferences_key', 'get', 'players_url_path', params, {}, {'Authorization': jwt});
      singleton.players = Players.fromJson(json.decode(response.body));
    } catch (e) {
      return singleton.players = Players.fromJson({'players': {}});
    }
  }

  request(String key, String method, String path, Map<String, String> params,  Map<String, String> body, Map<String, String> headers) async {
    var url = formURL(path, params);
    return requestCall(method, url, body, headers);
//    await getPrefencesAndStore(key);
  }
}
