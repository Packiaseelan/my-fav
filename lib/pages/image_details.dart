import 'package:flutter/material.dart';

import 'dart:io';

import 'package:my_fav/models/data.dart';


class ImageDetailsPage extends StatefulWidget {
  final DataModel selectedImage;
  final bool isEditable;
  ImageDetailsPage(this.selectedImage, this.isEditable);
  @override
  State<StatefulWidget> createState() => _ImageDetailsPageState();
}

Widget _buildActionButton(bool isEditable) {
  if (isEditable)
    return IconButton(
      icon: Icon(Icons.save),
      onPressed: () {
        isEditable =false;
      },
    );
  else
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        isEditable = true;
      },
    );
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  bool _isEditable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedImage.name),
        actions: <Widget>[
          _buildActionButton(_isEditable),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.file(
              File(widget.selectedImage.path),
              width: 250,
              height: 250,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.selectedImage.name,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
