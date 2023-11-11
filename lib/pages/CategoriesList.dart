import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    getAd();
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: FutureBuilder(
        future: getAd(),
        builder: (context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data[index]['name']),
              );
            },
          );
        },
      ),
    );
  }
}

getAd() async {
  await Firebase.initializeApp();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var categorias = await db.collection('Categorias').get();
  return categorias.docs;
}
