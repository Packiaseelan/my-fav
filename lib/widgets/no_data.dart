import 'package:flutter/material.dart';

class NoDataAvailable extends StatelessWidget {
  final String name;

  NoDataAvailable(this.name);

  Widget _buildIcon() {
    switch (name) {
      case 'images':
        return Icon(Icons.image);
      case 'audios':
        return Icon(Icons.library_music);
      case 'videos':
        return Icon(Icons.video_library);
      case 'documents':
        return Icon(Icons.attach_file);
      default:
      return Icon(Icons.favorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIcon(),
          Text("No $name available.")
        ],
      ),
    );
  }
}
