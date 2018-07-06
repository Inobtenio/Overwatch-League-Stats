import 'package:owl_live_stats/views/details/team.dart';
import 'package:flutter/material.dart';
import 'package:owl_live_stats/data/net.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class TeamsTabWidget extends StatefulWidget
{
  TeamsTabWidget();
  State<StatefulWidget> createState() => new TeamsTabState();
}

class TeamsTabState extends State<TeamsTabWidget> {

  TeamsTabState();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new TeamsListWidget(),
    );
  }
}

class TeamsListWidget extends StatefulWidget
{
  TeamsListWidget();
  State<StatefulWidget> createState() => new TeamsListState();
}

class TeamsListState extends State<TeamsListWidget> {

  var network = new Net(environment);
  static final singleton = Singleton();
  Map<String, dynamic> teams = singleton.teams.teams;

  TeamsListState();

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
                        backgroundColor: colorFromHex(team['color']),
                        actionsForegroundColor: orangeColor,
                      ),
                      child: new Material(
                        type: MaterialType.transparency,
                        child: new TeamDetailWidget(team, globalContext)
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
