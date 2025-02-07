import 'dart:async';
import 'dart:developer';
import 'dart:io';

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

  void cancelSpaceSubscription() {
    spaceSubscription?.cancel();
  }

  StreamSubscription? spaceSubscription;

  Future<void> setSpaceListener(
    String spaceId,
    void Function(SpaceModel space) onNewSnapshot,
  ) async {
    final query = spacesCollection.where('space_id', isEqualTo: spaceId);

    spaceSubscription = query.snapshots().skip(1).listen((snapshot) async {
      if (snapshot.docs.isEmpty || snapshot.docs.first.data() == null) return;
      final userSpacesFavorite = await getUserFavoriteSpaces();
      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final isFavorited =
          userSpacesFavorite?.contains(data['space_id']) ?? false;

      final space = await mapSpaceDocumentToModel(doc, isFavorited);
      onNewSnapshot(space);
    });
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

  Future<void> updateSpace({
    required Map<String, dynamic> newSpaceInfos,
    required List<String> networkImagesToDelete,
    required List<String> networkVideosToDelete,
    required List<File> imageFilesToDownload,
    required List<File> videosToDownload,
    required String spaceId,
  }) async {
    QuerySnapshot querySnapshot = await spacesCollection
        .where(
          "space_id",
          isEqualTo: spaceId,
        )
        .get();

    if (querySnapshot.docs.length == 1) {
      DocumentReference spaceDocRef = querySnapshot.docs[0].reference;

      // Atualize o documento do usuário com os novos dados
      await spaceDocRef.update(newSpaceInfos);
      //todo: update latitude and longitude too

      log('Informações de usuário adicionadas com sucesso!');
    } else if (querySnapshot.docs.isEmpty) {
      // Nenhum documento com o userId especificado foi encontrado
      log('Usuário não encontrado no firestore.');
    }
  }

  Future<List<SpaceModel>?> getMySpaces() async {
    try {
      //espaços a serem buildado
      final mySpaceDocuments =
          await spacesCollection.where('user_id', isEqualTo: user.uid).get();

      List<SpaceModel> spaceModels =
          await Future.wait(mySpaceDocuments.docs.map((spaceDocument) {
        return mapSpaceDocumentToModel(spaceDocument, false);
      }).toList());

      return spaceModels;
    } catch (e) {
      log('Erro ao recuperar meus espaços: $e');
      throw RepositoryException(message: 'Erro ao carregar meus espaços');
    }
  }

  Future<void> toggleFavoriteSpace(String spaceId, bool isFavorited) async {
    try {
      // Busca o documento do usuário
      QuerySnapshot querySnapshot =
          await usersCollection.where("uid", isEqualTo: user.uid).get();

      if (querySnapshot.docs.length == 1) {
        final userDocument = querySnapshot.docs.first;

        // Atualiza o documento do usuário
        if (isFavorited) {
          await userDocument.reference.update({
            'spaces_favorite': FieldValue.arrayUnion([spaceId]),
          });
          log('sucesso! - add -  $spaceId');
        } else {
          await userDocument.reference.update({
            'spaces_favorite': FieldValue.arrayRemove([spaceId]),
          });
          log('sucesso! - removed -  $spaceId');
        }

        // Busca o documento do espaço pelo space_id
        QuerySnapshot spaceSnapshot = await spacesCollection
            .where('space_id', isEqualTo: spaceId)
            .limit(1)
            .get();

        if (spaceSnapshot.docs.isNotEmpty) {
          final spaceDocument = spaceSnapshot.docs.first;

          // Atualiza o campo num_likes no documento do espaço
          if (isFavorited) {
            await spaceDocument.reference.update({
              'num_likes': FieldValue.increment(1),
            });
          } else {
            await spaceDocument.reference.update({
              'num_likes': FieldValue.increment(-1),
            });
          }
        } else {
          log('Nenhum documento do espaço foi encontrado.');
          throw RepositoryException(
              message: 'Espaço não encontrado no banco de dados');
        }
      } else {
        log('Nenhum documento de usuário foi encontrado, ou mais de 1 foi encontrado.');

        throw RepositoryException(
            message: 'Usuário não encontrado no banco de dados');
      }
    } catch (e) {
      log('Erro ao atualizar o espaço favorito: $e');
      throw RepositoryException(message: 'Erro ao atualizar o espaço favorito');
    }
  }
}
