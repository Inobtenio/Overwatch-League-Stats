import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:owl_live_stats/homeScreen.dart';

const env = "development"; //// Change to 'prduction' before deployment

void main() async {
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
