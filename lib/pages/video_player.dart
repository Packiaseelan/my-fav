import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_fav/pages/image_details.dart';
import 'package:my_fav/utils/enumerations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:chewie/chewie.dart';

import 'package:my_fav/models/data.dart';
import 'package:my_fav/scope-models/main.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final int index;
  VideoPlayer(this.index);
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  void initPlayer(DataModel data) {
    _videoPlayerController1 = VideoPlayerController.file(File(data.path));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    // _videoPlayerController1.dispose();
    // _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<DataModel> videoList = model.videoList;
      initPlayer(videoList[widget.index]);
      return WillPopScope(
        onWillPop: () {
          _videoPlayerController1.pause();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(videoList[widget.index].name),
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
                        videoList[widget.index], false, FileTypes.Video);
                  }));
                },
              ),
            ],
          ),
          body: _buildBody(videoList[widget.index]),
        ),
      );
    });
  }

  Widget _buildBody(DataModel model) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
        ),
      ],
    );
  }
}
