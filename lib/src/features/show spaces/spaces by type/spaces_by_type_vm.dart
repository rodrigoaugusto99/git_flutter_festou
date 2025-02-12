import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Festou/src/models/space_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SpacesByTypeVm extends ChangeNotifier {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  List<SpaceModel> _filteredList = [];
  List<SpaceModel>? _allSpacesByType;

  List<SpaceModel> get getFiltered => _filteredList;
  List<SpaceModel>? get getSpaces => _allSpacesByType;

  bool showSpacesByType = true;
  bool showFiltered = false;
  final controller = TextEditingController();

  final PagingController<DocumentSnapshot?, SpaceModel> pagingController =
      PagingController(firstPageKey: null);

  static const int pageSize = 3;

  SpacesByTypeVm() {
    pagingController.addPageRequestListener((pageKey) {
      fetchSpaces(pageKey);
    });
  }

  Future init(List<String> type) async {
    _allSpacesByType = await getSpacesByType(type);
    notifyListeners();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  void clear() {
    controller.clear();
    showSpacesByType = true;
    showFiltered = false;
    _filteredList.clear();
    notifyListeners();
  }

  Future<void> onChangedSearch(String value, List<String> types) async {
    if (value.isEmpty) {
      showSpacesByType = true;
      showFiltered = false;
      _filteredList.clear();
      notifyListeners();
      return;
    }

    try {
      // 🔹 Atualiza UI antes de buscar (garante que lista anterior some)
      showSpacesByType = false;
      showFiltered = true;
      _filteredList.clear();
      notifyListeners();

      String searchValue = value.toLowerCase();

      final searchSpaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .orderBy('createdAt', descending: true)
          .get();

      final userSpacesFavorite = await getUserFavoriteSpaces();

      List<SpaceModel> searchResults = [];

      for (var doc in searchSpaceDocuments.docs) {
        final titulo = doc['titulo']?.toString().toLowerCase() ?? '';
        if (titulo.contains(searchValue)) {
          final isFavorited =
              userSpacesFavorite?.contains(doc['space_id']) ?? false;
          SpaceModel space = await mapSpaceDocumentToModel(doc, isFavorited);
          searchResults.add(space);
        }
      }

      _filteredList = searchResults;
      notifyListeners(); // 🔥 Garante que a UI receba a atualização
    } catch (e) {
      log("❌ Erro ao buscar espaços por título: $e");
    }
  }

  Future<List<SpaceModel>> getSpacesByType(List<String> types) async {
    try {
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .get();

      final userSpacesFavorite = await getUserFavoriteSpaces();

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

  Future<void> fetchInitialSpaces(List<String> types) async {
    try {
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .orderBy('createdAt', descending: true)
          .limit(pageSize)
          .get();

      if (spaceDocuments.docs.isEmpty) {
        log("No initial spaces found.");
        _allSpacesByType = [];
        notifyListeners();
        return;
      }

      final userSpacesFavorite = await getUserFavoriteSpaces();

      List<SpaceModel> initialSpaces =
          await Future.wait(spaceDocuments.docs.map((doc) {
        final isFavorited =
            userSpacesFavorite?.contains(doc['space_id']) ?? false;
        return mapSpaceDocumentToModel(doc, isFavorited);
      }).toList());

      // **🚨 Atualiza _allSpacesByType antes de notificar**
      _allSpacesByType = initialSpaces;
      notifyListeners();

      // **Atualiza o PagingController**
      final DocumentSnapshot? lastDoc = spaceDocuments.docs.last;
      pagingController.appendPage(initialSpaces, lastDoc);

      log("PagingController updated. Current items: ${pagingController.itemList?.length ?? 0}"); // 🛑 Depuração
    } catch (e) {
      log("Error fetching initial spaces: $e");
      pagingController.error = e;
    }
  }

  Future<void> fetchSpaces(DocumentSnapshot? lastDocument) async {
    log("🔄 Iniciando fetchSpaces()...");

    try {
      Query query = spacesCollection
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        log("📌 Usando lastDocument para paginação: ${lastDocument.id}");
        query = query.startAfterDocument(lastDocument);
      } else {
        log("⚠️ Nenhum lastDocument, pegando primeira página.");
      }

      final querySnapshot = await query.get();
      log("📌 Documentos retornados: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isEmpty) {
        log("✅ Nenhum novo documento encontrado. Fim da paginação.");
        pagingController
            .appendLastPage([]); // 🚨 Finaliza paginação corretamente
        return;
      }

      await Future.delayed(const Duration(seconds: 2)); // Simulação de atraso

      final List<SpaceModel> newSpaces = querySnapshot.docs.map((doc) {
        log("📌 Convertendo documento para SpaceModel: ${doc.id}");
        return SpaceModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // **🔹 Pegamos o último DocumentSnapshot corretamente**
      final DocumentSnapshot? lastDoc = getLastDocument(querySnapshot);
      log("📌 Último documento desta página: ${lastDoc?.id ?? 'null'}");

      // **🔹 Agora adicionamos corretamente os itens paginados**
      pagingController.appendPage(newSpaces, lastDoc);
    } catch (e, stacktrace) {
      log("❌ Erro em fetchSpaces(): $e");
      log("🔍 Stacktrace: $stacktrace");
      pagingController.error = e;
    }
  }

  DocumentSnapshot? getLastDocument(QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isEmpty) return null;
    return querySnapshot
        .docs.last; // 🚨 Retorna o último DocumentSnapshot corretamente
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0];
    }

    throw Exception("Usuário não encontrado");
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
