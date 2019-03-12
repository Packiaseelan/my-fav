import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';

import 'dart:io';

import 'image_details.dart';
import '../models/image.dart';

class ImageViewer extends StatelessWidget {
  final Images selectedImage;
  ImageViewer(this.selectedImage);

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
                return ImageDetailsPage(selectedImage);
              }));
            },
          ),
        ],
      ),
      body: Center(
          child: ZoomableImage(
        FileImage(
          File(selectedImage.imagePath),
        ),
      )),
    );
  }
}
