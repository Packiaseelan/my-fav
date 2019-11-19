import 'package:flutter/material.dart';
import 'package:my_fav/scope-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Size _size;
  MainModel _main;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      _main = model;
      return Scaffold(
        body: _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 25,
          left: 0,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black.withOpacity(0.5),
              size: 30,
            ),
            onPressed: () {},
          ),
        ),
        Column(
          children: <Widget>[
            _bg(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildTile(
                    Colors.red,
                    _tileBg(Icons.image, 'Image'),
                  ),
                  _buildTile(
                    Colors.red,
                    _tileBg(Icons.music_note, 'Audio'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildTile(
                    Colors.blue[300],
                    _tileBg(Icons.video_library, 'Video'),
                  ),
                  _buildTile(
                    Colors.teal,
                    _tileBg(Icons.attach_file, 'Document'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _buildTile(Color color, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.yellowAccent,
            offset: Offset(5.0, 5.0),
          )
        ],
      ),
      height: 200,
      width: _size.width * 0.41,
      child: child,
    );
  }

  Container _tileBg(IconData icon, String text) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Count',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  _getCount(text),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _bg() {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            size: 300,
            color: Color(0X11FF0000),
          ),
          Text(
            'Favourites',
            style: TextStyle(
              color: Color(0X11FF0000),
              fontSize: 110,
            ),
          )
        ],
      ),
    );
  }

  String _getCount(String type) {
    switch (type) {
      case 'Image':
        return _main.imageList.length.toString();
      case 'Audio':
        return _main.audioList.length.toString();
      case 'Video':
        return _main.videoList.length.toString();
      case 'Document':
        return _main.docList.length.toString();
      default:
        return '0';
    }
  }
}
