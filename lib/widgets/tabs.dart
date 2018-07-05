import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/views/tabs/live.dart';
import 'package:owl_live_stats/views/tabs/teams.dart';
import 'package:owl_live_stats/views/tabs/schedule.dart';

class Tabs {
  BuildContext globalContext;

  Tabs(BuildContext context) {
    this.globalContext = context;
  }

  at(int index) {
    return TABS[index];
  }

  var TABS = {
    0: new CupertinoTabView(
            builder: (BuildContext context) {
              return new LiveTabWidget(this.globalContext);
            },
          ),
    1: new CupertinoTabView(
            builder: (BuildContext context) {
              return new TeamsTabWidget(this.globalContext);
            },
          ),
    2: new CupertinoTabView(
            builder: (BuildContext context) {
              return new ScheduleTabWidget(this.globalContext);
            },
          ),
//    3: new CupertinoTabView(
//            builder: (BuildContext context) {
//              return new ScheduleTabWidget(this.globalContext);
//            },
//          ),
  };
}
