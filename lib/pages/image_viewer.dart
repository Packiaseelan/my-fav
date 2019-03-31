import 'package:flutter/material.dart';
import 'package:my_fav/models/data.dart';

import 'dart:io';

import 'package:my_fav/pages/image_details.dart';
import 'package:my_fav/utils/enumerations.dart';
import 'package:zoomable_image/zoomable_image.dart';

class ImageViewer extends StatelessWidget {
  final DataModel selectedImage;
  final FileTypes type;
  ImageViewer(this.selectedImage, this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedImage.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageDetailsPage(selectedImage, false, type);
              }));
            },
          ),
        ],
      ),
      body: Center(
          child: ZoomableImage(
        FileImage(
          File(selectedImage.path),
        ),
      )),
    );
  }
}
