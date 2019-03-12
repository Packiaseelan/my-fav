import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/home.dart';
import 'scoped-model/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        title: 'My Favourite',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, accentColor: Colors.blueGrey),
        //home: HomePage(),
        routes:{
          '/' : (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
