class DataModel {
  int _id;
  String _name;
  String _path;
  String _date;
  String _alias;
  String _description;

  DataModel(this._id, this._name, this._path, this._date, this._alias,
      this._description);

  int get id => _id;

  String get name => _name;

  String get path => _path;

  String get date => _date;

  String get alias => _alias;

  String get description => _description;

  set id(int newId) {
    this._id = newId;
  }

  set name(String newName) {
    this._name = newName;
  }

  set path(String newPath) {
    this._path = newPath;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set alias(String newAlias) {
    this._alias = newAlias;
  }

  set description(String newDescription) {
    this._description = newDescription;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['path'] = path;
    map['name'] = name;
    map['date'] = date;
    map['alias'] = alias;
    map['description'] = description;
    return map;
  }

  DataModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._path = map['path'];
    this._date = map['date'];
    this._alias = map['alias'];
    this._description = map['description'];
  }
  
}
