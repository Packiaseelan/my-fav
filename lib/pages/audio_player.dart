import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_fav/pages/image_details.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

import 'package:my_fav/models/data.dart';
import 'package:my_fav/scope-models/main.dart';
import 'package:my_fav/utils/enumerations.dart';

class AudioPlayer extends StatefulWidget {
  final int index;
  AudioPlayer(this.index);
  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  List<DataModel> audioList;

  Duration _duration = new Duration();
  Duration _position = new Duration();
  audio.AudioPlayer advancedPlayer;
  bool isPlaying;

  PlayerState playerState = PlayerState.stopped;

  get durationText => _duration != null
      ? _duration.toString().split('.').first.substring(2, 7)
      : '';

  get positionText => _position != null
      ? _position.toString().split('.').first.substring(2, 7)
      : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  void initAudioPlayer() {
    advancedPlayer = new audio.AudioPlayer();
    _positionSubscription = advancedPlayer.onAudioPositionChanged
        .listen((p) => setState(() => _position = p));
    _audioPlayerStateSubscription =
        advancedPlayer.onPlayerStateChanged.listen((s) {
      if (s == audio.AudioPlayerState.PLAYING) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        _duration = new Duration(seconds: 0);
        _position = new Duration(seconds: 0);
      });
    });

    advancedPlayer.onAudioPositionChanged.listen((d) {
      setState(() {
        _position = d;
      });
    });
    advancedPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    isPlaying = false;
  }

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    advancedPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<DataModel> audioList = model.audioList;
      return WillPopScope(
        onWillPop: () {
          advancedPlayer.stop();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(audioList[widget.index].name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageDetailsPage(
                        audioList[widget.index], false, FileTypes.Audio);
                  }));
                },
              ),
            ],
          ),
          body: _buildBody(audioList[widget.index]),
        ),
      );
    });
  }

  void seekToSecond(int second) {
    advancedPlayer.seek(Duration(seconds: second));
  }

  Widget _buildBody(DataModel model) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/bg.jpg',
          height: height,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: width * .2 / 2,
          right: width * .2 / 2,
          child: Container(
            width: width * 0.8,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(60)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  model.alias ?? model.name,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: width * .4,
          right: width * 0.3,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(120)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height - 260,
          child: Container(
            height: 160,
            width: width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Slider(
                          value: _position.inSeconds.toDouble(),
                          min: 0.0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              seekToSecond(value.toInt());
                              value = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text(
                                _position
                                    .toString()
                                    .split('.')
                                    .first
                                    .substring(2, 7),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 15,
                              ),
                              child: Text(
                                _duration
                                    .toString()
                                    .split('.')
                                    .first
                                    .substring(2, 7),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Theme.of(context).primaryColorLight,
                  splashColor: Theme.of(context).primaryColorLight,
                  highlightColor:
                      Theme.of(context).primaryColorLight.withOpacity(0.5),
                  elevation: 10.0,
                  highlightElevation: 5.0,
                  onPressed: () {
                    if (isPlaying) {
                      advancedPlayer.pause();
                    } else {
                      advancedPlayer.play(model.path, isLocal: true);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).primaryColorDark,
                      size: 55.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
