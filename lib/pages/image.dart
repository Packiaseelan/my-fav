import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:io';

import '../widgets/no_data.dart';
import '../scoped-model/main.dart';
import '../models/image.dart';
import 'image_viewer.dart';

class ImagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  String _fileName = '...';
  String _path = '...';
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;

  Widget _buildImageList(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(model.images[index].id),
          onDismissed: (DismissDirection direction) {
            model.deleteImage(index);
          },
          background: Container(color: Colors.red),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageViewer(model.images[index]);
              }));
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: Image.file(
                          File(model.images[index].imagePath),
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    title: Text(model.images[index].name),
                    subtitle: Text(File(model.images[index].imagePath)
                        .lengthSync()
                        .toString()),
                    trailing:
                        IconButton(icon: Icon(Icons.share), onPressed: () {}),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: model.images.length,
    );
  }

  void _openFileExplorer(MainModel model) async {
    _pickingType = FileType.IMAGE;
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

      if (_path != null) {
        int count = model.images.length + 1;
        model.addImage(
            Images(id: 'Image $count', imagePath: _path, name: _fileName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          body: model.images.length > 0
              ? _buildImageList(model)
              : NoDataAvailable('images'),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add new image',
            child: Icon(Icons.add),
            onPressed: () => _openFileExplorer(model),
          ),
        );
      },
    );
  }
}
