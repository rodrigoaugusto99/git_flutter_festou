import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:git_flutter_festou/src/models/post_model.dart';

class PostService {
  final storage = FirebaseStorage.instance;

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  Future uploadPostImages(
      {required List<File> imageFiles, required String spaceId}) async {
    try {
      // Crie um prefixo para as imagens com base no espaçoId
      final prefix = 'posts/$spaceId';

      // Faça o upload de cada imagem individualmente
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        var storageRef = storage.ref().child('$prefix/imagem_$i.jpg');

        await storageRef.putFile(imageFile);
      }

      log('Imagens do post do espaco $spaceId enviadas com sucesso para o Firebase Storage');
    } catch (e) {
      log('Erro ao enviar imagens para o Firebase Storage: $e');
    }
  }

  Future getPostImages(String spaceId) async {
    try {
      // Crie um prefixo para as imagens com base no spaceId
      final prefix = 'posts/$spaceId';

      // Recupere a lista de itens no Firebase Storage com o prefixo
      final ListResult result = await storage.ref().child(prefix).listAll();
      final imagesUrl = <String>[];

      // Extraia as URLs das imagens da lista de itens
      for (var item in result.items) {
        final downloadURL = await item.getDownloadURL();
        imagesUrl.add(downloadURL);
      }

      log('Imagens do post do espaço $spaceId recuperadas com sucesso do Firebase Storage');
    } catch (e) {
      log('Erro ao recuperar imagens do Firebase Storage: $e');
    }
  }

  Future savePost({
    required String spaceId,
    required List<File> imageFiles,
    required String titulo,
    required String descricao,
    required File coverPhoto,
  }) async {
    try {
      await uploadPostImages(
        imageFiles: imageFiles,
        spaceId: spaceId,
      );

      final spaceResult = await getPostImages(spaceId);

      Map<String, dynamic> newPost = {
        'space_id': spaceId,
        'titulo': titulo,
        'descricao': descricao,
        'images_url': spaceResult,
      };

      await postsCollection.add(newPost);
      log('Post criado com sucesso');
    } catch (e) {
      log('Erro ao adicionar post no firestore: $e');
    }
  }

  //todo:recuperar posts no firestore em que o spaceId esta contido no array "spacer_favorte" do usuario no firestore
}
