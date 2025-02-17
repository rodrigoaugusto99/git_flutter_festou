import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_and_order_vm.g.dart';

@riverpod
class FilterAndOrderVm extends _$FilterAndOrderVm {
  List<SpaceModel> spacesFilterType = [];
  List<SpaceModel> spacesFilterService = [];
  List<SpaceModel> spacesFilterDays = [];
  String errorMessage = '';
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;

  void addOrRemoveNote(String note) {
    final allNotes = ['1', '2', '3', '4', '5'];
    final selectedNotes = <String>[];

    // Remover o '+' da nota clicada
    String cleanNote = note.replaceAll('+', '');

    // Encontrar o índice da nota clicada
    int startIndex = allNotes.indexOf(cleanNote);

    // Adicionar todas as notas a partir do índice da nota clicada
    if (startIndex != -1) {
      // Verifica se o índice é válido
      for (int i = startIndex; i < allNotes.length; i++) {
        selectedNotes.add(allNotes[i]);
      }
    }

    // Atualizar o estado com as novas notas selecionadas
    state = state.copyWith(
        selectedNotes: selectedNotes,
        status: FilterAndOrderStateStatus.initial);

    log(selectedNotes.toString());
  }

  void addOrRemoveAvailableDay(String weekDay) {
    final availableDays = state.availableDays;

    if (availableDays.contains(weekDay)) {
      availableDays.remove(weekDay);
    } else {
      availableDays.add(weekDay);
    }

    state = state.copyWith(
        availableDays: availableDays,
        status: FilterAndOrderStateStatus.initial);
  }

  void addOrRemoveType(String type) {
    final selectedTypes = state.selectedTypes;

    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }

    state = state.copyWith(
        selectedTypes: selectedTypes,
        status: FilterAndOrderStateStatus.initial);
  }

  void addOrRemoveService(String service) {
    final selectedServices = state.selectedServices;

    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    state = state.copyWith(
        selectedServices: selectedServices,
        status: FilterAndOrderStateStatus.initial);
  }

  void redefinir() {
    state = state.copyWith(
      status: FilterAndOrderStateStatus.initial,
      selectedServices: [],
      selectedTypes: [],
      availableDays: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'],
      selectedNotes: [],
    );
  }

  @override
  FilterAndOrderState build() => FilterAndOrderState.initial();

  Future<void> filter() async {
    final FilterAndOrderState(
      :selectedTypes,
      :availableDays,
      :selectedServices,
      :selectedNotes
    ) = state;

    Query query = FirebaseFirestore.instance
        .collection('spaces')
        .where('deletedAt', isNull: true);

    List<DocumentSnapshot> filteredByDays = [];

    if (availableDays.isNotEmpty) {
      // Mapa para traduzir os dias
      const Map<String, String> daysMap = {
        "Seg": "monday",
        "Ter": "tuesday",
        "Qua": "wednesday",
        "Qui": "thursday",
        "Sex": "friday",
        "Sab": "saturday",
        "Dom": "sunday",
      };

      // Pegar o primeiro dia e traduzi-lo
      String? translatedDay = daysMap[availableDays.first];
      if (translatedDay == null) {
        log("Dia não reconhecido: ${availableDays.first}");
        // return;
      }
      // Use apenas o primeiro dia para a consulta inicial
      query = query.where('weekdays.$translatedDay', isNull: false);

      QuerySnapshot daysSnapshot = await query.get();
      filteredByDays = daysSnapshot.docs;

      filteredByDays.removeWhere((doc) {
        return availableDays.any((day) {
          String? translatedDay = daysMap[day];
          // Verifique se a chave traduzida existe e não é nula
          return translatedDay != null &&
              doc['weekdays'][translatedDay] == null;
        });
      });
      log("xx");
    }

    // Step 2: Filter by selectedServices
    filteredByDays = filteredByDays.where((doc) {
      List<dynamic> services = doc['selectedServices'];
      return selectedServices.every((service) => services.contains(service));
    }).toList();

    log("xx");

    // Step 3: Filter by selectedTypes
    List<DocumentSnapshot> finalFiltered = filteredByDays.where((doc) {
      List<dynamic> types = doc['selectedTypes'];
      return selectedTypes.every((type) => types.contains(type));
    }).toList();

    log("xx");

    final userSpacesFavorite = await getUserFavoriteSpaces();

    // Map the finalFiltered documents to SpaceModel objects
    List<SpaceModel> spaceModels = [];
    spaceModels = await Future.wait(finalFiltered.map((spaceDocument) {
      final isFavorited =
          userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
      return mapSpaceDocumentToModel2(spaceDocument, isFavorited);
    }).toList());

    // Step 4: Filter by selectedNotes
    if (selectedNotes.isNotEmpty) {
      if (selectedNotes.contains("1")) {
        selectedNotes.add('0');
      }
      // Convert selectedNotes to double and find the minimum value
      double minSelectedNote = selectedNotes
          .map((note) => double.parse(note.replaceAll('+', '')))
          .reduce((a, b) => a < b ? a : b);
      log(minSelectedNote.toString());
      spaceModels = spaceModels.where((space) {
        double averageRating = double.parse(space.averageRating);
        //double averageRating2 = double.parse(doc['average_rating']);
        log('averageRating.toString()');
        log(averageRating.toString());
        return averageRating >= minSelectedNote;
      }).toList();
    }
    log(spaceModels.length.toString());
    for (final space in spaceModels) {
      log(space.spaceId);
    }
    state = state.copyWith(
      status: FilterAndOrderStateStatus.success,
      filteredSpaces: spaceModels,
    );
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
