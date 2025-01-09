import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceService {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
  Future<SpaceModel?> getSpaceById(String spaceId) async {
    try {
      final mySpaceDocument =
          await spacesCollection.where('space_id', isEqualTo: spaceId).get();

      if (mySpaceDocument.docs.isEmpty) return null;
      //favoritos do usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();
      final doc = mySpaceDocument.docs.first;
      final isFavorited =
          userSpacesFavorite?.contains(doc['space_id']) ?? false;
      return mapSpaceDocumentToModel(doc, isFavorited);
    } catch (e) {
      log('Erro ao recuperar meus espaços: $e');
      throw RepositoryException(message: 'Erro ao carregar meus espaços');
    }
  }

  Future<List<String>?> getUserFavoriteSpaces() async {
    final userDocument = await getUserDocument();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }

  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    //se esse erro ocorrer la numm metodo que chama getUsrDocument, o (e) do catch vai ter essa msg
    throw Exception("Usuário n encontrado");
    //! erro as vezes, se deletar a conta com google e criar de novo rapidao, o
    //!documento no firestore e auth estão certos, com o mesmo id, mas o objeto user do auth que o programa
    //!carrega primeiramente é o anterior já excluido, com o uid antigo
  }
}
