import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();

  CollectionReference _recipes =
      FirebaseFirestore.instance.collection('Recipes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _controllerTitle,
              decoration: InputDecoration(hintText: 'Enter title'),
            ),
            TextFormField(
              controller: _controllerDesc,
              decoration: InputDecoration(hintText: 'Enter desc'),
            ),
            ElevatedButton(onPressed: _addRecipe, child: Text('Add Recipe'))
          ],
        ),
      ),
    );
  }

  _addRecipe() {
    return _recipes
        .add({
          'title': _controllerTitle.text,
          'desc': _controllerDesc.text,
        })
        .then((value) => print("Recipe Added"))
        .catchError((error) => print("Failed to add recipe: $error"));
  }
}
