import 'dart:async';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/models/teams.dart';
import 'package:owl_live_stats/models/players.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:http/http.dart' as http;
import 'package:owl_live_stats/data/net.dart';
import 'package:owl_live_stats/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class LiveTabWidget extends StatefulWidget
{
  State<StatefulWidget> createState() => new LiveTabState();
}

class LiveTabState extends State<LiveTabWidget> {
  var network = new Net(environment);
  var singleton = Singleton();
  Match currentMatch;
  Map<String, dynamic> teams;
  Map<String, dynamic> players;
  BuildContext context;

  getData() {
//    currentMatch = Match.fromJson(json.decode(Singleton().currentMatch));
    currentMatch = singleton.currentMatch;
    teams = singleton.teams.teams;
    players = singleton.players.players;
  }

  fetchMatch() async {
    await network.match();
  }

  fetchTeams(Map<String, String> params) async {
    await network.teams(params);
  }

  fetchPlayers(Map<String, String> params) async {
    await network.players(params);
  }

  playersIdsAsString() {
    return singleton.currentMatch.seen_players.reduce((p, e) =>
          p..addAll(e)
        ).join(',');
  }

  process() async {
    await fetchMatch();
    await fetchTeams({'foo': 'bar'});
    await fetchPlayers({'id': playersIdsAsString()});
    getData();
  }

  void initState() {
    super.initState();
    const oneSec = const Duration(seconds:5);
    new Timer.periodic(oneSec, (Timer t) => setState(() {
      fetchMatch();
    }));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var _asyncLoader = new AsyncLoader(
      initState: () async => await process(),
      renderLoad: () => _displayLoader(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => _displayElements(),
    );
    return _asyncLoader;
  }

  _displayLoader() {
    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.white,
        ),
        new Center(
          child: new Container(
            constraints: new BoxConstraints.expand(
              height: 80.0,
              width: 80.0,
            ),
            child: new CircularProgressIndicator(
              strokeWidth: 7.0,
            ),
          ),
        ),
      ]
    );
  }

  _displayElements() {
    if (currentMatch.id != "" && currentMatch.id != null) {
      return new CupertinoPageScaffold(
        navigationBar: new CupertinoNavigationBar(
          middle: new Text("Current Match"),
          backgroundColor: Colors.white
        ),
        child: new ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            _globalScore(),
            _currentScore(),
            _teamsRow(),
            _gamesBar(),
            _gamesList(),
            _lineupsBar(),
            _lineupsList(),
          ]
        ),
      );
    };
    return _displayNoMatch();
  }

  _displayNoMatch() {
    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.white,
        ),
        new Center(
          child: new Container(
            constraints: new BoxConstraints.expand(
              height: 50.0,
              width: 240.0,
            ),
            child: new Text(
                "No current match",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.grey
                ),
              ),
            ),
          ),
        ]
      );
  }

  _globalScore() {
    return new Container(
      child: new Align(
        alignment: Alignment(0.0, -1.0),
        child: new Container(
          padding: new EdgeInsets.only(
            top: 2.0,
            left: 11.0,
            right: 11.0
          ),
          decoration: new BoxDecoration(
            color: Colors.black,
            border: Border.all(width: 0.6, color: Colors.grey),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6.0),
              bottomRight: Radius.circular(6.0)
            ),
          ),
          child: new Text(
            _calculateGlobalScore(),
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  _calculateGlobalScore() {
    var score = [0,0];
    currentMatch.maps.forEach((el) {
      el[0] > el[1] ? score[0] += 1 : score[1] += 1;
    });
    return score.join("-"); 
  }

  _currentScore() {
    return new Container(
      child: new Align(
        alignment: Alignment(0.0, -1.0),
        child: new Container(
          margin: new EdgeInsets.only(
            top: 5.0,
          ),
          padding: new EdgeInsets.only(
            top: 2.0,
            left: 11.0,
            right: 11.0,
            bottom: 3.0
          ),
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.6, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: new Text(
            _calculateCurrentScore(),
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }

  _calculateCurrentScore() {
    return currentMatch.maps.last.join("-");
  }

  _teamsRow() {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border(
                right: new BorderSide(width: 0.3, color: Colors.grey),
                bottom: new BorderSide(width: 0.6, color: Colors.grey)
              ),
            ),
            child: new Align(
              alignment: Alignment(0.0, -1.0),
              heightFactor: 1.1,
              child: new Column(
                children: <Widget>[
                  new Image.asset(_getTeamsLogos()['first'], height: 150.0, fit: BoxFit.scaleDown ),
                  new Text(
                    _getTeamsNames()['first'],
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Alte"
                    ),
                  )
                ]
              )
            ),
          ),
        ),
        new Expanded(
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border(
                left: new BorderSide(width: 0.3, color: Colors.grey),
                bottom: new BorderSide(width: 0.6, color: Colors.grey)
              ),
            ),
            child: new Align(
              alignment: Alignment(0.0, -1.0),
              heightFactor: 1.1,
              child: new Column(
                children: <Widget>[
                  new Image.asset(_getTeamsLogos()['last'], height: 150.0, fit: BoxFit.scaleDown ),
                  new Text(
                    _getTeamsNames()['last'],
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Alte"
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getTeamsNames() {
    return {
      'first': teams[currentMatch.teams.first.toString()]['name'].toString(),
      'last': teams[currentMatch.teams.last.toString()]['name'].toString(),
    };
  }

  _getTeamsLogos() {
    return {
      'first': 'images/team-' + currentMatch.teams.first.toString() + '-logo.png',
      'last': 'images/team-' + currentMatch.teams.last.toString() + '-logo.png',
    };
  }

  _gamesBar() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: Colors.black,
      child: new Center(
        child: new Text(
          "Games",
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ),
    );
  }

  _gamesList() {
    return new Container(
      child: new Column(
        children: _gameListItems(), 
      ),
    );
  }

  _gameListItems() {
    List<Widget> items = [];
    var index = 1;
    currentMatch.maps.forEach((map) {
      var element = new Column(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: new BorderSide(width: 0.6, color: Colors.grey)
              ),
            ),
            constraints: new BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.3,
            ),
            child: new Center(
              child: new Text(
                "Game " + index.toString(),
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: "Alte"
                ),
              ),
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              border: Border(
                bottom: new BorderSide(width: 1.6, color: Colors.grey)
              ),
            ),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Center(
                    child: new Text(
                      map.first.toString(),
                      style: new TextStyle(
                        fontSize: 50.0,
                        color: Colors.black,
                        fontFamily: "Alte"
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  child: new Center(
                    child: new Image.asset("images/map_type_" + currentMatch.map_types[index-1] + ".png", width: 40.0)
                  ),
                ),
                new Expanded(
                  child: new Center(
                    child: new Text(
                      map.last.toString(),
                      style: new TextStyle(
                        fontSize: 60.0,
                        color: Colors.black,
                        fontFamily: "Alte"
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Colors.grey,
              border: Border(
                bottom: new BorderSide(width: 0.6, color: Colors.grey)
              ),
            ),
            constraints: new BoxConstraints.expand(
              height: 15.0,
            ),
          ),
        ],
      );
      items.add(element);
      index += 1;
    });
    return items;
  }

  _lineupsBar() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: Colors.black,
      child: new Center(
        child: new Text(
          "Lineups",
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ),
    );
  }

  _lineupsList() {
    return new Column(
      children: _lineupsListItems(),
    );
  }

  _lineupsListItems() {
    List<Widget> items = [];
    for (var index = 0; index <= 5; index++) {
      var playerIdsPair = [currentMatch.seen_players.first[index], currentMatch.seen_players.last[index]];
      var element = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            child: new Row(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                    left: 12.0
                  ),
                  child: new Image.network(_getLineupPlayers(playerIdsPair.first)["headshot"], width: 50.0)
                ),
                new Container(
                  padding: EdgeInsets.only(
                    right: 10.0,
                    left: 10.0
                  ),
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        constraints: new BoxConstraints.expand(
                          height: 25.0,
                          width: 25.0,
                        ),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      new Center(
                        child: new Image.network(
                          _getCurrentPlayerHero(playerIdsPair.first),
                          width: 25.0,
                          color: Colors.white,
                          colorBlendMode: BlendMode.exclusion,
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  child: new Text(
                    _getLineupPlayers(playerIdsPair.first)["gamertag"],
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontFamily: "Alte"
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new Text(
                    _getLineupPlayers(playerIdsPair.last)["gamertag"],
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontFamily: "Alte"
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(
                    right: 10.0,
                    left: 10.0
                  ),
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        constraints: new BoxConstraints.expand(
                          height: 25.0,
                          width: 25.0,
                        ),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      new Center(
                        child: new Image.network(
                          _getCurrentPlayerHero(playerIdsPair.last),
                          width: 25.0,
                          color: Colors.white,
                          colorBlendMode: BlendMode.exclusion,
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(
                    right: 12.0
                  ),
                  child: new Image.network(_getLineupPlayers(playerIdsPair.last)["headshot"], width: 50.0)
                ),
              ],
            ),
          ),
        ],
      );
      items.add(element);
    };
    return items;
  }

  _getCurrentPlayerHero(int id) {
    var hero = currentMatch.players[id.toString()]["hero"];
    return 'https://d1u1mce87gyfbn.cloudfront.net/hero/' + hero + '/icon-right-menu.png';
  }

  _getLineupPlayers(int id) {
    return players[id.toString()];
  }
}
