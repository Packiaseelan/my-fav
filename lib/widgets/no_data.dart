import 'package:flutter/material.dart';
import 'package:my_fav/utils/enumerations.dart';

class NoDataAvailable extends StatelessWidget {
  final FileTypes type;

  NoDataAvailable(this.type);

  Widget _buildIcon() {
    switch (type) {
      case FileTypes.Image:
        return Icon(Icons.image);
      case FileTypes.Audio:
        return Icon(Icons.library_music);
      case FileTypes.Video:
        return Icon(Icons.video_library);
      case FileTypes.Documents:
        return Icon(Icons.attach_file);
      default:
      return Icon(Icons.favorite);
    }
  }

  String _getString() {
    switch (type) {
      case FileTypes.Image:
        return 'images';
      case FileTypes.Audio:
        return 'audios';
      case FileTypes.Video:
        return 'videos';
      case FileTypes.Documents:
        return 'documents';
      default:
      return 'favorite';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIcon(),
          Text("No ${_getString()} available.")
        ],
      ),
    );
  }
}
