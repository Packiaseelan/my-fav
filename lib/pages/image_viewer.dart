import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';

import 'dart:io';

import 'package:my_fav/models/data.dart';
import 'package:my_fav/pages/image_details.dart';
import 'package:my_fav/utils/enumerations.dart';

class ImageViewer extends StatelessWidget {
  final DataModel model;
  final FileTypes type;
  ImageViewer(this.model, this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageDetailsPage(model, false, type);
              }));
            },
          ),
        ],
      ),
      body: Center(
          child: ZoomableImage(
        FileImage(
          File(model.path),
        ),
      )),
    );
  }
}
