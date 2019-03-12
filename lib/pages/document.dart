import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/no_data.dart';
import '../scoped-model/main.dart';
import '../models/document.dart';

class DocumentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  String _fileName = '...';
  String _path = '...';
  String _extension = 'doc';
  bool _hasValidMime = false;
  FileType _pickingType = FileType.CUSTOM;
  Widget _buildDocumentList(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(model.documents[index].id),
          onDismissed: (DismissDirection direction) {
            model.deleteDocument(index);
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(model.documents[index].name),
                subtitle: Text(model.documents[index].id),
                trailing: IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: model.documents.length,
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

      int count = model.documents.length + 1;
      model.addDocument(
          Documents(id: 'Doc $count', imagePath: _path, name: _fileName));
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          body: model.documents.length > 0
              ? _buildDocumentList(model)
              : NoDataAvailable('documents'),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add new document',
            child: Icon(Icons.add),
            onPressed: () => _openFileExplorer(model),
          ),
        );
      },
    );
  }
}
