import 'package:flutter/material.dart';
import 'package:my_fav/pages/dashboard.dart';
// import 'package:flutter/services.dart';
import 'package:my_fav/scope-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/home.dart';

//show debugDefaultTargetPlatformOverride;

void main() {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
    runApp(MyApp());
  // });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainModel mainModel = MainModel();
    mainModel.init();
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Favourite',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.blueGrey,
        ),
        routes: {
          '/': (BuildContext context) => DashboardPage(),
        },
      ),
    );
  }
}
