import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpacesByTypeVm extends ChangeNotifier {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  List<SpaceModel>? _filteredList;
  List<SpaceModel>? _allSpacesByType;
  List<SpaceModel>? getFiltered() => _filteredList;
  List<SpaceModel>? getSpaces() => _allSpacesByType;
  bool showSpacesByType = true;
  bool showFiltered = true;
  final controller = TextEditingController();

  Future init(List<String> type) async {
    _allSpacesByType = await getSpacesByType(type);
    notifyListeners();
  }

  void clear() {
    controller.clear();
    showSpacesByType = true;
    showFiltered = false;
    notifyListeners();
  }
  //so pode comecar

  void onChangedSearch(String value) {
    if (value == '') {
      showSpacesByType = true;
      showFiltered = false;
      notifyListeners();
    } else {
      showSpacesByType = false;
      showFiltered = true;
      notifyListeners();
    }

    String searchValue = value.toLowerCase();

    _filteredList = _allSpacesByType!
        .where((project) => project.titulo.toLowerCase().contains(searchValue))
        .toList();
    notifyListeners();
  }

  Future<List<SpaceModel>> getSpacesByType(List<String> types) async {
    try {
      // Consulta espaços onde o campo "selectedTypes" contenha pelo menos um dos tipos da lista.
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .get();

      final userSpacesFavorite = await getUserFavoriteSpaces();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      List<SpaceModel> spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;

        return mapSpaceDocumentToModel(
          spaceDocument,
          isFavorited,
        );
      }).toList());

      return spaceModels;
    } catch (e) {
      log('Erro ao recuperar espaços por tipo: $e');
      return [];
    }
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
