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
