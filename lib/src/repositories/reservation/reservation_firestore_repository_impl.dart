import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';

import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:intl/intl.dart';

import './reservation_firestore_repository.dart';

class ReservationFirestoreRepositoryImpl
    implements ReservationFirestoreRepository {
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservations');

  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Future<Either<RepositoryException, Nil>> saveReservation(
    ({
      String userId,
      String spaceId,
      String range,
    }) reservationData,
  ) async {
    final currentDateTime = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDateTime = dateFormat.format(currentDateTime);
    try {
      Map<String, dynamic> newReservation = {
        'user_id': reservationData.userId,
        'space_id': reservationData.spaceId,
        'range': reservationData.range,
        'date': formattedDateTime,
        'status': 'solicitado',
      };

      await reservationCollection.add(newReservation);
      log('Reserva feita com sucesso!');

      return Success(nil);
    } catch (e) {
      log('Erro ao reservar espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao avaliar espaço'));
    }
  }

  @override
  Future<Either<RepositoryException, List<ReservationModel>>> getReservations(
      String spaceId) async {
    try {
      final allReservationsDocuments = await reservationCollection
          .where('space_id', isEqualTo: spaceId)
          .get();

      List<ReservationModel> reservationModels =
          allReservationsDocuments.docs.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();
      return Success(reservationModels);
    } catch (e) {
      log('Erro ao recuperar as reservas do firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar as reservas'));
    }
  }

  ReservationModel mapReservationDocumentToModel(
      QueryDocumentSnapshot reservationDocument) {
    return ReservationModel(
      spaceId: reservationDocument['space_id'] ?? '',
      userId: reservationDocument['user_id'] ?? '',
      range: reservationDocument['range'] ?? '',
      date: reservationDocument['date'] ?? '',
      status: reservationDocument['status'] ?? '',
    );
  }

  @override
  Future<Either<RepositoryException, List<ReservationModel>>>
      getMyReservedClients() async {
    //espaços com meu id
    try {
      final mySpacesDocuments =
          await spacesCollection.where('user_id', isEqualTo: user.uid).get();
//qual o melhor tipo p ess lista? e se for ReservaModel logo?
      // Lista para armazenar todos os documentos de reservas
      List<QueryDocumentSnapshot> allReservations = [];

      // Iterar sobre os documentos de espaços
      for (var spaceDocument in mySpacesDocuments.docs) {
        // Recuperar o space_id do documento de espaço
        String spaceId = spaceDocument['space_id'];

        // Consultar as reservas com base no space_id
        final reservationsQuery = await reservationCollection
            .where('space_id', isEqualTo: spaceId)
            .get();

        // Adicionar todos os documentos de reservas à lista
        allReservations.addAll(reservationsQuery.docs);
      }

      List<ReservationModel> reservationModels =
          allReservations.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();

      // Retornar a lista de documentos de reservas
      return Success(reservationModels);
    } catch (e) {
      log('Erro ao recuperar as reservas dos meus espaços: $e');
      return Failure(RepositoryException(
          message: 'Erro ao carregar as reservas dos meus espaços'));
    }
  }

  @override
  Future<Either<RepositoryException, List<ReservationModel>>> getMyReservations(
      String userId) async {
    try {
      final allReservationsDocuments =
          await reservationCollection.where('user_id', isEqualTo: userId).get();

      List<ReservationModel> reservationModels =
          allReservationsDocuments.docs.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();
      return Success(reservationModels);
    } catch (e) {
      log('Erro ao recuperar as reservas que eu fiz do firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar as minhas reservas'));
    }
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
  }

  Future<List<String>?> getUserFavoriteSpaces() async {
    final userDocument = await getUserDocument();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }

  Future<List<ReservationModel>?> getMyReservations2(String userId) async {
    try {
      final allReservationsDocuments =
          await reservationCollection.where('user_id', isEqualTo: userId).get();

      List<ReservationModel> reservationModels =
          allReservationsDocuments.docs.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();
      return reservationModels;
    } catch (e) {
      log('Erro ao recuperar as reservas que eu fiz do firestore: $e');
      return null;
    }
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

  //todo: buildar levando em conta espaços e lista de favoritos
  Future<SpaceModel> mapSpaceDocumentToModel(
    QueryDocumentSnapshot spaceDocument,
    bool isFavorited,
  ) async {
    // Pegando os dados necessários antes de criar o card
    List<String> selectedTypes =
        List<String>.from(spaceDocument['selectedTypes'] ?? []);
    List<String> selectedServices =
        List<String>.from(spaceDocument['selectedServices'] ?? []);
    List<String> imagesUrl =
        List<String>.from(spaceDocument['images_url'] ?? []);
    List<String> days = List<String>.from(spaceDocument['days'] ?? []);

    String spaceId = spaceDocument.get('space_id');
    final averageRating = await getAverageRating(spaceId);
    final numComments = await getNumComments(spaceId);

    return SpaceModel(
      isFavorited: isFavorited,
      spaceId: spaceDocument['space_id'] ?? '',
      userId: spaceDocument['user_id'] ?? '',
      titulo: spaceDocument['titulo'] ?? '',
      cep: spaceDocument['cep'] ?? '',
      logradouro: spaceDocument['logradouro'] ?? '',
      numero: spaceDocument['numero'] ?? '',
      bairro: spaceDocument['bairro'] ?? '',
      cidade: spaceDocument['cidade'] ?? '',
      selectedTypes: selectedTypes,
      selectedServices: selectedServices,
      averageRating: averageRating,
      numComments: numComments,
      locadorName: spaceDocument['locador_name'] ?? '',
      descricao: spaceDocument['descricao'] ?? '',
      city: spaceDocument['city'] ?? '',
      imagesUrl: imagesUrl,
      latitude: spaceDocument['latitude'] ?? 0.0,
      longitude: spaceDocument['longitude'] ?? 0.0,
      locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
      startTime: spaceDocument['startTime'] ?? '',
      endTime: spaceDocument['endTime'] ?? '',
      days: days,
      preco: spaceDocument['preco'] ?? '',
      cnpjEmpresaLocadora: spaceDocument['cnpj_empresa_locadora'] ?? '',
      estado: spaceDocument['estado'] ?? '',
      locadorCpf: spaceDocument['locador_cpf'] ?? '',
      nomeEmpresaLocadora: spaceDocument['nome_empresa_locadora'] ?? '',
      locadorAssinatura: spaceDocument['locador_assinatura'] ?? '',
      numLikes: spaceDocument['num_likes'] ?? 0,
    );
  }

  Future<SpaceModel?> getSpaceById(String id) async {
    try {
      // Consulta espaços onde o campo "selectedTypes" contenha pelo menos um dos tipos da lista.
      final spaceDocuments =
          await spacesCollection.where('space_id', isEqualTo: id).get();

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

      return spaceModels.first;
    } catch (e) {
      log('Erro ao recuperar espaços por tipo: $e');
      return null;
    }
  }
}
