import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'package:owl_live_stats/models/schedule.dart';
import 'package:owl_live_stats/views/details/team.dart';
import 'package:owl_live_stats/views/details/player.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:http/http.dart' as http;
import 'package:owl_live_stats/data/net.dart';
import 'package:owl_live_stats/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class TeamsTabWidget extends StatefulWidget
{
  BuildContext globalContext;
  TeamsTabWidget(BuildContext context) {
    this.globalContext = context;
  }
  State<StatefulWidget> createState() => new TeamsTabState(this.globalContext);
}

class TeamsTabState extends State<TeamsTabWidget> {

  BuildContext globalContext;

  TeamsTabState(BuildContext context) {
    this.globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new TeamsListWidget(this.globalContext),
    );
  }
}

class TeamsListWidget extends StatefulWidget
{
  BuildContext globalContext;
  TeamsListWidget(BuildContext context) {
    this.globalContext = context;
  }
  State<StatefulWidget> createState() => new TeamsListState(this.globalContext);
}

class TeamsListState extends State<TeamsListWidget> {

  var network = new Net(environment);
  var singleton = Singleton();
  Map<String, dynamic> teams = this.singleton.teams.teams;
  BuildContext globalContext;

  TeamsListState(BuildContext context) {
    this.globalContext = context;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _displayElements();
  }

  _displayElements() {
    return new CupertinoPageScaffold(
      navigationBar: new CupertinoNavigationBar(
        middle: new Text("Teams"),
        backgroundColor: Colors.white
      ),
      child: new ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
  //        _teamsBar(),
          _teamsList(),
        ]
      ),
    );
  }

  _teamsList() {
    return new Container(
      child: new Column(
        children: _teamsListItems(),
      ),
    );
  }

  _teamsListItems() {
    var teams = _sortTeamsByPlacement();
    List<Widget> items = [];
    int index = 1;
    teams.forEach((team) {
      var element = new Column(
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              Navigator.of(this.globalContext).push(
                new CupertinoPageRoute<void>(
                  builder: (BuildContext context) {
                    return new CupertinoPageScaffold(
                      navigationBar: new CupertinoNavigationBar(
                        middle: new Text(
                          'Team',
                          style: new TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 22.0,
                            color: Colors.white,
                            fontFamily: "Alte"
                          ),
                        ),
                        backgroundColor: colorFromHex(team['color']),
                        actionsForegroundColor: orangeColor,
                      ),
                      child: new Material(
                        type: MaterialType.transparency,
                        child: new TeamDetailWidget(team, this.globalContext)
                      ),
                    );
                  },
                ),
              );
            },
            child: new Container(
              height: 80.0,
              color: colorFromHex(team['color']),
              child: new Row(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Image.asset('images/team-' + team['id'].toString() + '-logo-small.png', width: 50.0),
                  ),
                  new Expanded(
                    child: new Text(
                      team["name"],
                      style: new TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                        fontFamily: "Alte"
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _teamsListItemSeparator(index),
        ],
      );
      items.add(element);
      index += 1;
    });
    return items;
  }

  _sortTeamsByPlacement() {
    List<dynamic> list = teams.values.toList();
    list.sort((a, b) => a['stats']['placement'].compareTo(b['stats']['placement']));
    return list;
  }

  _teamsListItemSeparator(int index) {
    if (index != teams.length) {
      return new Container(
        decoration: new BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: new BorderSide(width: 0.6, color: Colors.grey)
          ),
        ),
        constraints: new BoxConstraints.expand(
          height: 0.0,
        ),
      );
    };
    return new Container();
  }
}
