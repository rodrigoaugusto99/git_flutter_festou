import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future init() async {
    _allSpaces = await getAllSpaces();

    notifyListeners();
  }

  void onClick(bool thisBool) {
    _isShowing = thisBool;

    notifyListeners();
  }

  void onChangedSearch(String value) {
    if (value == '') {
      _isShowing = false;
      notifyListeners();
    }
    String searchValue = value.toLowerCase();

    _filteredList = _allSpaces
        .where((project) => project.titulo.toLowerCase().contains(searchValue))
        .toList();
    notifyListeners();
    // Adicionando a busca ao histórico
  }

  Future<List<SpaceModel>> getAllSpaces() async {
    try {
      //pega todos os documentos dos espaços
      final allSpaceDocuments = await spacesCollection.get();

//await pois retorna future
//pega os favoritos do usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();

/*percorre todos os espaços levando em conta os favoritos
p decidir o isFavorited*/

//todo: mapSpaceDocumentToModel ajustado
      List<SpaceModel> spaceModels =
          await Future.wait(allSpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return spaceModels;
    } catch (e) {
      log('Erro ao recuperar todos os espaços: $e');
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

  Future<SpaceModel> mapSpaceDocumentToModel(
    QueryDocumentSnapshot spaceDocument,
    bool isFavorited,
  ) async {
    //pegando os dados necssarios antes de crior o card
    List<String> selectedTypes =
        List<String>.from(spaceDocument['selectedTypes'] ?? []);
    List<String> selectedServices =
        List<String>.from(spaceDocument['selectedServices'] ?? []);
    List<String> imagesUrl =
        List<String>.from(spaceDocument['images_url'] ?? []);

    String spaceId = spaceDocument.get('space_id');
    //String userId = spaceDocument.get('user_id');
    final averageRating = await getAverageRating(spaceId);
    final numComments = await getNumComments(spaceId);
    //final locadorName = await getLocadorName(userId);

//?função para capturar a lista de imagens desse espaço

    return SpaceModel(
      isFavorited,
      spaceDocument['space_id'] ?? '',
      spaceDocument['user_id'] ?? '',
      spaceDocument['titulo'] ?? '',
      spaceDocument['cep'] ?? '',
      spaceDocument['logradouro'] ?? '',
      spaceDocument['numero'] ?? '',
      spaceDocument['bairro'] ?? '',
      spaceDocument['cidade'] ?? '',
      selectedTypes,
      selectedServices,
      averageRating,
      numComments,
      spaceDocument['locador_name'] ?? '',
      spaceDocument['descricao'] ?? '',
      spaceDocument['city'] ?? '',
      //imagesData,
      imagesUrl,
      spaceDocument['latitude'] ?? '',
      spaceDocument['longitude'] ?? '',
      spaceDocument['locadorAvatarUrl'] ?? '',
      spaceDocument['startTime'] ?? '',
      spaceDocument['endTime'] ?? '',
      spaceDocument['days'] ?? [],
      spaceDocument['preco'] ?? '',
    );
  }

  Future<String> getAverageRating(String spaceId) async {
    final spaceDocument =
        await spacesCollection.where('space_id', isEqualTo: spaceId).get();

    if (spaceDocument.docs.isNotEmpty) {
      String averageRatingValue = spaceDocument.docs.first['average_rating'];
      return averageRatingValue;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }

  Future<String> getNumComments(String spaceId) async {
    final spaceDocument =
        await spacesCollection.where('space_id', isEqualTo: spaceId).get();

    if (spaceDocument.docs.isNotEmpty) {
      String numComments = spaceDocument.docs.first['num_comments'];
      return numComments;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }
}
