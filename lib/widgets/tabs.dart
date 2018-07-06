import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owl_live_stats/views/tabs/live.dart';
import 'package:owl_live_stats/views/tabs/teams.dart';
import 'package:owl_live_stats/views/tabs/schedule.dart';

class Tabs {
  Tabs();

  at(int index) {
    return TABS[index];
  }

  var TABS = {
    0: new CupertinoTabView(
            builder: (BuildContext context) {
              return new LiveTabWidget();
            },
          ),
    1: new CupertinoTabView(
            builder: (BuildContext context) {
              return new TeamsTabWidget();
            },
          ),
    2: new CupertinoTabView(
            builder: (BuildContext context) {
              return new ScheduleTabWidget();
            },
          ),
//    3: new CupertinoTabView(
//            builder: (BuildContext context) {
//              return new ScheduleTabWidget(this.globalContext);
//            },
//          ),
  };
}
