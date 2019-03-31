import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';

import 'package:my_fav/data/dbhelper.dart';
import 'package:my_fav/models/data.dart';
import 'package:my_fav/utils/enumerations.dart';

class AudioPlayer extends StatefulWidget {
  final int index;
  AudioPlayer(this.index);
  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  DBHelper _helper = DBHelper();
  List<DataModel> audioList;
  @override
  Widget build(BuildContext context) {
    if (audioList == null) {
      audioList = List<DataModel>();
      _updateList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('audioList[widget.index].name'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return ImageDetailsPage(selectedImage, false);
              // }));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xEEEF1483).withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: _buildRadioSeekBar(),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                          child: ClipOval(
                        clipper: MClipper(),
                        child: Icon(Icons.music_note),
                      )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRadioSeekBar() {
    double _thumbPercent = 0.4;

    return RadialSeekBar(
      trackColor: Colors.red.withOpacity(0.5),
      trackWidth: 2.0,
      progressColor: Color(0xEEEF1483),
      progressWidth: 5.0,
      thumbPercent: _thumbPercent,
      thumb: CircleThumb(
        color: Color(0xEEEF1483),
        diameter: 20.0,
      ),
      progress: _thumbPercent,
      onDragUpdate: (double percent) {
        setState(() {
          _thumbPercent = percent;
        });
      },
    );
  }

  void _updateList() {
    if (audioList == null) {
      audioList = List<DataModel>();
    }
    var list = _helper.getDataList(FileTypes.Audio);

    list.then((dataList) {
      setState(() async {
        audioList = dataList;
      });
    });
  }
}

class MClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
