import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/recipe_details.dart';

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
    try {
      final docRef = await _recipes.add({
        'title': _controllerTitle.text,
        'desc': _controllerDesc.text,
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

  _clearForm() {
    _controllerTitle.clear();
    _controllerDesc.clear();
  }
}
