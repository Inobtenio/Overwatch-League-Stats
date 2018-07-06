import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/views/details/team.dart';
import 'package:owl_live_stats/views/details/player.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:owl_live_stats/data/net.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class LiveTabWidget extends StatefulWidget
{
  LiveTabWidget();
  State<StatefulWidget> createState() => new LiveTabState();
}

class LiveTabState extends State<LiveTabWidget> {

  var network = new Net(environment);
  var singleton = Singleton();
  List<Map<String, dynamic>> schedule;
  CurrentMatch currentMatch;
  Map<String, dynamic> teams;
  Map<String, dynamic> players;

  LiveTabState();

  getData() {
    schedule = singleton.schedule.matches;
    currentMatch = singleton.currentMatch;
    teams = singleton.teams.teams;
    players = singleton.players.players;
  }

  fetchSchedule() async {
    await network.schedule();
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
    await fetchSchedule();
    await fetchMatch();
    await fetchTeams({'foo': 'bar'});
    await fetchPlayers({'id': playersIdsAsString()});
    getData();
  }

  void initState() {
    super.initState();
    const oneSec = const Duration(seconds:20);
    new Timer.periodic(oneSec, (Timer t) => setState(() {
      fetchMatch();
    }));
  }

  @override
  Widget build(BuildContext context) {
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
          middle: new Text(_getMatch()['state'] == "PENDING" ? "Current Match" : "Last Match - Finished"),
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
    if (_getMatch()['state'] == "PENDING") {
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
    };
    return new Container();
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
              child: _teamLogoAndName('first'),
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
              child: _teamLogoAndName('last'),
            ),
          ),
        ),
      ],
    );
  }

  _teamLogoAndName(String place) {
    return new GestureDetector(
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
                  backgroundColor: colorFromHex(_getTeams()[place]['color']),
                  actionsForegroundColor: orangeColor,
                ),
                child: new Material(
                  type: MaterialType.transparency,
                  child: new TeamDetailWidget(_getTeams()[place], globalContext),
                ),
              );
            },
          ),
        );
      },
      child: new Column(
        children: <Widget>[
          new Image.asset(_getTeamsLogos()[place], height: 150.0, fit: BoxFit.scaleDown ),
          new Text(
            _getTeamsNames()[place],
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Alte"
            ),
          )
        ],
      )
    );
  }

  _getTeams() {
    return {
      'first': teams[currentMatch.teams.first.toString()],
      'last': teams[currentMatch.teams.last.toString()],
    };
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
              color: Color.fromARGB(255, 240, 150, 60),//Colors.white,
              border: Border(
                bottom: new BorderSide(width: 0.6, color: Colors.grey)
              ),
            ),
            constraints: new BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.3,
            ),
            child: new Center(
              child: new Text(
                _getGameTitle(index),
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: "Alte"
                ),
              ),
            ),
          ),
          new Container(
            constraints: new BoxConstraints.expand(
              height: 110.0,
            ),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                colorFilter: ColorFilter.mode(Color.fromARGB(255, 200, 200, 200), BlendMode.overlay),
                image: new ExactAssetImage('images/maps/' + _getGameMap(index)['map']  + '.jpg'),
                fit: BoxFit.cover,
              ),
//              border: Border(
//                bottom: new BorderSide(width: 1.6, color: Colors.grey)
//              ),
            ),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Center(
                    child: _stackedTextWithBackground(map.first.toString(), 60.0),
                  ),
                ),
                new Expanded(
//                  child: new Column(
//                    children: <Widget>[
                      child: new Container(
                        alignment: Alignment(0.0, 0.0),
                        child: new Image.asset("images/map_type_" + currentMatch.map_types[index-1] + ".png", width: 70.0)
                      ),
//                      new Container(
//                        padding: EdgeInsets.only(
//                          top: 2.0,
//                        ),
//                        child: new Text(
//                          _getGameMapName(index),
//                          style: new TextStyle(
//                            fontSize: 23.0,
//                            color: Colors.black,
//                            fontFamily: "Alte"
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
                ),
                new Expanded(
                  child: new Center(
                    child: _stackedTextWithBackground(map.last.toString(), 60.0),
                  ),
                ),
              ],
            ),
          ),
          _gameListItemSeparator(index),
        ],
      );
      items.add(element);
      index += 1;
    });
    return items;
  }

//  _getGameMapName(int index) {
//    return MAPS[_getGameMap(index)['map']];
//  }
//
  _getGameMap(int index) {
    var match = _getMatch(); 
    return match['games'][index-1];
  }

  _getMatch() {
    return schedule.singleWhere((match) {
      return match['id'] == currentMatch.match_id;
    });
  }

  _stackedTextWithBackground(String text, double size) {
    return new Stack(
      children: <Widget>[
        new Text(
          text,
          style: new TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontFamily: "Alte"
          ),
        ),
        new Text(
          text,
          style: new TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w100,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ],
    );
  }

  _getGameTitle(int index) {
    if (_getMatch()['state'] == "PENDING") {
      if (index != currentMatch.maps.length) {
        return "Game " + index.toString();
      };
      return "Current Game";
    };
    return "Game " + index.toString();
  }

  _gameListItemSeparator(int index) {
    if (index != currentMatch.maps.length) {
      return new Container(
        decoration: new BoxDecoration(
          color: Colors.black,//Color.fromARGB(200, 90, 90, 90),//Colors.white,
//          border: Border(
//            bottom: new BorderSide(width: 0.6, color: Colors.grey)
//          ),
        ),
        constraints: new BoxConstraints.expand(
          height: 3.0,
        ),
      );
    };
    return new Container();
  }

  _lineupsBar() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: Colors.black,
      child: new Center(
        child: new Text(
          _getMatch()['state'] == "PENDING" ? "Current Lineups" : "Last-seen Lineups",
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
    return new Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 7.0
      ),
      child: new Column(
        children: _lineupsListItems(),
      ),
    );
  }

  _lineupsListItems() {
    List<Widget> items = [];
    for (var index = 0; index <= 5; index++) {
      var playerIdsPair = [currentMatch.seen_players.first[index], currentMatch.seen_players.last[index]];
      var element = new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(globalContext).push(
                    new CupertinoPageRoute<void>(
                      builder: (BuildContext context) {
                        return new CupertinoPageScaffold(
                          navigationBar: new CupertinoNavigationBar(
                            middle: new Text(
                              'Player',
                              style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 22.0,
                                color: Colors.white,
                                fontFamily: "Alte"
                              ),
                            ),
                            backgroundColor: colorFromHex(_getTeams()['first']['color']),
                            actionsForegroundColor: orangeColor,
                          ),
                          child: new Material(
                            type: MaterialType.transparency,
                            child: new PlayerDetailWidget(_getLineupPlayers(playerIdsPair.first), globalContext),
                          ),
                        );
                      },
                    ),
                  );
                },
                child:new Container(
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                          left: 5.0
                        ),
                        child: new CachedNetworkImage(
                          imageUrl: _getLineupPlayers(playerIdsPair.first)["headshot"],
                          placeholder: new Icon(Icons.person, size: 50.0),
                          errorWidget: new Icon(Icons.person, size: 50.0),
                          width: 50.0
                        )
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                          top: 8.0,
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
                        padding: EdgeInsets.only(
                          top: 8.0
                        ),
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
              ),
              new GestureDetector(
                onTap: () {
                  Navigator.of(globalContext).push(
                    new CupertinoPageRoute<void>(
                      builder: (BuildContext context) {
                        return new CupertinoPageScaffold(
                          navigationBar: new CupertinoNavigationBar(
                            middle: new Text(
                              'Player',
                              style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 22.0,
                                color: Colors.white,
                                fontFamily: "Alte"
                              ),
                            ),
                            backgroundColor: colorFromHex(_getTeams()['last']['color']),
                            actionsForegroundColor: orangeColor,
                          ),
                          child: new Material(
                            type: MaterialType.transparency,
                            child: new PlayerDetailWidget(_getLineupPlayers(playerIdsPair.last), globalContext),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: new Container(
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                          top: 8.0
                        ),
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
                          top: 8.0,
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
                          right: 5.0
                        ),
                        child: new CachedNetworkImage(
                          imageUrl: _getLineupPlayers(playerIdsPair.last)["headshot"],
                          placeholder: new Icon(Icons.person, size: 50.0),
                          errorWidget: new Icon(Icons.person, size: 50.0),
                          width: 50.0
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _lineupsListItemSeparator(index),
        ],
      );
      items.add(element);
    };
    return items;
  }

  _lineupsListItemSeparator(int index) {
    if (index != 5) {
      return new Container(
        margin: EdgeInsets.only(
          top: 7.0,
        ),
        decoration: new BoxDecoration(
          color: Color.fromARGB(200, 90, 90, 90),//Colors.white,
          border: Border(
            bottom: new BorderSide(width: 0.6, color: Colors.grey)
          ),
        ),
        constraints: new BoxConstraints.expand(
          height: 0.1,
        ),
      );
    };
    return new Container();
  }

  _getCurrentPlayerHero(int id) {
    var hero = currentMatch.players[id.toString()]["hero"];
    return 'https://d1u1mce87gyfbn.cloudfront.net/hero/' + hero + '/icon-right-menu.png';
  }

  _getLineupPlayers(int id) {
    return players[id.toString()];
  }
}
