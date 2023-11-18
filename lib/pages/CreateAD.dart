import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Anuncio {
  String nome;
  double preco;
  String imagemUrl;

  Anuncio({
    required this.nome,
    required this.preco,
    required this.imagemUrl,
  });
}

class CreateAD extends StatefulWidget {
  const CreateAD({Key? key}) : super(key: key);

  @override
  State<CreateAD> createState() => _CreateADState();
}

class _CreateADState extends State<CreateAD> {
  var image = null;

  String nome = '';
  double preco = 0.0;

  loadImage() async {
    var picker = ImagePicker();
    var uploadImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = uploadImage;
    });
  }

  Future<void> uploadImageToStorage(File imageFile) async {
    try {
      await Firebase.initializeApp();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('Fotos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      var uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      var imageUrl = await storageReference.getDownloadURL();
      createAd(nome, preco, imageUrl);
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
    }
  }

  createAd(String nome, double preco, String imagemUrl) async {
    try {
      await Firebase.initializeApp();

      // Salvar detalhes do anúncio no Firestore
      await FirebaseFirestore.instance.collection('Anuncios').add({
        'nome': nome,
        'preco': preco,
        'imagemUrl': imagemUrl,
      });

      print('Anúncio criado com sucesso!');
    } catch (e) {
      print('Erro ao criar anúncio: $e');
    }
  }

  Future<void> getUserInput() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informe os detalhes do anúncio'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    nome = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    preco = double.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (image != null) {
                  await uploadImageToStorage(File(image.path));
                }
              },
              child: Text('Criar Anúncio'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Anúncio'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            color: Colors.grey,
            child: image == null
                ? TextButton.icon(
                    onPressed: loadImage,
                    icon: Icon(Icons.photo_camera),
                    label: Text('Carregar imagem'),
                  )
                : Image.file(File(image.path), fit: BoxFit.cover),
          ),
          ElevatedButton(
            onPressed: () {
              getUserInput();
            },
            child: Text('Criar Anúncio'),
          ),
        ],
      ),
    );
  }
}
