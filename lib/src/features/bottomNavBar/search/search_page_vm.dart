import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SearchViewModel extends ChangeNotifier {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  List<SpaceModel> _filteredList = [];
  final List<String> _searchHistory = [];

  bool _isShowing = false;

  bool getIsShowingBool() => _isShowing;
  List<SpaceModel> getSpaces() => _filteredList;
  List<String> getHistoric() => _searchHistory;

  List<SpaceModel> _allSpaces = [];

  Future<void> init() async {
    _allSpaces = []; // Inicializa vazia para evitar carregamento automático
    _filteredList = [];
    notifyListeners();
  }

  void onChangedSearch(String value) {
    if (value.trim().isEmpty) {
      _isShowing = false;
      _filteredList = []; // Limpa a lista quando não há texto digitado
    } else {
      _isShowing = true;
      String searchValue = value.toLowerCase();

      _filteredList = _allSpaces
          .where((space) => space.titulo.toLowerCase().contains(searchValue))
          .toList();
    }
    notifyListeners();
  }

  Future<void> getAllSpaces() async {
    if (_allSpaces.isEmpty) {
      try {
        final allSpaceDocuments = await spacesCollection.get();
        final userSpacesFavorite = await getUserFavoriteSpaces();

        List<SpaceModel> spaceModels =
            await Future.wait(allSpaceDocuments.docs.map((spaceDocument) async {
          final isFavorited =
              userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
          return await mapSpaceDocumentToModel(spaceDocument, isFavorited);
        }).toList());

        _allSpaces = spaceModels;
      } catch (e) {
        log('Erro ao recuperar todos os espaços: $e');
      }
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

  Future<List<SpaceModel>> getPaginatedSpaces(
      int pageKey, int pageSize, String query) async {
    try {
      Query queryBuilder = spacesCollection.orderBy('titulo').limit(pageSize);

      if (query.isNotEmpty) {
        String lowerCaseQuery = query.toLowerCase();
        queryBuilder = queryBuilder
            .where('titulo', isGreaterThanOrEqualTo: lowerCaseQuery)
            .where('titulo', isLessThan: lowerCaseQuery + '\uf8ff');
      }

      if (pageKey > 0) {
        final lastDocSnapshot = await spacesCollection
            .orderBy('titulo')
            .limit(pageKey)
            .get()
            .then((snap) => snap.docs.last);

        queryBuilder = queryBuilder.startAfterDocument(lastDocSnapshot);
      }

      final snapshot = await queryBuilder.get();

      final newSpaces = await Future.wait(snapshot.docs.map((doc) async {
        final isFavorited = _searchHistory.contains(doc['space_id']);
        return await mapSpaceDocumentToModel(doc, isFavorited);
      }));

      return newSpaces;
    } catch (e) {
      log('Erro ao buscar espaços paginados: $e');
      return [];
    }
  }
}
