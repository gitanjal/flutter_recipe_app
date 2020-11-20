import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {

  final String documentId;
  RecipeDetails(this.documentId);

  @override
  Widget build(BuildContext context) {

    CollectionReference recipes = FirebaseFirestore.instance.collection('Recipes');
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<DocumentSnapshot>(
        future: recipes.doc(documentId).get(),
        builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Column(
              children: [
                Image.network(data['imageUrl']),
                Text(" ${data['title']}"),
                Text(" ${data['desc']}"),
              ],
            );
          }

          return Text("loading");
        },
      ),
    );
  }

}
