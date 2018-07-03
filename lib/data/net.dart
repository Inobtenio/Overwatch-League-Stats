import 'dart:async';
import 'package:owl_live_stats/values/strings.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:owl_live_stats/globals.dart';// as globals;

class Net {
  final singleton = Singleton();
  var data;
  var env;
  const authToken = "hz584ynr8wyug0tnajrps6d48hy0qk eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhbGxvd2VkX3N0YWdlIjoic2FuZGJveCIsImFwcF9pZCI6Imh6NTg0eW5yOHd5dWcwdG5hanJwczZkNDhoeTBxayIsImNoYW5uZWxfaWQiOiIyMzE2MTM1NyIsImV4cCI6MTUzMzEyNTM5Mywib3BhcXVlX3VzZXJfaWQiOiJBejg5MGVmN3FudmVxLTIzNTZoIiwicHVic3ViX3Blcm1zIjp7InNlbmQiOlsiKiJdfSwicm9sZSI6IiIsInVzZXJfaWQiOiIifQ.vjDyJKQyZH0AWvl21DxSMi061JakQ5GEbwtIB0yfxIc";
  
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
    if (body != {}) {
      if (method == 'get') {
        return http.get(url, headers: headers);
      }
      return http.post(url, body: body, headers: headers);
    }
    if (method == 'get') {
      return http.get(url, headers: headers);
    }
    return http.post(url, body: body, headers: headers);
  }

  formURL(String path, Map<String, String> params) {
    if (SETTINGS[env]['scheme'] == 'http') {
      return new Uri.http(SETTINGS[env]['host'], SETTINGS[env][path], params).toString();
    }
    return new Uri.https(SETTINGS[env]['host'], SETTINGS[env][path], params).toString();
  }

  match() async {
    final response = await request('match_preferences_key', 'get', 'match_url_path', {}, {}, {'Authorization': authToken});
    singleton.currentMatch = Match.fromJson(json.decode(response.body));
  }

  teams(Map<String, String> params) async {
    final response = await request('teams_preferences_key', 'get', 'teams_url_path', params, {}, {'Authorization': authToken});
    singleton.teams = Teams.fromJson(json.decode(response.body));
  }

  players(Map<String, String> params) async {
    final response = await request('players_preferences_key', 'get', 'players_url_path', params, {}, {'Authorization': authToken});
    singleton.players = Players.fromJson(json.decode(response.body));
  }

  request(String key, String method, String path, Map<String, String> params,  Map<String, String> body, Map<String, String> headers) async {
    var url = formURL(path, params);
    return requestCall(method, url, body, headers);
//    await getPrefencesAndStore(key);
  }
}
