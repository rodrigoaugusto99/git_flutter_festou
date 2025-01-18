import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class ReservaService {
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservations');

  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
  Future saveReservation({required ReservationModel reservationModel}) async {
    try {
      Map<String, dynamic> newReservation = {
        'client_id': reservationModel.clientId,
        'locador_id': reservationModel.locadorId,
        'space_id': reservationModel.spaceId,
        'checkInTime': reservationModel.checkInTime,
        'checkOutTime': reservationModel.checkOutTime,
        'selectedDate': reservationModel.selectedDate,
        'selectedFinalDate': reservationModel.selectedFinalDate,
        'contratoHtml': reservationModel.contratoHtml,
        'cardId': reservationModel.cardId,
        'reason': reservationModel.reason,
        'createdAt': Timestamp.now(),
        'canceledAt': null,
      };

      await reservationCollection.add(newReservation);
      log('Reserva feita com sucesso!');
    } catch (e) {
      log('Erro ao reservar espaço: $e');
    }
  }

  Future<void> cancelReservation(String reservationId, String reason) async {
    try {
      await reservationCollection.doc(reservationId).update({
        'canceledAt': FieldValue.serverTimestamp(),
        'reason': reason,
      });
      log('Reserva cancelada com sucesso.');
    } catch (e) {
      log('Erro ao cancelar a reserva: $e');
      rethrow; // Opcional: reenvia o erro para ser tratado externamente
    }
  }

  ReservationModel mapReservationDocumentToModel(
      QueryDocumentSnapshot reservationDocument) {
    return ReservationModel(
      id: reservationDocument.id,
      spaceId: reservationDocument['space_id'] ?? '',
      canceledAt: reservationDocument['canceledAt'],
      clientId: reservationDocument['client_id'] ?? '',
      locadorId: reservationDocument['locador_id'] ?? '',
      checkInTime: reservationDocument['checkInTime'] ?? '',
      checkOutTime: reservationDocument['checkOutTime'] ?? '',
      selectedFinalDate: reservationDocument['selectedFinalDate'] ?? '',
      selectedDate: reservationDocument['selectedDate'] ?? '',
      createdAt: reservationDocument['createdAt'] ?? '',
      contratoHtml: reservationDocument['contratoHtml'] ?? '',
      reason: reservationDocument['reason'] ?? '',
    );
  }

  // Future<DocumentSnapshot> getUserDocumentById(String userId) async {
  //   final userDocument =
  //       await usersCollection.where('uid', isEqualTo: userId).get();

  //   if (userDocument.docs.isNotEmpty) {
  //     return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
  //   }

  //   // Trate o caso em que nenhum usuário foi encontrado.
  //   throw Exception("Usuário não encontrado");
  // }

  Future<List<ReservationModel>> getReservationsByLocadorId(
    String userId,
  ) async {
    try {
      // Referência à coleção 'reservations'
      CollectionReference reservationsCollection =
          FirebaseFirestore.instance.collection('reservations');

      // Query para buscar documentos onde o campo 'locador_id' é igual ao 'userId'
      QuerySnapshot querySnapshot = await reservationsCollection
          .where('locador_id', isEqualTo: userId)
          .get();

      // Transformar os documentos em objetos do tipo ReservationModel
      List<ReservationModel> reservationModels = querySnapshot.docs.map((doc) {
        return mapReservationDocumentToModel(doc);
      }).toList();

      return reservationModels;
    } catch (e) {
      // Em caso de erro, lançar a exceção
      throw Exception(e);
    }
  }

  Future<List<ReservationModel>> getReservationsBySpaceId(
      String spaceId) async {
    try {
      final allReservationsDocuments = await reservationCollection
          .where('space_id', isEqualTo: spaceId)
          .get();

      List<ReservationModel> reservationModels =
          allReservationsDocuments.docs.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();
      return reservationModels;
    } catch (e) {
      log('Erro ao recuperar as reservas do firestore: $e');
      throw Exception(e);
    }
  }

  Future<List<ReservationModel>> getReservationsByClienId() async {
    try {
      final allReservationsDocuments = await reservationCollection
          .where('client_id', isEqualTo: user.uid)
          .get();

      List<ReservationModel> reservationModels =
          allReservationsDocuments.docs.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();
      return reservationModels;
    } catch (e) {
      log('Erro ao recuperar as reservas do firestore: $e');
      throw Exception(e);
    }
  }
}
