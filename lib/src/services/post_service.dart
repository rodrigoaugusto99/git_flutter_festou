import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:festou/src/models/post_model.dart';

class PostService {
  final storage = FirebaseStorage.instance;

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<void> setPostAsRead(String postId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    try {
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return;
      }

      // Pega o primeiro documento do usuário
      DocumentReference userDocRef = userSnapshot.docs.first.reference;

      // Atualiza a lista seenPostsIds garantindo que não haja duplicatas
      await userDocRef.update({
        'seenPostsIds': FieldValue.arrayUnion([postId]),
      });

      log('Post $postId marcado como lido com sucesso');
    } catch (e) {
      log('Erro ao marcar post $postId como lido: $e');
    }
  }

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

      Map<String, dynamic> newPost = {
        'titulo': titulo,
        'descricao': descricao,
        'imagens': postImages['imagesUrl'],
        'coverPhoto': postImages['coverPhotoUrl'],
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Crie o documento ancestral se não existir
      final ancestorDoc = postsCollection.doc(spaceId);
      final ancestorSnapshot = await ancestorDoc.get();
      if (!ancestorSnapshot.exists) {
        await ancestorDoc.set({
          'createdAt': FieldValue.serverTimestamp()
        }); // Documento ancestral vazio com timestamp
      }

      await ancestorDoc.collection('posts').add(newPost);
      log('Post criado com sucesso');
    } catch (e) {
      log('Erro ao adicionar post no firestore: $e');
    }
  }

  //todo: armazenar o ultimo documento lido aqui
  //todo: quando for chamar outro metodo, usar esse ultimo documento armazenado como startAfter

  Future<List<PostModel>?> getPostModelsBySpaceIds() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return null;
      }

      // Documento do usuário
      DocumentSnapshot userDoc = userSnapshot.docs.first;

      // Obtém a lista de IDs dos espaços favoritos
      List<dynamic> spaceFavoritesDynamic = userDoc['spaces_favorite'];
      List<String> spaceFavorites = List<String>.from(spaceFavoritesDynamic);

      // Obtém a lista de posts já vistos pelo usuário
      List<dynamic> seenPostsDynamic = userDoc['seenPostsIds'] ?? [];
      List<String> seenPostsIds = List<String>.from(seenPostsDynamic);

      DateTime thirtyDaysAgo =
          DateTime.now().subtract(const Duration(days: 30));
      Timestamp thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);

      List<DocumentSnapshot> postDocuments = [];

      for (var space in spaceFavorites) {
        if (postDocuments.length >= 10) break;

        QuerySnapshot postsSnapshot = await firestore
            .collection('posts')
            .doc(space)
            .collection('posts')
            .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
            .orderBy('createdAt', descending: true)
            .get();

        for (var post in postsSnapshot.docs) {
          if (postDocuments.length >= 10) break;
          postDocuments.add(post);
        }
      }

      List<PostModel> postModels = [];

      for (var doc in postDocuments) {
        final data = doc.data() as Map<String, dynamic>;
        final imagensDynamic = data['imagens'] as List<dynamic>;
        final imagens = List<String>.from(imagensDynamic);
        final post = PostModel(
          title: data['titulo'] ?? '',
          createdAt: data['createdAt'] ?? Timestamp.now(),
          description: data['descricao'] ?? '',
          coverPhoto: data['coverPhoto'] ?? '',
          imagens: imagens,
          id: doc.id,
        );
        postModels.add(post);
      }

      // Obtém um post especial da coleção "festou"
      QuerySnapshot festouSnapshot = await firestore
          .collection('posts')
          .doc('festou')
          .collection('posts')
          .limit(1) // Limite de 1 documento
          .get();

      if (festouSnapshot.docs.isNotEmpty) {
        final festouSnap = festouSnapshot.docs[0];

        final data = festouSnap.data() as Map<String, dynamic>;
        final imagensDynamic = data['imagens'] as List<dynamic>;
        final imagens = List<String>.from(imagensDynamic);
        final post = PostModel(
          title: data['titulo'] ?? '',
          createdAt: data['createdAt'] ?? Timestamp.now(),
          coverPhoto: data['coverPhoto'] ?? '',
          description: data['descricao'] ?? '',
          imagens: imagens,
          id: festouSnap.id,
        );

        postModels.insert(0, post);
      }

      // Filtra os posts para remover aqueles que o usuário já leu
      postModels.removeWhere((post) => seenPostsIds.contains(post.id));

      return postModels;
    } catch (e) {
      log('Erro ao recuperar dados: $e');
      return null;
    }
  }

  Future<List<PostModel>> getSeenPosts() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return [];
    }

    try {
      // Obtém o documento do usuário
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return [];
      }

      DocumentSnapshot userDoc = userSnapshot.docs.first;

      // Obtém a lista de posts já vistos pelo usuário
      List<dynamic> seenPostsDynamic = userDoc['seenPostsIds'] ?? [];
      List<String> seenPostsIds = List<String>.from(seenPostsDynamic);

      if (seenPostsIds.isEmpty) {
        return [];
      }

      List<PostModel> seenPosts = [];

      // Busca todos os documentos na coleção "posts"
      QuerySnapshot spacesSnapshot = await firestore.collection('posts').get();

      for (var spaceDoc in spacesSnapshot.docs) {
        // Acessa a subcoleção "posts" dentro de cada espaço
        QuerySnapshot postsSnapshot =
            await spaceDoc.reference.collection('posts').get();

        for (var postDoc in postsSnapshot.docs) {
          if (seenPostsIds.contains(postDoc.id)) {
            final data = postDoc.data() as Map<String, dynamic>;
            final imagensDynamic = data['imagens'] as List<dynamic>;
            final imagens = List<String>.from(imagensDynamic);

            final post = PostModel(
              title: data['titulo'] ?? '',
              createdAt: data['createdAt'] ?? Timestamp.now(),
              description: data['descricao'] ?? '',
              coverPhoto: data['coverPhoto'] ?? '',
              imagens: imagens,
              id: postDoc.id,
            );

            seenPosts.add(post);
          }
        }
      }

      return seenPosts;
    } catch (e) {
      log('Erro ao recuperar posts lidos: $e');
      return [];
    }
  }
}
