import 'package:scoped_model/scoped_model.dart';

import 'package:my_fav/data/dbhelper.dart';
import 'package:my_fav/models/data.dart';
import 'package:my_fav/utils/enumerations.dart';

class MainModel extends Model {
  DBHelper _helper = DBHelper();

  List<DataModel> imageList = [];
  List<DataModel> audioList = [];
  List<DataModel> videoList = [];
  List<DataModel> docList = [];

  List<DataModel> getData(FileTypes type) {
    switch (type) {
      case FileTypes.Audio:
        return audioList;
      case FileTypes.Image:
        return imageList;
      case FileTypes.Video:
        return videoList;
      case FileTypes.Documents:
        return docList;
      default:
        return imageList;
    }
  }

  // void setData(List<DataModel> data, FileTypes type) {
  //   switch (type) {
  //     case FileTypes.Audio:
  //       audioList = data;
  //       break;
  //     case FileTypes.Image:
  //       imageList = data;
  //       break;
  //     case FileTypes.Video:
  //       videoList = data;
  //       break;
  //     case FileTypes.Documents:
  //       docList = data;
  //       break;
  //   }
  //   notifyListeners();
  // }

  void _addData(DataModel data, FileTypes types) {
    switch (types) {
      case FileTypes.Audio:
        audioList.add(data);
        break;
      case FileTypes.Image:
        imageList.add(data);
        break;
      case FileTypes.Video:
        videoList.add(data);
        break;
      case FileTypes.Documents:
        docList.add(data);
        break;
    }
    notifyListeners();
  }

  void _removeData(DataModel data, FileTypes type) {
    switch (type) {
      case FileTypes.Audio:
        audioList.remove(data);
        break;
      case FileTypes.Image:
        imageList.remove(data);
        break;
      case FileTypes.Video:
        videoList.remove(data);
        break;
      case FileTypes.Documents:
        docList.remove(data);
        break;
    }
    notifyListeners();
  }

  void init() {
    _getData(FileTypes.Image);
    _getData(FileTypes.Audio);
    _getData(FileTypes.Video);
    _getData(FileTypes.Documents);
  }

  void _getData(FileTypes type) async {
    var list = _helper.getDataList(type);
    list.then((dataList) {
      switch (type) {
        case FileTypes.Image:
          imageList = dataList;
          break;
        case FileTypes.Audio:
          audioList = dataList;
          break;
        case FileTypes.Video:
          videoList = dataList;
          break;
        case FileTypes.Documents:
          docList = dataList;
          break;
      }
      notifyListeners();
    });
  }

  void _updateData(DataModel data, FileTypes type) {
    switch (type) {
      case FileTypes.Image:
        imageList.where((d) => d.id == data.id).toList()[0] = data;
        break;
      case FileTypes.Audio:
        audioList.where((d) => d.id == data.id).toList()[0] = data;
        break;
      case FileTypes.Video:
        videoList.where((d) => d.id == data.id).toList()[0] = data;
        break;
      case FileTypes.Documents:
        docList.where((d) => d.id == data.id).toList()[0] = data;
        break;
    }
  }

  void delete(DataModel data, FileTypes type) async {
    _removeData(data, type);
    await _helper.delete(type, data.id);
  }

  void insert(DataModel data, FileTypes type) async {
    _addData(data, type);
    await _helper.insert(type, data.toMap());
  }

  void update(DataModel data, FileTypes type) async {
    _updateData(data, type);
    await _helper.update(type, data.toMap());
  }
}
