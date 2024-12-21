import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_state.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class MyFavoriteSpacesVm extends ChangeNotifier {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');
  List<SpaceModel>? allSpaces;
  bool isLoading = true;
  Future init() async {
    isLoading = true;
    allSpaces = await getMyFavoriteSpaces();
    log(allSpaces.toString());
    isLoading = false;
    notifyListeners();
  }

  Future<List<SpaceModel>?> getMyFavoriteSpaces() async {
    try {
      //lista de espaços favoritados pelo usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();

      if (userSpacesFavorite != null && userSpacesFavorite.isNotEmpty) {
        final favoriteSpaceDocuments = await spacesCollection
            .where('space_id', whereIn: userSpacesFavorite)
            .get();

        List<SpaceModel> spaceModels = await Future.wait(
          favoriteSpaceDocuments.docs.map((spaceDocument) async {
            final isFavorited =
                userSpacesFavorite.contains(spaceDocument['space_id']);
            return await mapSpaceDocumentToModel(spaceDocument, isFavorited);
          }),
        );

        return spaceModels;
      } //tratando caso emm que nao há espaços favoritados pelo usario
    } catch (e) {
      log('Erro ao recuperar meus espaços favoritos: $e');
      return null;
    }
    return null;
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    //se esse erro ocorrer la numm metodo que chama getUsrDocument, o (e) do catch vai ter essa msg
    throw Exception("Usuário n encontrado");
  }

  Future<List<String>?> getUserFavoriteSpaces() async {
    final userDocument = await getUserDocument();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }
}
