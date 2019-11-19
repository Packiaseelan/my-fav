import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_fav/components/alert.dart';
import 'package:open_file/open_file.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

import 'package:my_fav/scope-models/main.dart';
import 'package:my_fav/pages/video_player.dart';
import 'package:my_fav/models/data.dart';
import 'package:my_fav/pages/audio_player.dart';
import 'package:my_fav/pages/image_viewer.dart';
import 'package:my_fav/utils/enumerations.dart';
import 'package:my_fav/components/no_data.dart';

class ListPage extends StatefulWidget {
  final FileTypes types;
  ListPage(this.types);
  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with TickerProviderStateMixin {
  List<DataModel> dataList;
  int count = 0;

  int _angle = 90;
  bool _isRotated = true;

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;

  MainModel main;

  String _fileName = '...';
  String _path = '...';
  String _extension;
  FileType _pickingType;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.linear),
    );

    super.initState();
  }

  Widget _buildImageList(List<DataModel> model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              _onItemTapped(model[index], index);
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: ClipOval(
                    child: Container(
                      height: 55,
                      width: 55,
                      color: Theme.of(context).primaryColor,
                      child: _getAvatar(model[index].path),
                    ),
                  ), //
                  title: Text(_getName(model[index])),
                  subtitle:
                      Text(_calcSize(File(model[index].path).lengthSync())),
                  trailing: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {
                        _deleteDialog(context, dataList[index]);
                      }),
                ),
                Divider(),
              ],
            ));
      },
      itemCount: model.length,
    );
  }

  String _getName(DataModel model) {
    var text = model.alias;
    if (text != '' && text != null)
      return text;
    else
      return model.name;
  }

  void _onItemTapped(DataModel model, int index) {
    switch (widget.types) {
      case FileTypes.Image:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ImageViewer(index, widget.types);
          }),
        );
        break;
      case FileTypes.Audio:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return AudioPlayer(index);
          }),
        );
        break;
      case FileTypes.Video:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return VideoPlayer(index);
          }),
        );
        break;
      case FileTypes.Documents:
        OpenFile.open(model.path);
        break;
    }
  }

  void _openFileExplorer(List<DataModel> dataList) async {
    _pickingType = _getPickType(widget.types);

    try {
      _path = await FilePicker.getFilePath(
          type: _pickingType, fileExtension: _extension);
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
    });

    if (_path != null) {
      var map = Map<String, dynamic>();
      map['name'] = _fileName;
      map['path'] = _path;
      var data = DataModel.fromMap(map);
      main.insert(data, widget.types);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      main = model;
      dataList = main.getData(widget.types);
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: dataList.length > 0
                  ? _buildImageList(dataList)
                  : NoDataAvailable(widget.types),
            ),
            _buildFloatingButton(
              197.0,
              24.0,
              'Internet',
              Color(0xFF9E9E9E),
              () {
                if (_angle == 45.0) {
                  _rotate();
                }
              },
              Color(0xFFBF00A5),
              _animation2,
            ),
            _buildFloatingButton(
              144.0,
              24.0,
              'Camera',
              Color(0xFF9E9E9E),
              () {
                if (_angle == 45.0) {
                  _rotate();
                }
              },
              Color(0xFF00BFA5),
              _animation2,
            ),
            _buildFloatingButton(
              88.0,
              24.0,
              'Internal Storage',
              Color(0xFF9E9E9E),
              () {
                if (_angle == 45.0) {
                  _rotate();
                  _openFileExplorer(dataList);
                }
              },
              Color(0xFFE57373),
              _animation,
            ),
            _buildFloatingActionButton(),
          ],
        ),
      );
    });
  }

  void _deleteDialog(BuildContext context, DataModel data) {
    showDialog(
      context: context,
      builder: (context) {
        return BeautifulAlertDialog(
          title: 'Are you sure?',
          message:
              'Do you want to remove ${data.alias ?? data.name} from favourite?',
          acceptText: "Yes",
          discardText: "No",
          onAcceptPressed: () {
            main.delete(data, widget.types);
            Navigator.of(context).pop(true);
          },
          onDiscardPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.delete_outline,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  FileType _getPickType(FileTypes type) {
    switch (type) {
      case FileTypes.Image:
        return FileType.IMAGE;
      case FileTypes.Audio:
        _extension = 'mp3';
        return FileType.CUSTOM;
      case FileTypes.Video:
        return FileType.VIDEO;
      case FileTypes.Documents:
        _extension = 'pdf';
        return FileType.CUSTOM;
      default:
        return FileType.CUSTOM;
    }
  }

  Widget _getAvatar(String path) {
    switch (widget.types) {
      case FileTypes.Image:
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      case FileTypes.Audio:
        return Icon(Icons.audiotrack);
      case FileTypes.Video:
        return Icon(Icons.video_library);
      case FileTypes.Documents:
        return Icon(Icons.attachment);
      default:
        return Icon(Icons.favorite);
    }
  }

  String _calcSize(int size) {
    var res = size / 1024;
    if (res <= 1024) {
      return '${res.toStringAsFixed(2)} KB';
    }
    res = res / 1024;
    if (res <= 1024) {
      return '${res.toStringAsFixed(2)} MB';
    }
    res = res / 1024;
    if (res <= 1024) {
      return '${res.toStringAsFixed(2)} GB';
    } else {
      return '${res.toStringAsFixed(2)} TB';
    }
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: Material(
        color: Color(0xFFE57373),
        type: MaterialType.circle,
        elevation: 6.0,
        child: Container(
          width: 56.0,
          height: 56.00,
          child: InkWell(
            onTap: _rotate,
            child: Center(
                child: RotationTransition(
              turns: AlwaysStoppedAnimation(_angle / 360),
              child: Icon(
                Icons.add,
                color: Color(0xFFFFFFFF),
              ),
            )),
          ),
        ),
      ),
    );
  }

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  Widget _buildFloatingButton(
      double bottom,
      double right,
      String title,
      Color color,
      Function onTap,
      Color materialColor,
      Animation<double> animation) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Container(
        child: Row(
          children: <Widget>[
            ScaleTransition(
              scale: animation,
              alignment: FractionalOffset.center,
              child: Container(
                margin: EdgeInsets.only(right: 16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Roboto',
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: animation,
              alignment: FractionalOffset.center,
              child: Material(
                color: materialColor,
                type: MaterialType.circle,
                elevation: 6.0,
                child: Container(
                    width: 40.0,
                    height: 40.0,
                    child: InkWell(
                      onTap: () {
                        onTap();
                      },
                      child: Center(
                        child: Icon(
                          title == 'Camera'
                              ? Icons.camera
                              : title == 'From device'
                                  ? Icons.folder
                                  : Icons.file_download,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
