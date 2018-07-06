import 'package:cached_network_image/cached_network_image.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/globals.dart';// as globals;

class PlayerDetailWidget extends StatefulWidget
{
  final Map<String, dynamic> player;
  final BuildContext globalContext;

  PlayerDetailWidget(this.player, this.globalContext);
  State<StatefulWidget> createState() => new PlayerDetailState(this.player, this.globalContext);
}

class PlayerDetailState extends State<PlayerDetailWidget> {
  final Map<String, dynamic> player;
  final BuildContext globalContext;
  static final singleton = Singleton();
  CurrentMatch currentMatch = singleton.currentMatch;
  List<Map<String, dynamic>> schedule = singleton.schedule.matches;
  Map<String, dynamic> teams = singleton.teams.teams;

  PlayerDetailState(this.player, this.globalContext);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          _playerQuickInfo(),
          new Expanded(
            child: _playerDetails(),
          ),
        ],
      ),
    );
  }

  _playerQuickInfo(){
    return new Container(
      padding: EdgeInsets.only(
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(width: 0.6, color: Colors.grey),
        ),
      ),
      child: new Container(
        decoration: new BoxDecoration(
          color: colorFromHex(teams[player['team_id'].toString()]['color']),
        ),
        child: new Row(
          children: <Widget>[
            new Flexible(
              flex: 1,
              child: new CachedNetworkImage(
                imageUrl: player["headshot"],
                placeholder: new Icon(Icons.person, size: 200.0),
                errorWidget: new Icon(Icons.person, size: 200.0),
                width: 200.0
              ),
            ),
            new Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(right: 6.0),
                child: new Align(
                  alignment: Alignment(-0.8, -0.5),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 6.0),
                        child: new Image.asset('images/team-' + player['team_id'].toString() + '-logo-small.png', width: 50.0),
                      ),
                      new Text(
                        player['name'].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w100,
                          fontSize: 15.0,
                          color: Colors.white,
                          fontFamily: "Alte"
                        ),
                      ),
                      new FittedBox(
                        child: new Text(
                          player['gamertag'].toUpperCase(),
                          style: new TextStyle(
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: Colors.white,
                            fontFamily: "Alte"
                          ),
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 7.0,),
                        child: new Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.only(top: 3.0),
                                    color: Colors.grey,
                                    height: 40.0,
                                    width: 40.0,
                                    child: new Text(
                                      player['player_number'].toString(),
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white,
                                        fontFamily: "Alte"
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.all(5.0),
                                    color: Colors.white,
                                    height: 40.0,
                                    width: 40.0,
                                    child: new Container(
                                      child: new Image.asset('images/roles/' + player['role']  + '.png', width: 20.0),
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _playerDetails() {
    return new ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        _playerInfoBar(),
        _playerInfoList(),
        _playerCurrentStatsBar(),
        _playerCurrentStats(),
      ]
    );
  }

  _playerInfoBar() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: colorFromHex(teams[player['team_id'].toString()]['color']),//Colors.black,
      child: new Center(
        child: new Text(
          "Info",
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ),
    );
  }

  _playerCurrentStatsBar() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.3,
      ),
      color: colorFromHex(teams[player['team_id'].toString()]['color']),//Colors.black,
      child: new Center(
        child: new Text(
          "Current in-game stats",
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Alte"
          ),
        ),
      ),
    );
  }

  _playerCurrentStats() {
    if (currentMatch.seen_players.reduce((p, e) => p..addAll(e)).indexOf(player['id']) != -1 ) {
      return new Container(
        padding: EdgeInsets.only(
          right: 10.0,
          left: 10.0,
        ),
        child: new Column(
          children: <Widget>[
            _playerCurrentStatsListItem('Best kill streak', 'best_kill_streak'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Deaths', 'deaths'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Defensive assists', 'defensive_assists'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Eliminations', 'eliminations'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Final blows', 'final_blows'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Healing done', 'healing_done'),
            _playerInfoListItemSeparator(),
            _playerSpecialListItemFor('Hero', [currentMatch.players[player['id'].toString()]['hero']]),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Hero damage done', 'hero_damage_done'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Objective kills', 'objective_kills'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Offensive assists', 'offensive_assists'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Solo kills', 'solo_kills'),
            _playerInfoListItemSeparator(),
            _playerCurrentStatsListItem('Weapon accuracy', 'weapon_accuracy'),
          ],
        ),
      );
    }
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Text("This player is not currently in a game")
      ),
    );
  }

  _playerSpecialListItemFor(String name, List<dynamic> list) {
    List<Widget> items = [];
    List<Widget> outerItems = [];
    outerItems.add(
      new Container(
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 8.0,
        ),
        child: new Text(name, style: new TextStyle(fontSize: 18.0, color: Colors.grey, fontFamily: "Alte")),
      )
    );
    if (list != null) {
      list.forEach((item) {
        var rowElement = new Container(
          padding: EdgeInsets.only(
            top: 8.0,
            right: 10.0,
            left: 10.0
          ),
          child: new Stack(
            children: <Widget>[
              new Container(
                child: new Image.network(
                  _getHero(item),
                  width: 25.0,
                  color: Colors.white,
                  colorBlendMode: BlendMode.exclusion,
                ),
              ),
            ],
          ),
        );
        items.add(rowElement);
      });
    } else {
      items.add(new Text("-"));
    }
    outerItems.add(
      new Container(
        child: new Row(
          children: items,
        ),
      ),
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: outerItems,
    );
  }

  _getHero(String name) {
    return 'https://d1u1mce87gyfbn.cloudfront.net/hero/' + name + '/icon-right-menu.png';
  }

  _playerCurrentStatsListItem(String name, String key) {
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
          child: new Text(_playerCurrentStatsListItemFormatter(key), style: new TextStyle(fontSize: 18.0, color: Colors.grey, fontFamily: "Alte")),
        ),
      ],
    );
  }

  _playerCurrentStatsListItemFormatter(String key) {
    var numericValue = currentMatch.players[player['id'].toString()][key];
    if (numericValue.floor() == numericValue) {
      return numericValue.toString();
    } else if (numericValue >= 1.0) {
      return numericValue.truncate().toString();
    }
    return (numericValue * 100).truncate().toString() + '%';
  }

  _playerInfoList() {
    return new Container(
      padding: EdgeInsets.only(
        right: 10.0,
        left: 10.0,
      ),
      child: new Column(
        children: <Widget>[
          _playerInfoListItem('Hometown', 'hometown'),
          _playerInfoListItemSeparator(),
          _playerSpecialListItemFor('Heroes', player['heroes']),
          _playerInfoListItemSeparator(),
          _playerInfoListItem('Facebook', 'facebook'),
          _playerInfoListItemSeparator(),
          _playerInfoListItem('Twitch', 'twitch'),
          _playerInfoListItemSeparator(),
          _playerInfoListItem('Twitter', 'twitter'),
        ],
      ),
    );
  }

  _playerInfoListItem(String name, String key) {
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
          child: new Text(_playerInfoListItemFormatter(key), style: new TextStyle(fontSize: 18.0, color: Colors.grey, fontFamily: "Alte")),
        ),
      ],
    );
  }

  _playerInfoListItemFormatter(String key) {
    var value = player[key].toString().replaceAll(new RegExp(r'https://www.facebook.com'), 'fb')
      .replaceAll(new RegExp(r'https://www.twitch.tv'), 'twitch')
      .replaceAll(new RegExp(r'https://twitter.com'), 'twitter')
      .replaceAll(new RegExp(r'https://www.youtube.com'), 'yt');
    return value.isEmpty ? "-" : value;
  }

  _playerInfoListItemSeparator() {
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

}
