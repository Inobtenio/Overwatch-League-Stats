import 'package:intl/intl.dart';
import 'package:owl_live_stats/views/details/team.dart';
import 'package:flutter/material.dart';
import 'package:owl_live_stats/data/net.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class ScheduleTabWidget extends StatefulWidget
{
  ScheduleTabWidget();
  State<StatefulWidget> createState() => new ScheduleTabState();
}

class ScheduleTabState extends State<ScheduleTabWidget> {

  ScheduleTabState();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new MatchesListWidget(),
    );
  }
}

class MatchesListWidget extends StatefulWidget
{
  MatchesListWidget();
  State<StatefulWidget> createState() => new MatchesListState();
}

class MatchesListState extends State<MatchesListWidget> {

  var network = new Net(environment);
  static final singleton = Singleton();
  Map<String, dynamic> teams = singleton.teams.teams;
  List<Map<String, dynamic>> schedule = singleton.schedule.matches;

  MatchesListState();

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
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(globalContext).push(
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
                                  backgroundColor: colorFromHex(contendants.first['color']),
                                  actionsForegroundColor: orangeColor,
                                ),
                                child: new Material(
                                  type: MaterialType.transparency,
                                  child: new TeamDetailWidget(contendants.first, globalContext)
                                ),
                              );
                            },
                          ),
                        );
                      },
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
                                '[' + match['teams'].first['wins'].toString() + ' - ' + match['teams'].first['losses'].toString() + ']',
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
                  ),
                  new Expanded(
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(globalContext).push(
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
                                  backgroundColor: colorFromHex(contendants.last['color']),
                                  actionsForegroundColor: orangeColor,
                                ),
                                child: new Material(
                                  type: MaterialType.transparency,
                                  child: new TeamDetailWidget(contendants.last, globalContext)
                                ),
                              );
                            },
                          ),
                        );
                      },
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
                                '[' + match['teams'].last['wins'].toString() + ' - ' + match['teams'].last['losses'].toString() + ']',
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
    Map<String, dynamic> map = {};
    var referenceDay = DateTime.fromMillisecondsSinceEpoch(list.first['startDate']).day;
    list.retainWhere((item) => DateTime.fromMillisecondsSinceEpoch(item['startDate']).day == referenceDay);
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

}
