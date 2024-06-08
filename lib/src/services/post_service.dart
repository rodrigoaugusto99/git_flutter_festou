import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:git_flutter_festou/src/models/post_model.dart';
import 'package:uuid/uuid.dart';

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
      const uuid = Uuid();
      Map<String, dynamic> newPost = {
        'id': uuid.v1(),
        'space_id': spaceId,
        'titulo': titulo,
        'descricao': descricao,
        'imagens': spaceResult,
        'coverPhoto': coverPhoto,
      };

      await postsCollection.add(newPost);
      log('Post criado com sucesso');
    } catch (e) {
      log('Erro ao adicionar post no firestore: $e');
    }
  }

  Future<List<PostModel>?> getPostModelsBySpaceIds() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        QuerySnapshot userSnapshot = await firestore
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // Assume que o primeiro documento encontrado é o usuário desejado
          DocumentSnapshot userDoc = userSnapshot.docs.first;

          // Recupera a lista de IDs do campo "space_favorites"
          List<dynamic> spaceFavoritesDynamic = userDoc['spaces_favorite'];
          List<String> spaceFavorites =
              List<String>.from(spaceFavoritesDynamic);

          // Consulta para recuperar os posts onde o campo "spaceId" está contido na lista spaceFavorites
          QuerySnapshot postsSnapshot = await firestore
              .collection('posts')
              .where('spaceId', whereIn: spaceFavorites)
              .get();

          List<PostModel> postModels = [];

          for (var doc in postsSnapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final imagensDynamic = data['imagens'] as List<dynamic>;
            final imagens = List<String>.from(imagensDynamic);

            final post = PostModel(
              title: data['titulo'] ?? '',
              description: data['descricao'] ?? '',
              imagens: imagens,
              coverPhoto: data['coverPhoto'] ?? '',
              id: data['id'] ?? doc.id,
            );
            postModels.add(post);
          }
          return postModels;
        } else {
          print('Usuário não encontrado.');
          return null;
        }
      } catch (e) {
        print('Erro ao recuperar dados: $e');
        return null;
      }
    } else {
      print('Usuário não autenticado.');
      return null;
    }
  }
}
