import 'package:scoped_model/scoped_model.dart';

import '../models/image.dart';
import '../models/audio.dart';
import '../models/video.dart';
import '../models/document.dart';

class MainModel extends Model {
  List<Images> images = [];
  List<Audios> audios = [];
  List<Videos> videos = [];
  List<Documents> documents = [];

  addImage(Images img) {
    images.add(img);
    notifyListeners();
  }

  deleteImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  addAudio(Audios aud) {
    audios.add(aud);
    notifyListeners();
  }

  deleteaudio(int index) {
    audios.removeAt(index);
    notifyListeners();
  }

  addVideo(Videos vid) {
    videos.add(vid);
    notifyListeners();
  }

  deleteVideo(int index) {
    videos.removeAt(index);
    notifyListeners();
  }

  addDocument(Documents doc) {
    documents.add(doc);
    notifyListeners();
  }

  deleteDocument(int index) {
    documents.removeAt(index);
    notifyListeners();
  }
}
