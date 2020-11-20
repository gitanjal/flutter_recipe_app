import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/recipe_details.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();

  final _keyScaffold = GlobalKey<ScaffoldState>();
  final _keyForm = GlobalKey<FormState>();

  CollectionReference _recipes =
      FirebaseFirestore.instance.collection('Recipes');
  File _image;
  final picker = ImagePicker();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _keyForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllerTitle,
                    decoration: InputDecoration(hintText: 'Enter title'),
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a title';

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _controllerDesc,
                    decoration: InputDecoration(hintText: 'Enter desc'),
                  ),
                  Row(
                    children: [
                      Text('Recipe Image:'),
                      IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () async {
                            final pickedFile = await picker.getImage(
                                source: ImageSource.camera);

                            setState(() {
                              if (pickedFile != null) {
                                _image = File(pickedFile.path);
                              } else {
                                print('No image selected.');
                              }
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () async {
                            final pickedFile = await picker.getImage(
                                source: ImageSource.gallery);

                            setState(() {
                              if (pickedFile != null) {
                                _image = File(pickedFile.path);
                              } else {
                                print('No image selected.');
                              }
                            });
                          })
                    ],
                  ),
                  Row(
                    children: [
                      (_image == null)
                          ? Container()
                          : Image.file(
                              _image,
                              width: 100,
                              height: 100,
                            ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_keyForm.currentState.validate()) {
                          //display a loader
                          setState(() {
                            _loading = true;
                          });

                          await _addRecipe();

                          //hide the loader
                          setState(() {
                            _loading = false;
                          });
                        }
                      },
                      child: Text('Add Recipe'))
                ],
              ),
            ),
    );
  }

  _addRecipe() async {
    String url = await _uploadFile(_image);
    if (url == null) {
      print('Failed to upload the image');
      _keyScaffold.currentState.showSnackBar(SnackBar(
          content: Text('Some error occurred while uploading the image')));
    } else {
      try {
        final docRef = await _recipes.add({
          'title': _controllerTitle.text,
          'desc': _controllerDesc.text,
          'imageUrl': url,
        });

        //clear the form
        _clearForm();
        _keyScaffold.currentState.showSnackBar(SnackBar(
          content: Text('Recipe Added'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeDetails(docRef.id)));
            },
          ),
        ));
      } on FirebaseException catch (e) {
        print('Failed to add recipe: $e');
        _keyScaffold.currentState
            .showSnackBar(SnackBar(content: Text('Failed to add recipe')));
      }
    }
  }

  Future<String> _uploadFile(File file) async {
    String url;

    if (file != null) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      final reference = FirebaseStorage.instance.ref('uploads/$timestamp.png');
      try {
        await reference.putFile(file);
        url = await reference.getDownloadURL();
      } on FirebaseException catch (e) {}
    }
    return url;
  }

  _clearForm() {
    _controllerTitle.clear();
    _controllerDesc.clear();
    _image=null;

  }
}
