import 'package:cached_network_image/cached_network_image.dart';
import 'package:owl_live_stats/views/details/player.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:owl_live_stats/data/net.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class TeamDetailWidget extends StatefulWidget
{
  final Map<String, dynamic> team;
  final BuildContext globalContext;

  TeamDetailWidget(this.team, this.globalContext);
  State<StatefulWidget> createState() => new TeamDetailState(this.team, this.globalContext);
}

class TeamDetailState extends State<TeamDetailWidget> {
  Map<String, dynamic> team;
  BuildContext globalContext;

  TeamDetailState(Map<String, dynamic> team, BuildContext context) {
    this.team = team;
    this.globalContext = context;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
            decoration: new BoxDecoration(
              color: colorFromHex(team['color']),
              border: new Border(
                bottom: new BorderSide(width: 0.6, color: Colors.grey),
              ),
            ),
            child: new Align(
              alignment: new Alignment(0.0, -0.7),
              child: new Column(
                children: <Widget>[
                  new Image.asset('images/team-' + team['id'].toString() + '-logo-small.png', width: 120.0),
                  new Text(
                    team['name'],
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: "Alte"
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Expanded(
            child: new TeamPlayersWidget(this.team, this.globalContext),
          ),
        ],
      ),
    );
  }
}

class TeamPlayersWidget extends StatefulWidget
{
  final Map<String, dynamic> team;
  final BuildContext globalContext;

  TeamPlayersWidget(this.team, this.globalContext);
  State<StatefulWidget> createState() => new TeamPlayersState(this.team, this.globalContext);
}

class TeamPlayersState extends State<TeamPlayersWidget> {
  final BuildContext globalContext;
  var network = new Net('production');
  var singleton = Singleton();
  final Map<String, dynamic> team;
  Map<String, dynamic> players;

  TeamPlayersState(this.team, this.globalContext);

  fetchPlayers(Map<String, String> params) async {
    await network.players(params);
  }

  getData() {
      players = singleton.players.players;
  }

  playersIdsAsString() {
    return team['players'].join(',');
  }

  process() async {
    await fetchPlayers({'id': playersIdsAsString()});
    getData();
  }

  void initState() {
    super.initState();
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

  _displayElements() {
    return new ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        _playersBar(),
        _playersList(),
        _statsBar(),
        _statsList(),
      ]
    );
  }

  _playersBar() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: colorFromHex(team['color']),
      child: new Center(
        child: new Text(
          "Players",
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ),
    );
  }

  _playersList() {
    return new Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 7.0,
      ),
      child: new Column(
        children: _playersListItems(),
      ),
    );
  }

  _playersListItems() {
    List<Widget> items = [];
    int index = 1;
    players.forEach((player_id, player) {
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
                          'Player',
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
                        child: new PlayerDetailWidget(player, this.globalContext),
                      ),
                    );
                  },
                ),
              );
            },
            child: new Row(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 10.0,
                  ),
                  child: new CachedNetworkImage(
                    imageUrl: player["headshot"],
                    placeholder: new Icon(Icons.person, size: 50.0),
                    errorWidget: new Icon(Icons.person, size: 50.0),
                    width: 50.0
                  )
                ),
                new Expanded(
                  child: new Text(
                    player["gamertag"],
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontFamily: "Alte"
                    ),
                  ),
                ),
                new Container(
                  child: new Image.asset('images/roles/' + player['role']  + '.png', width: 20.0),
                ),
              ],
            ),
          ),
          _playersListItemSeparator(index),
        ],
      );
      items.add(element);
      index += 1;
    });
    return items;
  }

  _playersListItemSeparator(int index) {
    if (index != players.length) {
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
          height: 0.2,
        ),
      );
    };
    return new Container();
  }

  _statsBar(){
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: colorFromHex(team['color']),
      child: new Center(
        child: new Text(
          "Stats",
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ),
    );
  }

  _statsList() {
    return new Container(
      padding: EdgeInsets.only(
        right: 10.0,
        left: 10.0,
      ),
      child: new Column(
        children: <Widget>[
          _statsListItem('Game difference', 'diff'),
          _statsListItemSeparator(),
          _statsListItem('Matches won', 'matchWin'),
          _statsListItemSeparator(),
          _statsListItem('Matches lost', 'matchLoss'),
          _statsListItemSeparator(),
          _statsListItem('Placement', 'placement'),
        ],
      ),
    );
  }

  _statsListItem(String name, String key) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 8.0,
          ),
          child: new Text(name, style: new TextStyle(fontSize: 18.0, color: Colors.grey, fontFamily: "Alte")),
        ),
        new Container(
          padding: EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            right: 8.0,
          ),
          child: new Text(team['stats'][key].toString(), style: new TextStyle(fontSize: 18.0, color: Colors.grey, fontFamily: "Alte")),
        ),
      ],
    );
  }

  _statsListItemSeparator() {
    return new Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      decoration: new BoxDecoration(
        color: Color.fromARGB(200, 90, 90, 90),//Colors.white,
        border: Border(
          bottom: new BorderSide(width: 0.6, color: Colors.grey)
        ),
      ),
      constraints: new BoxConstraints.expand(
        height: 0.2,
      ),
    );
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
}
