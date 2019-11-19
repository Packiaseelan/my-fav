import 'package:flutter/material.dart';
//import 'package:zoomable_image/zoomable_image.dart';

import 'dart:io';

import 'package:my_fav/models/data.dart';
import 'package:my_fav/pages/image_details.dart';
import 'package:my_fav/scope-models/main.dart';
import 'package:my_fav/utils/enumerations.dart';
import 'package:scoped_model/scoped_model.dart';

class ImageViewer extends StatelessWidget {
  final FileTypes type;
  final int index;
  ImageViewer(this.index, this.type);
  @override
  Widget build(BuildContext context) {
    DataModel _data;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      _data = model.getData(type)[index];
      return Scaffold(
        appBar: AppBar(
          title: Text(_data.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ImageDetailsPage(_data, false, type);
                }));
              },
            ),
          ],
        ),
        // body: Center(
        //     child: ZoomableImage(
        //   FileImage(
        //     File(model.path),
        //   ),
        // )),
        body: Center(
          child: Image.file(
            File(_data.path),
          ),
        ),
      );
    });
  }
}
