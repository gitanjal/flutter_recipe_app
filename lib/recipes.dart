import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/add_recipe.dart';
import 'package:flutter_recipe/recipe_details.dart';

class Recipes extends StatelessWidget {
  CollectionReference recipes =
      FirebaseFirestore.instance.collection('Recipes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>AddRecipe()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: recipes.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeDetails(
                                snapshot.data.documents[index].documentID)));
                  },
              //    leading: (snapshot.data.documents[index]['imageUrl']!=null)?Image.network(snapshot.data.documents[index]['imageUrl']):Container(),
                  title: Text(snapshot.data.documents[index]['title']),
                  subtitle: Text(snapshot.data.documents[index]['desc']),
                );
              },
            );
          }),
    );
  }
}
