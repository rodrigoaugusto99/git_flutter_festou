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
  Future uploadPostImages({
    required List<File> imageFiles,
    required String spaceId,
    required File coverPhoto,
  }) async {
    try {
      // Crie um prefixo para as imagens com base no espaçoId
      final prefix = 'posts/$spaceId';

      // Faça o upload de cada imagem individualmente
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        if (imageFile == coverPhoto) {
          var storageRef = storage.ref().child('$prefix/coverPhoto.jpg');
          await storageRef.putFile(imageFile);
        } else {
          var storageRef = storage.ref().child('$prefix/imagem_$i.jpg');
          await storageRef.putFile(imageFile);
        }
      }

      log('Imagens do post do espaco $spaceId enviadas com sucesso para o Firebase Storage');
    } catch (e) {
      log('Erro ao enviar imagens para o Firebase Storage: $e');
    }
  }

  Future<Map<String, dynamic>?> getPostImages(String spaceId) async {
    try {
      // Crie um prefixo para as imagens com base no spaceId
      final prefix = 'posts/$spaceId';

      // Recupere a lista de itens no Firebase Storage com o prefixo
      final ListResult result = await storage.ref().child(prefix).listAll();
      final imagesUrl = <String>[];
      String? coverPhotoUrl;

      // Extraia as URLs das imagens da lista de itens
      for (var item in result.items) {
        final downloadURL = await item.getDownloadURL();
        if (item.name == 'coverPhoto.jpg') {
          coverPhotoUrl = downloadURL;
        }
        imagesUrl.add(downloadURL);
      }

      log('Imagens do post do espaço $spaceId recuperadas com sucesso do Firebase Storage');

      return {
        'coverPhotoUrl': coverPhotoUrl,
        'imagesUrl': imagesUrl,
      };
    } catch (e) {
      log('Erro ao recuperar imagens do Firebase Storage: $e');
      return null;
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
        coverPhoto: coverPhoto,
      );

      final postImages = await getPostImages(spaceId);
      if (postImages!['imagesUrl'] == null) {
        log('Erro ao adicionar post no firestore: postImages![imagesUrl] == null');
        return;
      }
      const uuid = Uuid();
      Map<String, dynamic> newPost = {
        'id': uuid.v1(),
        'titulo': titulo,
        'descricao': descricao,
        'imagens': postImages['imagesUrl'],
        'coverPhoto': postImages['coverPhotoUrl'],
        'createdAt': FieldValue.serverTimestamp(),
      };

      await postsCollection.doc(spaceId).collection('posts').add(newPost);
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
          DateTime thirtyDaysAgo =
              DateTime.now().subtract(const Duration(days: 30));
          Timestamp thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);

          // Recupera a lista de IDs do campo "space_favorites"
          List<dynamic> spaceFavoritesDynamic = userDoc['spaces_favorite'];
          List<String> spaceFavorites =
              List<String>.from(spaceFavoritesDynamic);
          List<DocumentSnapshot> postDocuments = [];

//todo: paginacao limit(10)

          for (var space in spaceFavorites) {
            QuerySnapshot postsSnapshot = await firestore
                .collection('posts')
                .doc(space)
                .collection('posts')
                .where('createdAt',
                    isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
                .orderBy('createdAt', descending: true)
                .get();

            for (var post in postsSnapshot.docs) {
              postDocuments.add(post);
            }
          }

// firestore.collection('items')
//   .where('status', '==', 'active')
//   .orderBy('timestamp', 'desc')
//   .limit(pageSize).
//   .get()
//   .then((snapshot) => {
//     if (!snapshot.empty) {
//       const lastVisible = snapshot.docs[snapshot.docs.length - 1];
//       snapshot.forEach((doc) => {
//         console.log(doc.id, ' => ', doc.data());
//       });
//     }
//   });

          List<PostModel> postModels = [];
          //postDocuments.where((element) => false);

          for (var doc in postDocuments) {
            final data = doc.data() as Map<String, dynamic>;
            final imagensDynamic = data['imagens'] as List<dynamic>;
            final imagens = List<String>.from(imagensDynamic);
            final post = PostModel(
              title: data['titulo'] ?? '',
              description: data['descricao'] ?? '',
              coverPhoto: data['coverPhoto'] ?? '',
              imagens: imagens,
              id: data['id'] ?? doc.id,
            );
            postModels.add(post);
          }

          QuerySnapshot festouSnapshot = await firestore
              .collection('posts')
              .doc('festou')
              .collection('posts')
              .get();
          final festouSnap = festouSnapshot.docs[0];

          if (!festouSnap.exists) return postModels;

          final data = festouSnap.data() as Map<String, dynamic>;
          final imagensDynamic = data['imagens'] as List<dynamic>;
          final imagens = List<String>.from(imagensDynamic);
          final post = PostModel(
            title: data['titulo'] ?? '',
            coverPhoto: data['coverPhoto'] ?? '',
            description: data['descricao'] ?? '',
            imagens: imagens,
            id: data['id'] ?? festouSnap.id,
          );

          postModels.insert(0, post);

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
