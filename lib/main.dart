import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'pages/home.dart';

//show debugDefaultTargetPlatformOverride;

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'My Favourite',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, accentColor: Colors.blueGrey),
        //home: HomePage(),
        routes: {
          '/': (BuildContext context) => HomePage(),
        },
      );
  }
}
