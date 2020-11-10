import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Recipes extends StatelessWidget {

  CollectionReference recipes = FirebaseFirestore.instance.collection('Recipes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: recipes.snapshots(),
          builder: (context,snapshot){
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView.builder(
              itemCount:snapshot.data.documents.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(snapshot.data.documents[index]['title']),
                  subtitle: Text(snapshot.data.documents[index]['desc']),
                );
              },
            );
          }),
    );
  }
}