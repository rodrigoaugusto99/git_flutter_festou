import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Festou/src/models/reservation_model.dart';

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
        'hasReview': false,
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
      hasReview: reservationDocument['hasReview'] ?? false,
      selectedFinalDate: reservationDocument['selectedFinalDate'] ?? '',
      selectedDate: reservationDocument['selectedDate'] ?? '',
      createdAt: reservationDocument['createdAt'] ?? '',
      contratoHtml: reservationDocument['contratoHtml'] ?? '',
      reason: reservationDocument['reason'] ?? '',
    );
  }

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

  Future<List<ReservationModel>> getReservationsByClientId() async {
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

  Future<List<ReservationModel>> getReservationsByClientIdAndSpaceId(
      String spaceId) async {
    try {
      final allReservationsDocuments = await reservationCollection
          .where('client_id', isEqualTo: user.uid)
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

  Future<void> updateHasReview(String reservationId, bool hasReview) async {
    try {
      await reservationCollection.doc(reservationId).update({
        'hasReview': hasReview,
      });
      log('Campo hasReview atualizado para $hasReview na reserva: $reservationId');
    } catch (e) {
      log('Erro ao atualizar o campo hasReview: $e');
      throw Exception(e);
    }
  }

  void cancelReservationListener() {
    reservationSubscription?.cancel();
  }

  StreamSubscription? reservationSubscription;

  Future<void> setReservationListener(
    String spaceId,
    String userId,
    void Function(ReservationModel?) onNewSnapshot,
  ) async {
    final query = FirebaseFirestore.instance
        .collection('reservations')
        .where('space_id', isEqualTo: spaceId)
        .where('canceledAt', isEqualTo: null)
        .where('hasReview', isEqualTo: false)
        .where('client_id', isEqualTo: userId)
        .limit(1);

    reservationSubscription = query.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        onNewSnapshot(null); // Nenhuma reserva encontrada
        return;
      }

      final reservation = ReservationModel.fromFirestore(snapshot.docs.first);
      onNewSnapshot(reservation);
    });
  }
}
