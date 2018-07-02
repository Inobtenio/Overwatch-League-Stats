import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/views/tabs/live.dart';
var TABS = {
  0: new CupertinoTabView(
          builder: (BuildContext context) {
            return new LiveTabWidget();
          },
        ),
  1: new CupertinoTabView(
          builder: (BuildContext context) {
            return new CupertinoPageScaffold(
              navigationBar: new CupertinoNavigationBar(
                middle: new Text('Teams'),
              ),
              child:  new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        border: new Border.all(width: 10.0, color: Colors.orange),
                      ),
                      child: new Image.asset('images/team-4403-logo.png', width: 120.0, fit: BoxFit.scaleDown),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        border: new Border.all(width: 10.0, color: Colors.orange),
                      ),
                      child: new Image.asset('images/team-4403-logo.png', width: 120.0, fit: BoxFit.scaleDown),
                    ),
                  ),
                ],
              )  
            );
          },
        ),
  2: new CupertinoTabView(
          builder: (BuildContext context) {
            return new CupertinoPageScaffold(
              navigationBar: new CupertinoNavigationBar(
                middle: new Text('Schedule'),
              ),
              child:  new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        border: new Border.all(width: 10.0, color: Colors.red),
                      ),
                      child: new Image.asset('images/team-4403-logo.png', width: 120.0, fit: BoxFit.scaleDown),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        border: new Border.all(width: 10.0, color: Colors.red),
                      ),
                      child: new Image.asset('images/team-4403-logo.png', width: 120.0, fit: BoxFit.scaleDown),
                    ),
                  ),
                ],
              )  
            );
          },
        ),
  3: new CupertinoTabView(
          builder: (BuildContext context) {
            return new CupertinoPageScaffold(
              navigationBar: new CupertinoNavigationBar(
                middle: new Text('Settings'),
              ),
              child:  new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        border: new Border.all(width: 10.0, color: Colors.blue),
                      ),
                      child: new Image.asset('images/team-4403-logo.png', width: 120.0, fit: BoxFit.scaleDown),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        border: new Border.all(width: 10.0, color: Colors.blue),
                      ),
                      child: new Image.asset('images/team-4403-logo.png', width: 120.0, fit: BoxFit.scaleDown),
                    ),
                  ),
                ],
              )  
            );
          },
        )
};
