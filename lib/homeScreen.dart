import 'package:owl_live_stats/globals.dart';// as globals;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:owl_live_stats/values/strings.dart';
import 'package:owl_live_stats/widgets/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

const env = "development"; //// Change to 'prduction' before deployment

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var responseJson;
  var prefs;
  var prefsExist;

  getPrefencesAndStore(String data) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(SETTINGS[env]['auth_token_key'], data);
    Singleton().authToken = data;
  }

  fetchToken() async {
    final response = await http.get(SETTINGS[env]['host']+SETTINGS[env]['match_url_path']);
    responseJson = response.body; 
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(SETTINGS[env]['home_screen_path']);
  }

  process() async {
    await fetchToken();
    await getPrefencesAndStore(responseJson);
  }

  @override
  void initState() {
    //process();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return new CupertinoTabScaffold(
      tabBar: new CupertinoTabBar(
        activeColor: Color.fromARGB(255, 240, 150, 60),
        items: <BottomNavigationBarItem> [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.wifi_tethering),
              title: new Text("Live"),
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.people),
              title: new Text("Teams")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.today),
              title: new Text("Schedule")
          ),
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.settings),
//              title: new Text("Settings")
//          ),
        ],
        backgroundColor: Colors.white
      ),
      tabBuilder: (BuildContext context, int index) {
        return new Material(
          type: MaterialType.transparency,
          child: Tabs().at(index),
        );
      },
    );
  }
}
