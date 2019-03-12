import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/no_data.dart';
import '../scoped-model/main.dart';
import '../models/audio.dart';

class AudioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioPaageState();
}

class _AudioPaageState extends State<AudioPage> {
  String _fileName = '...';
  String _path = '...';
  String _extension = 'mp3';
  bool _hasValidMime = false;
  FileType _pickingType = FileType.CUSTOM;
  Widget _buildAudioList(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(model.audios[index].id),
          onDismissed: (DismissDirection direction) {
            model.deleteaudio(index);
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.queue_music),
                title: Text(model.audios[index].name),
                subtitle: Text(model.audios[index].id),
                trailing: IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: model.audios.length,
    );
  }

  void _openFileExplorer(MainModel model) async {
    if (_pickingType == FileType.CUSTOM || _hasValidMime) {
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
        int count = model.audios.length + 1;
        model.addAudio(
            Audios(id: 'Audio $count', audioPath: _path, name: _fileName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          body: model.audios.length > 0
              ? _buildAudioList(model)
              : NoDataAvailable('audios'),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add new audio',
            child: Icon(Icons.add),
            onPressed: () => _openFileExplorer(model),
          ),
        );
      },
    );
  }
}
