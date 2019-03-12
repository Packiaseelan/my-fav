import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/no_data.dart';
import '../scoped-model/main.dart';
import '../models/video.dart';

class VideoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String _fileName = '...';
  String _path = '...';
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;

  Widget _buildVideoList(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(model.videos[index].id),
          onDismissed: (DismissDirection direction) {
            model.deleteVideo(index);
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.ondemand_video),
                title: Text(model.videos[index].name),
                subtitle: Text(model.videos[index].id),
                trailing: IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: model.videos.length,
    );
  }

  void _openFileExplorer(MainModel model) async {
    _pickingType = FileType.VIDEO;
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
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

      int count = model.videos.length + 1;
      model.addVideo(
          Videos(id: 'Video $count', videoPath: _path, name: _fileName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          body: model.videos.length > 0
              ? _buildVideoList(model)
              : NoDataAvailable('videos'),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add new video',
            child: Icon(Icons.add),
            onPressed: () => _openFileExplorer(model),
          ),
        );
      },
    );
  }
}
