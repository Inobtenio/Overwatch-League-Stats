import 'dart:async';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:owl_live_stats/homeScreen.dart';
import 'package:owl_live_stats/models/match.dart';
import 'package:owl_live_stats/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const env = "development"; //// Change to 'prduction' before deployment

void main() async {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      theme: new ThemeData(
        accentColor: Color.fromARGB(255, 240, 150, 60),
      ),
      home: new HomeScreen(),
    );
  }
}
