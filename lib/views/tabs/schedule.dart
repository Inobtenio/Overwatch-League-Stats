import 'dart:async';
import 'package:intl/intl.dart';
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

class ScheduleTabWidget extends StatefulWidget
{
  BuildContext globalContext;
  ScheduleTabWidget(BuildContext context) {
    this.globalContext = context;
  }
  State<StatefulWidget> createState() => new ScheduleTabState(this.globalContext);
}

class ScheduleTabState extends State<ScheduleTabWidget> {

  BuildContext globalContext;

  ScheduleTabState(BuildContext context) {
    this.globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new MatchesListWidget(this.globalContext),
    );
  }
}

class MatchesListWidget extends StatefulWidget
{
  BuildContext globalContext;
  MatchesListWidget(BuildContext context) {
    this.globalContext = context;
  }
  State<StatefulWidget> createState() => new MatchesListState(this.globalContext);
}

class MatchesListState extends State<MatchesListWidget> {

  var network = new Net(environment);
  var singleton = Singleton();
  Map<String, dynamic> teams = this.singleton.teams.teams;
  List<Map<String, dynamic>> schedule = this.singleton.schedule.matches;
  BuildContext globalContext;

  MatchesListState(BuildContext context) {
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
        middle: new Text(_getMatchesDate()),
        backgroundColor: Colors.white
      ),
      child: new ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
  //        _matchesBar(),
          _matchesList(),
        ]
      ),
    );
  }

  _matchesList() {
    return new Container(
      child: new Column(
        children: _matchesListItems(),
      ),
    );
  }

  _matchesListItems() {
    List<Widget> items = [];
    int index = 1;
    var matches = _sortMatchesByStartTime();
    matches.forEach((match) {
      var contendants = [teams[match['teams'].first['id'].toString()], teams[match['teams'].last['id'].toString()]];
      var element;
      if (contendants.first != null && contendants.last != null) {
        element = new Container(
          child: new Stack(
            alignment: Alignment(0.0, 0.0),
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: Container(
                      height: 200.0,
                      color: colorFromHex(contendants.first['color']),
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            height: 150.0,
                            width: 150.0,
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Image.asset('images/team-' + contendants.first['id'].toString() + '-logo-small.png', width: 120.0),
                          ),
                          new Expanded(
                            child: new Text(
                              match['teams'].first['wins'].toString() + ' - ' + match['teams'].first['losses'].toString(),
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
                  new Expanded(
                    child: Container(
                      height: 200.0,
                      color: colorFromHex(contendants.last['color']),
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            height: 150.0,
                            width: 150.0,
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Image.asset('images/team-' + contendants.last['id'].toString() + '-logo-small.png', width: 120.0),
                          ),
                          new Expanded(
                            child: new Text(
                              match['teams'].last['wins'].toString() + ' - ' + match['teams'].last['losses'].toString(),
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
                ],
              ),
              new Container(
                child: new Align(
                  alignment: Alignment(0.0, 1.2),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          _getMatchTime(match),
                          style: new TextStyle(
                            fontSize: 28.0,
                            color: Colors.white,
                            fontFamily: "Alte"
                          ),
                        )
                      ),
                      new Container(
                        child: new Image.asset(
                          'images/battle-icon.png',
                          width: 45.0,
                          color: Colors.transparent,
                          colorBlendMode: BlendMode.xor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        element = new Container();
      }
      items.add(element);
      index += 1;
    });
    if (items.length == 0) {
      return [new Center(
        child: Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("No matches scheduled")
        ),
      )];
    }
    return items;
  }

  _sortMatchesByStartTime() {
    List<dynamic> list = schedule.toList();
    list.sort((a, b) => _getMatchTime(a).compareTo(_getMatchTime(b)));
    return list;
  }

  _getMatchTime(Map<String, dynamic> match) {
    var hours = DateTime.fromMillisecondsSinceEpoch(match['startDate']).hour;
    var hoursString = hours < 10 ? "0" + hours.toString() : hours.toString();
    var minutes = DateTime.fromMillisecondsSinceEpoch(match['startDate']).minute;
    var minutesString = minutes == 0 ? "00" : minutes.toString();
    return "$hoursString:$minutesString";
  }

  _getMatchesDate() {
    if (schedule.length > 0) {
      var dateStr = new DateFormat("MMMMd", "en_US").format(DateTime.fromMillisecondsSinceEpoch(schedule.first['startDate']));
      var nowStr = new DateFormat("MMMMd", "en_US").format(DateTime.now());
      if (dateStr == nowStr) {
        return "Today";
      }
      return dateStr;
    }
    return "Schedule";
  }
//                children: <Widget>[
//                  new Container(
//                    padding: EdgeInsets.only(
//                      left: 20.0,
//                      right: 20.0,
//                    ),
//                    child: Image.asset('images/team-' + team['id'].toString() + '-logo-small.png', width: 50.0),
//                  ),
//                  new Expanded(
//                    child: new Text(
//                      team["name"],
//                      style: new TextStyle(
//                        fontSize: 28.0,
//                        color: Colors.white,
//                        fontFamily: "Alte"
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      );
}
