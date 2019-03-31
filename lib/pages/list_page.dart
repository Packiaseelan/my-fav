import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

import 'dart:io';

import 'package:my_fav/data/dbhelper.dart';
import 'package:my_fav/models/data.dart';
import 'package:my_fav/pages/audio_player.dart';
import 'package:my_fav/pages/image_viewer.dart';
import 'package:my_fav/utils/enumerations.dart';
import 'package:my_fav/widgets/no_data.dart';

class ListPage extends StatefulWidget {
  final FileTypes types;
  ListPage(this.types);
  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DBHelper _helper = DBHelper();
  List<DataModel> imageList;
  int count = 0;

  String _fileName = '...';
  String _path = '...';
  String _extension;
  FileType _pickingType;

  Widget _buildImageList(List<DataModel> model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(imageList[index].id.toString()),
          onDismissed: (DismissDirection direction) {
            _delete(context, imageList[index]);
          },
          background: Container(color: Colors.red),
          child: InkWell(
            onTap: () {
              _onItemTapped(model[index], index);
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: _getAvatar(model[index].path),
                      ),
                    ),
                    title: Text(_getName(model[index])),
                    subtitle:
                        Text(_calcSize(File(model[index].path).lengthSync())),
                    trailing:
                        IconButton(icon: Icon(Icons.share), onPressed: () {}),
                  ),
                ],
              ),
            ),
          ),
        );
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ImageViewer(model, widget.types);
        }));
        break;
      case FileTypes.Audio:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AudioPlayer(index);
        }));
        break;
      case FileTypes.Video:
        break;
      case FileTypes.Documents:
        OpenFile.open(model.path);
        break;
    }
  }

  void _openFileExplorer(List<DataModel> model) async {
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
      _insert(context, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageList == null) {
      imageList = List<DataModel>();
      _updateListView();
    }

    return Scaffold(
      body: imageList.length > 0
          ? _buildImageList(imageList)
          : NoDataAvailable(widget.types),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new image',
        child: Icon(Icons.add),
        onPressed: () => _openFileExplorer(imageList),
      ),
    );
  }

  void _delete(BuildContext context, DataModel data) async {
    var result = await _helper.delete(widget.types, data.id);
    if (result != 0) {
      _showSnackBar(context, '${data.name} removed from my favourite.');
      _updateListView();
    }
  }

  void _insert(BuildContext context, DataModel data) async {
    var result = await _helper.insert(widget.types, data.toMap());
    if (result != 0) {
      _showSnackBar(context, '${data.name} added to my favourite.');
      _updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

   void _updateListView() async {
    if (imageList == null) {
      imageList = List<DataModel>();
    }
    var list = _helper.getDataList(widget.types);

    list.then((dataList) {
      setState(() {
        imageList = dataList;
        count = dataList.length;
      });
    });
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
}
