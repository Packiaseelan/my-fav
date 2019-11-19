import 'dart:io';

import 'package:flutter/material.dart';

import 'package:my_fav/models/data.dart';
import 'package:my_fav/scope-models/main.dart';
import 'package:my_fav/utils/enumerations.dart';
import 'package:scoped_model/scoped_model.dart';

class ImageDetailsPage extends StatefulWidget {
  final DataModel selectedImage;
  final bool isEditable;
  final FileTypes type;

  ImageDetailsPage(this.selectedImage, this.isEditable, this.type);

  @override
  State<StatefulWidget> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditable = false;
  double top = 250;
  MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      mainModel = model;
      return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.selectedImage.name),
        //   actions: <Widget>[
        //     _buildActionButton(),
        //   ],
        // ),
        body: _contentPage(),
      );
    });
  }

  Widget _contentPage() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(
        children: <Widget>[
          _buildImage(),
          Positioned(
            top: 25,
            right: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: _buildActionButton(),
            ),
          ),
          Positioned(
            top: top,
            child: Container(
                padding: EdgeInsets.all(32),
                width: width,
                height: height * 0.70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Container(
                  child: isEditable ? _editableForm() : _displayDetails(),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    double height = MediaQuery.of(context).size.height * 0.45;
    switch (widget.type) {
      case FileTypes.Image:
        return Image.file(
          File(widget.selectedImage.path),
          fit: BoxFit.cover,
          height: height,
          width: MediaQuery.of(context).size.width,
        );
      case FileTypes.Audio:
      case FileTypes.Video:
        return Container(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          child: Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: 78,
            ),
          ),
        );

      case FileTypes.Documents:
        return Container();
      default:
        return Container();
    }
  }

  Widget _buildActionButton() {
    return IconButton(
      icon: Icon(isEditable ? Icons.save : Icons.edit),
      iconSize: 25,
      color: Colors.white,
      onPressed: () {
        setState(() {
          top = 250;
        });
        if (isEditable)
          _saveForm();
        else {
          setState(() {
            isEditable = !isEditable;
          });
        }
      },
    );
  }

  Widget _buildTextFormField(String type) {
    var _focusNode = new FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          if (type != 'alias')
            top = 150;
          else
            top = 250;
        });
      } else {
        setState(() {
          top = 250;
        });
      }
    });
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        focusNode: _focusNode,
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
          return null;
        },
        onSaved: (String value) {
          if (type == 'alias') {
            widget.selectedImage.alias = value;
          } else {
            widget.selectedImage.description = value;
          }
        },
      ),
    );
  }

  void _saveForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    mainModel.update(widget.selectedImage, widget.type);
    setState(() {
      isEditable = !isEditable;
    });
  }

  Widget _editableForm() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextFormField('alias'),
              _buildTextFormField('description'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayDetails() {
    return Container(
      child: Column(
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
}
