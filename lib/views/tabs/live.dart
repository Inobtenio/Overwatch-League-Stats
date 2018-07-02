import 'dart:async';
import 'package:owl_live_stats/models/match.dart';
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
  var singleton = Singleton();
  Match currentMatch;
  BuildContext context;

  getData() {
//    currentMatch = Match.fromJson(json.decode(Singleton().currentMatch));
    currentMatch = singleton.currentMatch;
  }

  fetchMatch() async {
    await new Net(environment).match();
  }

  process() async {
    await fetchMatch();
    getData();
  }

  void initState() {
    super.initState();
    const oneSec = const Duration(seconds:5);
    new Timer.periodic(oneSec, (Timer t) => setState(() {
      process();
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
            "2-1",
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
            "0-2",
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
                  new Image.asset('images/team-4403-logo.png', height: 150.0, fit: BoxFit.scaleDown ),
                  new Text(
                    "New York Excelsior",
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
                  new Image.asset('images/team-4402-logo.png', height: 150.0, fit: BoxFit.scaleDown ),
                  new Text(
                    "Boston Uprising",
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
        children: <Widget>[
          new Column(
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
                    "Game 1",
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
                          "3",
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
                        child: new Image.asset("images/map_type_assault.png", width: 40.0)
                      ),
                    ),
                    new Expanded(
                      child: new Center(
                        child: new Text(
                          "1",
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
          ),
        ], 
      ),
    );
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
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              child: new Row(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(
                      left: 12.0
                    ),
                    child: new Image.network("https://bnetcmsus-a.akamaihd.net/cms/page_media/9VI2CD4PUER91519254438519.png", width: 50.0)
                  ),
                  new Container(
                    child: new Text(
                      "Fissure",
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
                      "Sabyeolbe",
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                        fontFamily: "Alte"
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(
                      right: 12.0
                    ),
                    child: new Image.network("https://bnetcmsus-a.akamaihd.net/cms/page_media/BP0XDXDMWZ421512776701354.png", width: 50.0)
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
