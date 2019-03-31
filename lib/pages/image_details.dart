import 'package:flutter/material.dart';
import 'package:my_fav/data/dbhelper.dart';

import 'dart:io';

import 'package:my_fav/models/data.dart';
import 'package:my_fav/utils/enumerations.dart';

class ImageDetailsPage extends StatefulWidget {
  
  final DataModel selectedImage;
  final bool isEditable;
  final FileTypes type;

  ImageDetailsPage(this.selectedImage, this.isEditable, this.type);

  @override
  State<StatefulWidget> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {

  DBHelper _helper = DBHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _map;

  @override
  Widget build(BuildContext context) {
    _map = _toMap(widget.selectedImage);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedImage.name),
        actions: <Widget>[
          _buildActionButton(),
        ],
      ),
      body: _contentPage(),
    );
  }

  Widget _contentPage() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Row(
        children: <Widget>[
          _imageAvatar(),
          widget.isEditable ? _editableForm() : _displayDetails(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          _imageAvatar(),
          widget.isEditable ? _editableForm() : _displayDetails(),
        ],
      );
    }
  }

  Widget _imageAvatar() {
    return Center(
      child: Container(
        width: 250.0,
        height: 250.0,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipOval(
                      child: Image.file(
                        File(widget.selectedImage.path),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (!widget.isEditable) {
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ImageDetailsPage(widget.selectedImage, true, widget.type);
          }));
        },
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  Widget _buildTextFormField(String type) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: type == 'alias' ? 'Name' : 'Description',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(28.0))),
        maxLines: type == 'alias' ? 1 : 10,
        initialValue: _getNameOrDescription(type),
        validator: (String value) {
          if (type == 'alias') {
            if (value.isEmpty || value.length < 5) {
              return 'Name is required and should be 5+ characters';
            }
          } else {
            if (value.isEmpty || value.length < 10) {
              return 'Description is required and should be 10+ characters';
            }
          }
        },
        onSaved: (String value) {
          if (type == 'alias') {
            _map['alias'] = value;
          } else {
            _map['description'] = value;
          }
        },
      ),
    );
  }

  void _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    var result = await _helper.update(widget.type, _map);
    if (result == 0) {
      _showSnackBar(context, 'Problem while update ${_map['alias']}.');
    }
    Navigator.pop(context, false);
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(27.0),
        shadowColor: Theme.of(context).primaryColorDark,
        color: Theme.of(context).primaryColor,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            _saveForm();
          },
          //color: Colors.lightBlueAccent,
          child: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _editableForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextFormField('alias'),
              _buildTextFormField('description'),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayDetails() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Center(
            child: Text(
              _getName(),
              style: TextStyle(
                  fontFamily: 'Oswald', color: Colors.red, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _getDescription(),
              style: TextStyle(
                  fontFamily: 'Oswald', color: Colors.grey, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  String _getNameOrDescription(String type) {
    if (type == 'alias')
      return widget.selectedImage.alias == null
          ? ''
          : widget.selectedImage.alias;
    else
      return widget.selectedImage.description == null
          ? ''
          : widget.selectedImage.description;
  }

  String _getName() {
    var text = widget.selectedImage.alias;
    if (text != '' && text != null)
      return text;
    else
      return widget.selectedImage.name;
  }

  String _getDescription() {
    var text = widget.selectedImage.description;
    if (text != '' && text != null)
      return text;
    else
      return 'No description available for ${_getName()}, please edit and add description.';
  }

  Map<String, dynamic> _toMap(DataModel model) {
    var map = Map<String, dynamic>();
    if (model != null) {
      map['id'] = model.id;
      map['name'] = model.name;
      map['path'] = model.path;
      map['alias'] = model.alias;
      map['description'] = model.description;
    }
    return map;
  }
}
